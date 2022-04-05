Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CED84F3417
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237610AbiDEImy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240983AbiDEIcl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1106A94EC;
        Tue,  5 Apr 2022 01:25:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C871B81BC0;
        Tue,  5 Apr 2022 08:25:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D85C385A1;
        Tue,  5 Apr 2022 08:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147138;
        bh=f19IgujV/yw7D/q+fpx39ycuktKtJQPW23eKnN0ZCdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cgTZpkWWtOLOllwlGPa8SLbkS4MnogXI6nVAB4goYsRyr0lDhgOyzFYP6T2XWqLoG
         EyoavpdQnFFDozoDpjW/1CpUm2kDoNEgPW+hd1zOXVTkj5k2U1jEg2Er1oq1Fa/xyp
         dsoMB8VQFDhMxpTFzf+TXvN9NKNMDREs5sdtM4YE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, PaX Team <pageexec@freemail.hu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.17 1016/1126] wireguard: queueing: use CFI-safe ptr_ring cleanup function
Date:   Tue,  5 Apr 2022 09:29:23 +0200
Message-Id: <20220405070437.308712694@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit ec59f128a9bd4255798abb1e06ac3b442f46ef68 upstream.

We make too nuanced use of ptr_ring to entirely move to the skb_array
wrappers, but we at least should avoid the naughty function pointer cast
when cleaning up skbs. Otherwise RAP/CFI will honk at us. This patch
uses the __skb_array_destroy_skb wrapper for the cleanup, rather than
directly providing kfree_skb, which is what other drivers in the same
situation do too.

Reported-by: PaX Team <pageexec@freemail.hu>
Fixes: 886fcee939ad ("wireguard: receive: use ring buffer for incoming handshakes")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireguard/queueing.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireguard/queueing.c
+++ b/drivers/net/wireguard/queueing.c
@@ -4,6 +4,7 @@
  */
 
 #include "queueing.h"
+#include <linux/skb_array.h>
 
 struct multicore_worker __percpu *
 wg_packet_percpu_multicore_worker_alloc(work_func_t function, void *ptr)
@@ -42,7 +43,7 @@ void wg_packet_queue_free(struct crypt_q
 {
 	free_percpu(queue->worker);
 	WARN_ON(!purge && !__ptr_ring_empty(&queue->ring));
-	ptr_ring_cleanup(&queue->ring, purge ? (void(*)(void*))kfree_skb : NULL);
+	ptr_ring_cleanup(&queue->ring, purge ? __skb_array_destroy_skb : NULL);
 }
 
 #define NEXT(skb) ((skb)->prev)


