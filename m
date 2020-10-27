Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78B3129B650
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1797328AbgJ0PWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:22:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797323AbgJ0PWx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:22:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E1B220657;
        Tue, 27 Oct 2020 15:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812173;
        bh=7uyB9atqs1ASUhJEUJ6KUZQMtbf7sTKSZGFbcU0r53E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+TR+r4RtTEkyETaCGdVWyVWKCFA3c/hERA2lNTwzb/1K+S437EF0I2Td8AcN9L31
         ORWMzmeeTd7bWt0zIVcHcUeKWLdgfONGkiZRs8fq/ZGkSHHRm9d68WA6SqZVvdmLgi
         xmqQRPFKffjUpiH1KVAhKfVEHKzGZFt6gXKAC8u0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Marek <jonathan@marek.ca>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 118/757] regulator: set of_node for qcom vbus regulator
Date:   Tue, 27 Oct 2020 14:46:08 +0100
Message-Id: <20201027135456.110742616@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit 66c3b96a7bd042427d2e0eaa8704536828f8235f ]

This allows the regulator to be found by devm_regulator_get().

Fixes: 4fe66d5a62fb ("regulator: Add support for QCOM PMIC VBUS booster")

Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Link: https://lore.kernel.org/r/20200818162508.5246-1-jonathan@marek.ca
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/qcom_usb_vbus-regulator.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/qcom_usb_vbus-regulator.c b/drivers/regulator/qcom_usb_vbus-regulator.c
index 8ba947f3585f5..457788b505720 100644
--- a/drivers/regulator/qcom_usb_vbus-regulator.c
+++ b/drivers/regulator/qcom_usb_vbus-regulator.c
@@ -63,6 +63,7 @@ static int qcom_usb_vbus_regulator_probe(struct platform_device *pdev)
 	qcom_usb_vbus_rdesc.enable_mask = OTG_EN;
 	config.dev = dev;
 	config.init_data = init_data;
+	config.of_node = dev->of_node;
 	config.regmap = regmap;
 
 	rdev = devm_regulator_register(dev, &qcom_usb_vbus_rdesc, &config);
-- 
2.25.1



