Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02A9A59D5D7
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241155AbiHWImK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347175AbiHWIkq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:40:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25855785AF;
        Tue, 23 Aug 2022 01:19:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4A14612FE;
        Tue, 23 Aug 2022 08:19:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8976C433D6;
        Tue, 23 Aug 2022 08:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242746;
        bh=nKU8y2dvnO/CDH+Ggz7JkTDok6mbH9SjMtG+BKseyec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qc+2YOIdnD96U/rKkhQRqnzLcIOtNXyCn3L6btanHdg3hhOxOxoDjfuP2fOzjSs0B
         qD8JuslSo6T5tJSCPxGqpu0wcpki23/om6loIQNZzlw4CHPCEdpIf5gy364hjemZhI
         VIrB3IlPMJEYiZwS2VNX0nWLjAJiDWLMskd2J5TY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Potnuri Bharat Teja <bharat@chelsio.com>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Kees Cook <keescook@chromium.org>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 5.19 187/365] RDMA/cxgb4: fix accept failure due to increased cpl_t5_pass_accept_rpl size
Date:   Tue, 23 Aug 2022 10:01:28 +0200
Message-Id: <20220823080126.041595996@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Potnuri Bharat Teja <bharat@chelsio.com>

commit ef0162298abf46b881e4a4d0c604d1a066228647 upstream.

Commit 'c2ed5611afd7' has increased the cpl_t5_pass_accept_rpl{} structure
size by 8B to avoid roundup. cpl_t5_pass_accept_rpl{} is a HW specific
structure and increasing its size will lead to unwanted adapter errors.
Current commit reverts the cpl_t5_pass_accept_rpl{} back to its original
and allocates zeroed skb buffer there by avoiding the memset for iss field.
Reorder code to minimize chip type checks.

Fixes: c2ed5611afd7 ("iw_cxgb4: Use memset_startat() for cpl_t5_pass_accept_rpl")
Link: https://lore.kernel.org/r/20220809184118.2029-1-rahul.lakkireddy@chelsio.com
Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/cxgb4/cm.c            | 25 ++++++++-------------
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h |  2 +-
 2 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index c16017f6e8db..14392c942f49 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2468,31 +2468,24 @@ static int accept_cr(struct c4iw_ep *ep, struct sk_buff *skb,
 			opt2 |= CCTRL_ECN_V(1);
 	}
 
-	skb_get(skb);
-	rpl = cplhdr(skb);
 	if (!is_t4(adapter_type)) {
-		BUILD_BUG_ON(sizeof(*rpl5) != roundup(sizeof(*rpl5), 16));
-		skb_trim(skb, sizeof(*rpl5));
-		rpl5 = (void *)rpl;
-		INIT_TP_WR(rpl5, ep->hwtid);
-	} else {
-		skb_trim(skb, sizeof(*rpl));
-		INIT_TP_WR(rpl, ep->hwtid);
-	}
-	OPCODE_TID(rpl) = cpu_to_be32(MK_OPCODE_TID(CPL_PASS_ACCEPT_RPL,
-						    ep->hwtid));
-
-	if (CHELSIO_CHIP_VERSION(adapter_type) > CHELSIO_T4) {
 		u32 isn = (prandom_u32() & ~7UL) - 1;
+
+		skb = get_skb(skb, roundup(sizeof(*rpl5), 16), GFP_KERNEL);
+		rpl5 = __skb_put_zero(skb, roundup(sizeof(*rpl5), 16));
+		rpl = (void *)rpl5;
+		INIT_TP_WR_CPL(rpl5, CPL_PASS_ACCEPT_RPL, ep->hwtid);
 		opt2 |= T5_OPT_2_VALID_F;
 		opt2 |= CONG_CNTRL_V(CONG_ALG_TAHOE);
 		opt2 |= T5_ISS_F;
-		rpl5 = (void *)rpl;
-		memset_after(rpl5, 0, iss);
 		if (peer2peer)
 			isn += 4;
 		rpl5->iss = cpu_to_be32(isn);
 		pr_debug("iss %u\n", be32_to_cpu(rpl5->iss));
+	} else {
+		skb = get_skb(skb, sizeof(*rpl), GFP_KERNEL);
+		rpl = __skb_put_zero(skb, sizeof(*rpl));
+		INIT_TP_WR_CPL(rpl, CPL_PASS_ACCEPT_RPL, ep->hwtid);
 	}
 
 	rpl->opt0 = cpu_to_be64(opt0);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h b/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
index 26433a62d7f0..fed5f93bf620 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
@@ -497,7 +497,7 @@ struct cpl_t5_pass_accept_rpl {
 	__be32 opt2;
 	__be64 opt0;
 	__be32 iss;
-	__be32 rsvd[3];
+	__be32 rsvd;
 };
 
 struct cpl_act_open_req {
-- 
2.37.2



