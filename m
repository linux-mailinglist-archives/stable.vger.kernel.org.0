Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80ACF540CDD
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352640AbiFGSlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353450AbiFGSlX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:41:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E1818629C;
        Tue,  7 Jun 2022 10:58:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AF69B8236C;
        Tue,  7 Jun 2022 17:58:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDEC5C34115;
        Tue,  7 Jun 2022 17:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624706;
        bh=zH/pSgAZjZwfNYbHLmOYRBuLfI0NNzWZ3BELSFKBlck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YO2e98vTN2LKZTeTxMqnm/9PdtUbZMVWjNKZ2PIsCSvt137RJ0TzbuIBL26d2Vf/R
         wSwWjqIFqhNDzb2e2Lq53Yw9git8pUKtpgmVbPv4oDkizEqXmX9RiXUseLR8kXmwC5
         D5CIi1Oe4g2XRNAfTezp5jT6A6Dowpg1rsFcGdrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, QintaoShen <unSimple1993@163.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 423/667] soc: bcm: Check for NULL return of devm_kzalloc()
Date:   Tue,  7 Jun 2022 19:01:28 +0200
Message-Id: <20220607164947.418341271@linuxfoundation.org>
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

[ Upstream commit b4bd2aafacce48db26b0a213d849818d940556dd ]

As the potential failure of allocation, devm_kzalloc() may return NULL.  Then
the 'pd->pmb' and the follow lines of code may bring null pointer dereference.

Therefore, it is better to check the return value of devm_kzalloc() to avoid
this confusion.

Fixes: 8bcac4011ebe ("soc: bcm: add PM driver for Broadcom's PMB")
Signed-off-by: QintaoShen <unSimple1993@163.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/bcm/bcm63xx/bcm-pmb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/soc/bcm/bcm63xx/bcm-pmb.c b/drivers/soc/bcm/bcm63xx/bcm-pmb.c
index 774465c119be..2ac20084e5a5 100644
--- a/drivers/soc/bcm/bcm63xx/bcm-pmb.c
+++ b/drivers/soc/bcm/bcm63xx/bcm-pmb.c
@@ -314,6 +314,9 @@ static int bcm_pmb_probe(struct platform_device *pdev)
 	for (e = table; e->name; e++) {
 		struct bcm_pmb_pm_domain *pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
 
+		if (!pd)
+			return -ENOMEM;
+
 		pd->pmb = pmb;
 		pd->data = e;
 		pd->genpd.name = e->name;
-- 
2.35.1



