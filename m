Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F08676C1873
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbjCTPYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232672AbjCTPYS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:24:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D485E360A6
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:17:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37E4AB80EC5
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:17:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7529AC433EF;
        Mon, 20 Mar 2023 15:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325432;
        bh=kJkK3+l+HP8IxMfE2VAikLE5Y6vW92FODnSE6P8vndQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1/ZeNzl5Y7jiOd7iAiCVDdM5nchms7v4HhdH3VryPTwd3Q1jX6GJFRv1I+Rd8STA8
         p0CdPPe0adFvGmzivSdzkNbdrCuKYVWXOBQbjI+lb1tz/mmnMGR1gQxcb8ZXjTd5W7
         JSUQPtLYQGXeEpUMW2GO0EoBR536mKXcU6r1VgMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Freysteinn Alfredsson <Freysteinn.Alfredsson@kau.se>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 084/198] net: atlantic: Fix crash when XDP is enabled but no program is loaded
Date:   Mon, 20 Mar 2023 15:53:42 +0100
Message-Id: <20230320145511.057934169@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 37d010399f7552add2b68e2b347901c83562dab8 ]

The aq_xdp_run_prog() function falls back to the XDP_ABORTED action
handler (using a goto) if the operations for any of the other actions fail.
The XDP_ABORTED handler in turn calls the bpf_warn_invalid_xdp_action()
tracepoint. However, the function also jumps into the XDP_PASS helper if no
XDP program is loaded on the device, which means the XDP_ABORTED handler
can be run with a NULL program pointer. This results in a NULL pointer
deref because the tracepoint dereferences the 'prog' pointer passed to it.

This situation can happen in multiple ways:
- If a packet arrives between the removal of the program from the interface
  and the static_branch_dec() in aq_xdp_setup()
- If there are multiple devices using the same driver in the system and
  one of them has an XDP program loaded and the other does not.

Fix this by refactoring the aq_xdp_run_prog() function to remove the 'goto
pass' handling if there is no XDP program loaded. Instead, factor out the
skb building in a separate small helper function.

Fixes: 26efaef759a1 ("net: atlantic: Implement xdp data plane")
Reported-by: Freysteinn Alfredsson <Freysteinn.Alfredsson@kau.se>
Tested-by: Freysteinn Alfredsson <Freysteinn.Alfredsson@kau.se>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/r/20230315125539.103319-1-toke@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/aquantia/atlantic/aq_ring.c  | 28 ++++++++++++++-----
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 25129e723b575..2dc8d215a5918 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -412,6 +412,25 @@ int aq_xdp_xmit(struct net_device *dev, int num_frames,
 	return num_frames - drop;
 }
 
+static struct sk_buff *aq_xdp_build_skb(struct xdp_buff *xdp,
+					struct net_device *dev,
+					struct aq_ring_buff_s *buff)
+{
+	struct xdp_frame *xdpf;
+	struct sk_buff *skb;
+
+	xdpf = xdp_convert_buff_to_frame(xdp);
+	if (unlikely(!xdpf))
+		return NULL;
+
+	skb = xdp_build_skb_from_frame(xdpf, dev);
+	if (!skb)
+		return NULL;
+
+	aq_get_rxpages_xdp(buff, xdp);
+	return skb;
+}
+
 static struct sk_buff *aq_xdp_run_prog(struct aq_nic_s *aq_nic,
 				       struct xdp_buff *xdp,
 				       struct aq_ring_s *rx_ring,
@@ -431,7 +450,7 @@ static struct sk_buff *aq_xdp_run_prog(struct aq_nic_s *aq_nic,
 
 	prog = READ_ONCE(rx_ring->xdp_prog);
 	if (!prog)
-		goto pass;
+		return aq_xdp_build_skb(xdp, aq_nic->ndev, buff);
 
 	prefetchw(xdp->data_hard_start); /* xdp_frame write */
 
@@ -442,17 +461,12 @@ static struct sk_buff *aq_xdp_run_prog(struct aq_nic_s *aq_nic,
 	act = bpf_prog_run_xdp(prog, xdp);
 	switch (act) {
 	case XDP_PASS:
-pass:
-		xdpf = xdp_convert_buff_to_frame(xdp);
-		if (unlikely(!xdpf))
-			goto out_aborted;
-		skb = xdp_build_skb_from_frame(xdpf, aq_nic->ndev);
+		skb = aq_xdp_build_skb(xdp, aq_nic->ndev, buff);
 		if (!skb)
 			goto out_aborted;
 		u64_stats_update_begin(&rx_ring->stats.rx.syncp);
 		++rx_ring->stats.rx.xdp_pass;
 		u64_stats_update_end(&rx_ring->stats.rx.syncp);
-		aq_get_rxpages_xdp(buff, xdp);
 		return skb;
 	case XDP_TX:
 		xdpf = xdp_convert_buff_to_frame(xdp);
-- 
2.39.2



