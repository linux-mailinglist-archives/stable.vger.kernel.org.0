Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2BF540905
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348825AbiFGSEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351895AbiFGSCZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:02:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0D410F343;
        Tue,  7 Jun 2022 10:46:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD0DDB82239;
        Tue,  7 Jun 2022 17:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58DA8C385A5;
        Tue,  7 Jun 2022 17:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623965;
        bh=85vm1vrtGgzFH8G8lTONTiZh58r6Wicm/naQSPQ/3OI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uYk2livn4HjqI7FEn99qde+juoJlaxKE5Dmq+0VpsTJj3ligVwie4FFBfzchYarO8
         DBjIQz7W46LjlXuvTWYiBAiqiJCtaZ5mKmFDvG7CybZX9lpToSqN2bRR9V0XmQFdbK
         1Tt0645zEfGxhr4ZxcgiWH6Ao59hCcc+ThKijlfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, QintaoShen <unSimple1993@163.com>,
        Nishanth Menon <nm@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 156/667] soc: ti: ti_sci_pm_domains: Check for null return of devm_kcalloc
Date:   Tue,  7 Jun 2022 18:57:01 +0200
Message-Id: <20220607164939.494610235@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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



