Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E345053A7DF
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238108AbiFAOD4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355470AbiFAOBo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:01:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844679C2F9;
        Wed,  1 Jun 2022 06:58:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7C1BB81AF5;
        Wed,  1 Jun 2022 13:58:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB71DC385A5;
        Wed,  1 Jun 2022 13:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091890;
        bh=85vm1vrtGgzFH8G8lTONTiZh58r6Wicm/naQSPQ/3OI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HiOJRqUyenWNusR8UoDWGh9n3mEymSpxF2wTuzJLLrg/DrF/enKREiGzXTfpzPw4j
         HqL34emLtJWnRzJQkRNuViq8wMe8+oHiN47WX8X9bYi0zMiLpsxpsFY/3MAn7LJpNx
         JHkq9eO7VmXP9oMf9J70XoHeMq8FjjTSFXOS9rWN9Wnt2ZabSlhtfGrgZ/xTwhISJC
         lbtC+YP+qOCnZqBKsm3uy69JsMvG9MRDCUQBRF4gGVdymvWuFLR9Zwx3dlOS5wZ3Ar
         ZddDpgGGmpqVTB/rySSJPbl8jWNZjstXL5CUvzt7GwfJFadEQdQAGzOScrEuB1XjtW
         60zqA9i+Nrn3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     QintaoShen <unSimple1993@163.com>, Nishanth Menon <nm@ti.com>,
        Sasha Levin <sashal@kernel.org>, kristo@kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 07/26] soc: ti: ti_sci_pm_domains: Check for null return of devm_kcalloc
Date:   Wed,  1 Jun 2022 09:57:40 -0400
Message-Id: <20220601135759.2004435-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135759.2004435-1-sashal@kernel.org>
References: <20220601135759.2004435-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: QintaoShen <unSimple1993@163.com>

[ Upstream commit ba56291e297d28aa6eb82c5c1964fae2d7594746 ]

The allocation funciton devm_kcalloc may fail and return a null pointer,
which would cause a null-pointer dereference later.
It might be better to check it and directly return -ENOMEM just like the
usage of devm_kcalloc in previous code.

Signed-off-by: QintaoShen <unSimple1993@163.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/1648107843-29077-1-git-send-email-unSimple1993@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/ti_sci_pm_domains.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/soc/ti/ti_sci_pm_domains.c b/drivers/soc/ti/ti_sci_pm_domains.c
index 8afb3f45d263..a33ec7eaf23d 100644
--- a/drivers/soc/ti/ti_sci_pm_domains.c
+++ b/drivers/soc/ti/ti_sci_pm_domains.c
@@ -183,6 +183,8 @@ static int ti_sci_pm_domain_probe(struct platform_device *pdev)
 		devm_kcalloc(dev, max_id + 1,
 			     sizeof(*pd_provider->data.domains),
 			     GFP_KERNEL);
+	if (!pd_provider->data.domains)
+		return -ENOMEM;
 
 	pd_provider->data.num_domains = max_id + 1;
 	pd_provider->data.xlate = ti_sci_pd_xlate;
-- 
2.35.1

