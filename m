Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA04D593712
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245345AbiHOTTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344883AbiHOTRn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:17:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4BF3558DA;
        Mon, 15 Aug 2022 11:38:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB801B81081;
        Mon, 15 Aug 2022 18:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C39C433D6;
        Mon, 15 Aug 2022 18:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588735;
        bh=pIzzsxQZ0lTJl48X9dv6tsuNTaxcxVQ8obhY4NcL4Zk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eh700bd0hfxiym7P+8+FSAeoyDbrrYRtrHw2iZ54C+6qLydip11tl/4bHs5z6ddm7
         Eg6OFuPPmL4HS63/gnp4FOMeousnGi8vDNCevJ9n8cC/lV+ni71StE0UURJehmaUTP
         eyG4No2alXjJRsLR2irqHuu49MPCCkCEeXc5PZ2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bartosz Sobczak <bartosz.sobczak@intel.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 499/779] RDMA/irdma: Fix a window for use-after-free
Date:   Mon, 15 Aug 2022 20:02:23 +0200
Message-Id: <20220815180358.597414952@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Mustafa Ismail <mustafa.ismail@intel.com>

[ Upstream commit 8ecef7890b3aea78c8bbb501a4b5b8134367b821 ]

During a destroy CQ an interrupt may cause processing of a CQE after CQ
resources are freed by irdma_cq_free_rsrc(). Fix this by moving the call
to irdma_cq_free_rsrc() after the irdma_sc_cleanup_ceqes(), which is
called under the cq_lock.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Link: https://lore.kernel.org/r/20220705230815.265-6-shiraz.saleem@intel.com
Signed-off-by: Bartosz Sobczak <bartosz.sobczak@intel.com>
Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 0eef46428691..cac4fb228b9b 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -1759,11 +1759,11 @@ static int irdma_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata)
 	spin_unlock_irqrestore(&iwcq->lock, flags);
 
 	irdma_cq_wq_destroy(iwdev->rf, cq);
-	irdma_cq_free_rsrc(iwdev->rf, iwcq);
 
 	spin_lock_irqsave(&iwceq->ce_lock, flags);
 	irdma_sc_cleanup_ceqes(cq, ceq);
 	spin_unlock_irqrestore(&iwceq->ce_lock, flags);
+	irdma_cq_free_rsrc(iwdev->rf, iwcq);
 
 	return 0;
 }
-- 
2.35.1



