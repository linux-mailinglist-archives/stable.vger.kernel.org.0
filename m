Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F7D3A6245
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbhFNK6U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:58:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234127AbhFNK4P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:56:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67BDB615A0;
        Mon, 14 Jun 2021 10:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667262;
        bh=Wb0yrOsNBITxibtbVHVNRT/x69LMKfbv31E2OITjUbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DT4MvtIoB2hmO7ust3XsqD5y2KitAAUIU6ZmxTR+CjUTAeZ6q0+MEIF07R+1sXpE0
         hvJwZKQwqfKIqG26HWHn5vtV7WtO4mBy2hbSCUfrZC4sezgtYsKC+H1kVV0yiCcQBF
         5hUYOTiLaMDe6qdFpulmUqbEp+RZkPQsKjGIE9JU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 63/84] regulator: max77620: Use device_set_of_node_from_dev()
Date:   Mon, 14 Jun 2021 12:27:41 +0200
Message-Id: <20210614102648.523245205@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102646.341387537@linuxfoundation.org>
References: <20210614102646.341387537@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

commit 6f55c5dd1118b3076d11d9cb17f5c5f4bc3a1162 upstream.

The MAX77620 driver fails to re-probe on deferred probe because driver
core tries to claim resources that are already claimed by the PINCTRL
device. Use device_set_of_node_from_dev() helper which marks OF node as
reused, skipping erroneous execution of pinctrl_bind_pins() for the PMIC
device on the re-probe.

Fixes: aea6cb99703e ("regulator: resolve supply after creating regulator")
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20210523224243.13219-2-digetx@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/max77620-regulator.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/regulator/max77620-regulator.c
+++ b/drivers/regulator/max77620-regulator.c
@@ -814,6 +814,13 @@ static int max77620_regulator_probe(stru
 	config.dev = dev;
 	config.driver_data = pmic;
 
+	/*
+	 * Set of_node_reuse flag to prevent driver core from attempting to
+	 * claim any pinmux resources already claimed by the parent device.
+	 * Otherwise PMIC driver will fail to re-probe.
+	 */
+	device_set_of_node_from_dev(&pdev->dev, pdev->dev.parent);
+
 	for (id = 0; id < MAX77620_NUM_REGS; id++) {
 		struct regulator_dev *rdev;
 		struct regulator_desc *rdesc;


