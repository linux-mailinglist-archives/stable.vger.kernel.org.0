Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04B4E4D8201
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240127AbiCNL7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240128AbiCNL7T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:59:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74911433AE;
        Mon, 14 Mar 2022 04:57:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 443EBB80D96;
        Mon, 14 Mar 2022 11:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC40CC340E9;
        Mon, 14 Mar 2022 11:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259060;
        bh=IhES6SY4hVBe9WnX1Oa59VrbiUCnlFTaMAUQOD0QNW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qyvl+eInIjEGhkIIxG/WqPPTfMedRkpSPbbSgxOU4v2wu3JdrcAt1IHB0OuqqevWr
         K+oisQW8rLfS01i1EA/IbrUZRjc7CkMXsuQZgRfbfhp2DW8gudjtP3wFrAPiOk3/5V
         RmobhAn8Os5d86dxuKWFPmWK1Won/BPNqrlnwOjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 04/43] net: qlogic: check the return value of dma_alloc_coherent() in qed_vf_hw_prepare()
Date:   Mon, 14 Mar 2022 12:53:15 +0100
Message-Id: <20220314112734.542742272@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112734.415677317@linuxfoundation.org>
References: <20220314112734.415677317@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit e0058f0fa80f6e09c4d363779c241c45a3c56b94 ]

The function dma_alloc_coherent() in qed_vf_hw_prepare() can fail, so
its return value should be checked.

Fixes: 1408cc1fa48c ("qed: Introduce VFs")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_vf.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_vf.c b/drivers/net/ethernet/qlogic/qed/qed_vf.c
index adc2c8f3d48e..62e4511db857 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_vf.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_vf.c
@@ -539,6 +539,9 @@ int qed_vf_hw_prepare(struct qed_hwfn *p_hwfn)
 						    p_iov->bulletin.size,
 						    &p_iov->bulletin.phys,
 						    GFP_KERNEL);
+	if (!p_iov->bulletin.p_virt)
+		goto free_pf2vf_reply;
+
 	DP_VERBOSE(p_hwfn, QED_MSG_IOV,
 		   "VF's bulletin Board [%p virt 0x%llx phys 0x%08x bytes]\n",
 		   p_iov->bulletin.p_virt,
@@ -578,6 +581,10 @@ int qed_vf_hw_prepare(struct qed_hwfn *p_hwfn)
 
 	return rc;
 
+free_pf2vf_reply:
+	dma_free_coherent(&p_hwfn->cdev->pdev->dev,
+			  sizeof(union pfvf_tlvs),
+			  p_iov->pf2vf_reply, p_iov->pf2vf_reply_phys);
 free_vf2pf_request:
 	dma_free_coherent(&p_hwfn->cdev->pdev->dev,
 			  sizeof(union vfpf_tlvs),
-- 
2.34.1



