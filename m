Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E057657BFD
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233769AbiL1P1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:27:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233795AbiL1P1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:27:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D208D14038
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:27:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8694EB816D9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:27:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D65C433F2;
        Wed, 28 Dec 2022 15:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241256;
        bh=QSM/P7uHKbIBIyOmWg1RBOnaRqFfbonn7XTW45BAUyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HFfA79ZPjp+WM+7CWfhzT64JmBOh9dbFLravlksRj5ccKLpQasf4MIfljhz9Bgvqd
         96gAhLclZnewSlsj5hx+Z3lbFZdTFIa0G2NbaHMP2QqxaenYX0a9S/kD1eaINBfjnJ
         auKAYCOvGAmkqYU8qePe6DgcRaeDSfyswE8PxUEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Andy Gospodarek <gospo@broadcom.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0225/1146] samples/bpf: Fix MAC address swapping in xdp2_kern
Date:   Wed, 28 Dec 2022 15:29:24 +0100
Message-Id: <20221228144336.254724826@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerhard Engleder <gerhard@engleder-embedded.com>

[ Upstream commit 7a698edf954cb3f8b6e8dacdb77615355170420c ]

xdp2_kern rewrites and forwards packets out on the same interface.
Forwarding still works but rewrite got broken when xdp multibuffer
support has been added.

With xdp multibuffer a local copy of the packet has been introduced. The
MAC address is now swapped in the local copy, but the local copy in not
written back.

Fix MAC address swapping be adding write back of modified packet.

Fixes: 772251742262 ("samples/bpf: fixup some tools to be able to support xdp multibuffer")
Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Link: https://lore.kernel.org/r/20221015213050.65222-1-gerhard@engleder-embedded.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/xdp2_kern.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/samples/bpf/xdp2_kern.c b/samples/bpf/xdp2_kern.c
index 3332ba6bb95f..67804ecf7ce3 100644
--- a/samples/bpf/xdp2_kern.c
+++ b/samples/bpf/xdp2_kern.c
@@ -112,6 +112,10 @@ int xdp_prog1(struct xdp_md *ctx)
 
 	if (ipproto == IPPROTO_UDP) {
 		swap_src_dst_mac(data);
+
+		if (bpf_xdp_store_bytes(ctx, 0, pkt, sizeof(pkt)))
+			return rc;
+
 		rc = XDP_TX;
 	}
 
-- 
2.35.1



