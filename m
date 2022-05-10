Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8675218C3
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243672AbiEJNj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245049AbiEJNi1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:38:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FBF57F23F;
        Tue, 10 May 2022 06:26:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EE7561768;
        Tue, 10 May 2022 13:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1D2C385A6;
        Tue, 10 May 2022 13:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189217;
        bh=VPmGLYyoid+7Hr0o4liQyLBaeJin3XuWlLByWtnfuCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hToUCWcjfllfiSV64+ehj9WEvv5kJipfGrpdjdwticKuXzT9TSQIRAH8aNhbcRSWi
         fsGJvyifC0IppSw3LtxAjvoqfB8eT9lCqhbsrOQWjmcbpY1/8cyjEyfAK9pp6sLkuG
         i4j3odVyme1HzCMQfznkfd8hG34UKzP7AmB+n6tM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiao Ma <mqaio@linux.alibaba.com>,
        Xunlei Pang <xlpang@linux.alibaba.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 50/70] hinic: fix bug of wq out of bound access
Date:   Tue, 10 May 2022 15:08:09 +0200
Message-Id: <20220510130734.326693325@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.861729621@linuxfoundation.org>
References: <20220510130732.861729621@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiao Ma <mqaio@linux.alibaba.com>

commit 52b2abef450a78e25d485ac61e32f4ce86a87701 upstream.

If wq has only one page, we need to check wqe rolling over page by
compare end_idx and curr_idx, and then copy wqe to shadow wqe to
avoid out of bound access.
This work has been done in hinic_get_wqe, but missed for hinic_read_wqe.
This patch fixes it, and removes unnecessary MASKED_WQE_IDX().

Fixes: 7dd29ee12865 ("hinic: add sriov feature support")
Signed-off-by: Qiao Ma <mqaio@linux.alibaba.com>
Reviewed-by: Xunlei Pang <xlpang@linux.alibaba.com>
Link: https://lore.kernel.org/r/282817b0e1ae2e28fdf3ed8271a04e77f57bf42e.1651148587.git.mqaio@linux.alibaba.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c
@@ -771,7 +771,7 @@ struct hinic_hw_wqe *hinic_get_wqe(struc
 	/* If we only have one page, still need to get shadown wqe when
 	 * wqe rolling-over page
 	 */
-	if (curr_pg != end_pg || MASKED_WQE_IDX(wq, end_prod_idx) < *prod_idx) {
+	if (curr_pg != end_pg || end_prod_idx < *prod_idx) {
 		void *shadow_addr = &wq->shadow_wqe[curr_pg * wq->max_wqe_size];
 
 		copy_wqe_to_shadow(wq, shadow_addr, num_wqebbs, *prod_idx);
@@ -841,7 +841,10 @@ struct hinic_hw_wqe *hinic_read_wqe(stru
 
 	*cons_idx = curr_cons_idx;
 
-	if (curr_pg != end_pg) {
+	/* If we only have one page, still need to get shadown wqe when
+	 * wqe rolling-over page
+	 */
+	if (curr_pg != end_pg || end_cons_idx < curr_cons_idx) {
 		void *shadow_addr = &wq->shadow_wqe[curr_pg * wq->max_wqe_size];
 
 		copy_wqe_to_shadow(wq, shadow_addr, num_wqebbs, *cons_idx);


