Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1820C54064F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347081AbiFGRef (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348298AbiFGRbp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:31:45 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875651207D4;
        Tue,  7 Jun 2022 10:29:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6E58DCE23CE;
        Tue,  7 Jun 2022 17:29:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79972C385A5;
        Tue,  7 Jun 2022 17:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622988;
        bh=F/mo7IAkBHvC6uza3gdllcSz7sR0Zug3Ik+JqbHXSAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dhFEihyiNLp8vvfWDs7OaLuUD2pElLyT3WWek8sKbPZ/7wPLGqerGrs56MJttRABt
         SyLEmLmtl75dig/IkHIbI7u58OvyplBidgP472j36OnVvJPqVMJFcx6jTEGsxJIRdi
         plR0qcgJcXtCnODLRIAbTET3fhGxQ1tfMx9+xsFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 256/452] hinic: Avoid some over memory allocation
Date:   Tue,  7 Jun 2022 19:01:53 +0200
Message-Id: <20220607164916.186045094@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 15d221d0c345b76947911a3ac91897ffe2f1cc4e ]

'prod_idx' (atomic_t) is larger than 'shadow_idx' (u16), so some memory is
over-allocated.

Fixes: b15a9f37be2b ("net-next/hinic: Add wq")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c
index 1932e07e97e0..f930cd6a75f7 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c
@@ -385,7 +385,7 @@ static int alloc_wqes_shadow(struct hinic_wq *wq)
 		return -ENOMEM;
 
 	wq->shadow_idx = devm_kcalloc(&pdev->dev, wq->num_q_pages,
-				      sizeof(wq->prod_idx), GFP_KERNEL);
+				      sizeof(*wq->shadow_idx), GFP_KERNEL);
 	if (!wq->shadow_idx)
 		goto err_shadow_idx;
 
-- 
2.35.1



