Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC2E528F33
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiEPTxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346212AbiEPTux (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:50:53 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E31443CE;
        Mon, 16 May 2022 12:45:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 982BCCE1798;
        Mon, 16 May 2022 19:45:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3EDEC34100;
        Mon, 16 May 2022 19:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730327;
        bh=eWA4IP9jXbZ4Dw5owvga1ugxXXjxeiJvUw4vGvqPllA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0taIAyD32eo4azoyz70fvJscoOHyCt4IX/xoyOKlVqtiS3oI1Z/On/LZ/2PxKSkh8
         DnTxuV+rw8kXpMaeDmAxdj3TFd74vtakoS5NjYdWtOe1TpGNgE7VZ9hmuRNqWKlfG9
         SGtzfjltktU8baqCApIsR7P9WbphfVUx9KIIckoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 29/66] tls: Fix context leak on tls_device_down
Date:   Mon, 16 May 2022 21:36:29 +0200
Message-Id: <20220516193620.257989798@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193619.400083785@linuxfoundation.org>
References: <20220516193619.400083785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

[ Upstream commit 3740651bf7e200109dd42d5b2fb22226b26f960a ]

The commit cited below claims to fix a use-after-free condition after
tls_device_down. Apparently, the description wasn't fully accurate. The
context stayed alive, but ctx->netdev became NULL, and the offload was
torn down without a proper fallback, so a bug was present, but a
different kind of bug.

Due to misunderstanding of the issue, the original patch dropped the
refcount_dec_and_test line for the context to avoid the alleged
premature deallocation. That line has to be restored, because it matches
the refcount_inc_not_zero from the same function, otherwise the contexts
that survived tls_device_down are leaked.

This patch fixes the described issue by restoring refcount_dec_and_test.
After this change, there is no leak anymore, and the fallback to
software kTLS still works.

Fixes: c55dcdd435aa ("net/tls: Fix use-after-free after the TLS device goes down and up")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://lore.kernel.org/r/20220512091830.678684-1-maximmi@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_device.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 1f56225a10e3..3c82286e5bcc 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1345,7 +1345,10 @@ static int tls_device_down(struct net_device *netdev)
 
 		/* Device contexts for RX and TX will be freed in on sk_destruct
 		 * by tls_device_free_ctx. rx_conf and tx_conf stay in TLS_HW.
+		 * Now release the ref taken above.
 		 */
+		if (refcount_dec_and_test(&ctx->refcount))
+			tls_device_free_ctx(ctx);
 	}
 
 	up_write(&device_offload_lock);
-- 
2.35.1



