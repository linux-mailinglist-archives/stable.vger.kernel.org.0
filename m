Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEF613323F
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729719AbgAGVIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:08:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:33052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729715AbgAGVIg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:08:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAC062077B;
        Tue,  7 Jan 2020 21:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431316;
        bh=8+CaKwhRUt1xhJwAYRCUH2PySM5nPiC2GuV92tLAg/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gk//+XURxK/a/bVtuZG3u6ZdS/bkLG46eY93O1l7ByqwKO7qL6GVeV+jPQYrHIpBl
         kKtX/QMOo6pfF9ie1MkbeoctwYF370z81KZ6QT+bptwFE2/cr2+8HLJKa5HBT9KAHz
         mme8bZdTvR1uTYiuOXyT21HJIpbW5EUaLMwdn3cM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 090/115] regulator: ab8500: Remove AB8505 USB regulator
Date:   Tue,  7 Jan 2020 21:55:00 +0100
Message-Id: <20200107205306.737970845@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

commit 99c4f70df3a6446c56ca817c2d0f9c12d85d4e7c upstream.

The USB regulator was removed for AB8500 in
commit 41a06aa738ad ("regulator: ab8500: Remove USB regulator").
It was then added for AB8505 in
commit 547f384f33db ("regulator: ab8500: add support for ab8505").

However, there was never an entry added for it in
ab8505_regulator_match. This causes all regulators after it
to be initialized with the wrong device tree data, eventually
leading to an out-of-bounds array read.

Given that it is not used anywhere in the kernel, it seems
likely that similar arguments against supporting it exist for
AB8505 (it is controlled by hardware).

Therefore, simply remove it like for AB8500 instead of adding
an entry in ab8505_regulator_match.

Fixes: 547f384f33db ("regulator: ab8500: add support for ab8505")
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20191106173125.14496-1-stephan@gerhold.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/ab8500.c       |   17 -----------------
 include/linux/regulator/ab8500.h |    1 -
 2 files changed, 18 deletions(-)

--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -956,23 +956,6 @@ static struct ab8500_regulator_info
 		.update_val_idle	= 0x82,
 		.update_val_normal	= 0x02,
 	},
-	[AB8505_LDO_USB] = {
-		.desc = {
-			.name           = "LDO-USB",
-			.ops            = &ab8500_regulator_mode_ops,
-			.type           = REGULATOR_VOLTAGE,
-			.id             = AB8505_LDO_USB,
-			.owner          = THIS_MODULE,
-			.n_voltages     = 1,
-			.volt_table	= fixed_3300000_voltage,
-		},
-		.update_bank            = 0x03,
-		.update_reg             = 0x82,
-		.update_mask            = 0x03,
-		.update_val		= 0x01,
-		.update_val_idle	= 0x03,
-		.update_val_normal	= 0x01,
-	},
 	[AB8505_LDO_AUDIO] = {
 		.desc = {
 			.name		= "LDO-AUDIO",
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -38,7 +38,6 @@ enum ab8505_regulator_id {
 	AB8505_LDO_AUX6,
 	AB8505_LDO_INTCORE,
 	AB8505_LDO_ADC,
-	AB8505_LDO_USB,
 	AB8505_LDO_AUDIO,
 	AB8505_LDO_ANAMIC1,
 	AB8505_LDO_ANAMIC2,


