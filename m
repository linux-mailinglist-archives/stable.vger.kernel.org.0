Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B805B4D80D6
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbiCNLfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236577AbiCNLfj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:35:39 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0EA3ED1D;
        Mon, 14 Mar 2022 04:34:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BEA62CE1176;
        Mon, 14 Mar 2022 11:34:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60BC7C340E9;
        Mon, 14 Mar 2022 11:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647257666;
        bh=723RJKFmjtUkAGQyqZ+6vtkIxRTQNc85URH8O5GguD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S17a/Y5dHOitAFatb3kMuQn5DnvJdGfuafHMlRDkYnKVEdLOY0jcFlm6oi04xvcFK
         gtYppLOrSVySzmNNYB9UQWF4iZTHzMlP40E3EfglpQc7e0KkI2YAi+BM6TXz1vnA8q
         hLlfdMLEl8GlHHwWClyVJba8Sm88OLbnfqxS4+uM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 01/20] net: qlogic: check the return value of dma_alloc_coherent() in qed_vf_hw_prepare()
Date:   Mon, 14 Mar 2022 12:34:02 +0100
Message-Id: <20220314112730.435791883@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112730.388955049@linuxfoundation.org>
References: <20220314112730.388955049@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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
index 170243d3276b..d0449d5418f7 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_vf.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_vf.c
@@ -384,6 +384,9 @@ int qed_vf_hw_prepare(struct qed_hwfn *p_hwfn)
 						    p_iov->bulletin.size,
 						    &p_iov->bulletin.phys,
 						    GFP_KERNEL);
+	if (!p_iov->bulletin.p_virt)
+		goto free_pf2vf_reply;
+
 	DP_VERBOSE(p_hwfn, QED_MSG_IOV,
 		   "VF's bulletin Board [%p virt 0x%llx phys 0x%08x bytes]\n",
 		   p_iov->bulletin.p_virt,
@@ -397,6 +400,10 @@ int qed_vf_hw_prepare(struct qed_hwfn *p_hwfn)
 
 	return qed_vf_pf_acquire(p_hwfn);
 
+free_pf2vf_reply:
+	dma_free_coherent(&p_hwfn->cdev->pdev->dev,
+			  sizeof(union pfvf_tlvs),
+			  p_iov->pf2vf_reply, p_iov->pf2vf_reply_phys);
 free_vf2pf_request:
 	dma_free_coherent(&p_hwfn->cdev->pdev->dev,
 			  sizeof(union vfpf_tlvs),
-- 
2.34.1



