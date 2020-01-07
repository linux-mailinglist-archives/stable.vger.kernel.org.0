Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFDF133196
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbgAGVCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:02:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:41176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728416AbgAGVCL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:02:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AEDA2077B;
        Tue,  7 Jan 2020 21:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430930;
        bh=7YRSWAeP925XDAOHspxYHiU39ztDtMlWlOCjtxBYRoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P8NBh1uFNoermZ/tP4xYjZKRfIFq7sylFrf2oexypmBM0Sx51rw8dLCWPfwlK2dTh
         8nRug0fH9T5qE3mfpYFwtXy4W0vmW+Philsbp2BR6wiGQE5punyjiTiodynN3tBiTu
         IEg1A3DE6ctiL3MV1e3S1+OfBn7MNAMtbMIA0xzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 154/191] regulator: bd70528: Remove .set_ramp_delay for bd70528_ldo_ops
Date:   Tue,  7 Jan 2020 21:54:34 +0100
Message-Id: <20200107205341.208013098@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

commit 6f1ff76154b8b36033efcbf6453a71a3d28f52cd upstream.

The .set_ramp_delay should be for bd70528_buck_ops only.
Setting .set_ramp_delay for for bd70528_ldo_ops causes problem because
BD70528_MASK_BUCK_RAMP (0x10) overlaps with BD70528_MASK_LDO_VOLT (0x1f).
So setting ramp_delay for LDOs may change the voltage output, fix it.

Fixes: 99ea37bd1e7d ("regulator: bd70528: Support ROHM BD70528 regulator block")
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Link: https://lore.kernel.org/r/20200101022406.15176-1-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/bd70528-regulator.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/regulator/bd70528-regulator.c
+++ b/drivers/regulator/bd70528-regulator.c
@@ -101,7 +101,6 @@ static const struct regulator_ops bd7052
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.set_voltage_time_sel = regulator_set_voltage_time_sel,
-	.set_ramp_delay = bd70528_set_ramp_delay,
 };
 
 static const struct regulator_ops bd70528_led_ops = {


