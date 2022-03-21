Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 376C94E2EF1
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 18:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351756AbiCURUS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 13:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351741AbiCURUR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 13:20:17 -0400
Received: from comms.puri.sm (comms.puri.sm [159.203.221.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39B929801;
        Mon, 21 Mar 2022 10:18:51 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id D2A7BE01BC;
        Mon, 21 Mar 2022 10:18:21 -0700 (PDT)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id dFgGBeWHlpWv; Mon, 21 Mar 2022 10:18:21 -0700 (PDT)
From:   Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Cc:     Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Robin van der Gracht <robin@protonic.nl>,
        linux-kernel@vger.kernel.org, kernel@puri.sm,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, stable@vger.kernel.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>
Subject: [PATCH v2] input: keyboard: snvs_pwrkey: Fix SNVS_HPVIDR1 register address
Date:   Mon, 21 Mar 2022 18:17:55 +0100
Message-Id: <20220321171755.656750-1-sebastian.krzyszkowiak@puri.sm>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Both i.MX6 and i.MX8 reference manuals list 0xBF8 as SNVS_HPVIDR1
(chapters 57.9 and 6.4.5 respectively).

Without this, trying to read the revision number results in 0 on
all revisions, causing the i.MX6 quirk to apply on all platforms,
which in turn causes the driver to synthesise power button release
events instead of passing the real one as they happen even on
platforms like i.MX8 where that's not wanted.

Fixes: 1a26c920717a ("Input: snvs_pwrkey - send key events for i.MX6 S, DL and Q")
Cc: <stable@vger.kernel.org>
Tested-by: Martin Kepplinger <martin.kepplinger@puri.sm>
Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
---
v2: augmented commit message; added cc: stable and tested-by
---
 drivers/input/keyboard/snvs_pwrkey.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/keyboard/snvs_pwrkey.c b/drivers/input/keyboard/snvs_pwrkey.c
index 65286762b02a..ad8660be0127 100644
--- a/drivers/input/keyboard/snvs_pwrkey.c
+++ b/drivers/input/keyboard/snvs_pwrkey.c
@@ -20,7 +20,7 @@
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
 
-#define SNVS_HPVIDR1_REG	0xF8
+#define SNVS_HPVIDR1_REG	0xBF8
 #define SNVS_LPSR_REG		0x4C	/* LP Status Register */
 #define SNVS_LPCR_REG		0x38	/* LP Control Register */
 #define SNVS_HPSR_REG		0x14
-- 
2.35.1

