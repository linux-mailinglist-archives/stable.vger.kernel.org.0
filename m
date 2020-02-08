Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8A715667E
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbgBHSfA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:35:00 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34194 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727879AbgBHS3o (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:44 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrK-0003g0-1u; Sat, 08 Feb 2020 18:29:38 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrI-000CPt-Jv; Sat, 08 Feb 2020 18:29:36 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        "Mark Brown" <broonie@kernel.org>,
        "Stephan Gerhold" <stephan@gerhold.net>
Date:   Sat, 08 Feb 2020 18:20:19 +0000
Message-ID: <lsq.1581185940.717435865@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 080/148] regulator: ab8500: Remove AB8505 USB regulator
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/regulator/ab8500.c       | 17 -----------------
 include/linux/regulator/ab8500.h |  1 -
 2 files changed, 18 deletions(-)

--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -1099,23 +1099,6 @@ static struct ab8500_regulator_info
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

