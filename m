Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA2D9657B82
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233624AbiL1PXJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:23:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233406AbiL1PW2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:22:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159501409C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:22:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6AFEB816D9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18485C433EF;
        Wed, 28 Dec 2022 15:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240919;
        bh=QSM/P7uHKbIBIyOmWg1RBOnaRqFfbonn7XTW45BAUyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EG46Ek08Vda8EzLq2NlQdIlDLT2gALYmEvWO45AD9iR17du/LQL66IYV3XEDfN7CU
         7zvMcI5u2gVfnqIT5BWmV7+m15lyMCfsSJaTw3vWZD/rt4Mg8aj8VEMc8gjRP+WqvL
         R8IKCj96AMBgUY740yziBhZEEKoLtjg1p2Nqr45k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Andy Gospodarek <gospo@broadcom.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0219/1073] samples/bpf: Fix MAC address swapping in xdp2_kern
Date:   Wed, 28 Dec 2022 15:30:07 +0100
Message-Id: <20221228144333.962932184@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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



