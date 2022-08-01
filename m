Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 077A05870AF
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 21:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbiHATC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 15:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbiHATC1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 15:02:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567251FCFC;
        Mon,  1 Aug 2022 12:02:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7D0761172;
        Mon,  1 Aug 2022 19:02:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D54EC433D6;
        Mon,  1 Aug 2022 19:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659380545;
        bh=3ujAZeKEOLhx37OJc1LDzbpYlVYHE67f9O0jS+7wG8I=;
        h=From:To:Cc:Subject:Date:From;
        b=HsP4r3Ln3vt2goo9zcUkJ1vASCI45SDeemX3/vbk38fhAoTrLfXCNq/I0ldce7qiQ
         NNBMzZCZIJjiDpczUoyA9jm9er1MeIzhPV0qCm1raO8I26cFQOp3umyzOVVifa/5tf
         0jynWXe/GsTjv4e3PaQdp0g4P2SdnwM0ZZu5PGL5Fud4Pzfacen07zic9g9XDzjjlX
         OUbMPVNcBq1gkkb1InM/2KdkrU73OLzRpENBk2ZLDXFOp0aQPEPryO2cBL6RQRxNZn
         DiyjhlMyv/qv7cb98vVD7w9Q3syzXQkoCpLrqJkwKHiEnpHw9UyxPFWB1tZZzvV52p
         77ALmPr2CHhuA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mario Limonciello <mario.limonciello@amd.com>, madcatx@atlas.cz,
        jwrdegoede@fedoraproject.org, Hans de Goede <hdegoede@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 01/10] pinctrl: Don't allow PINCTRL_AMD to be a module
Date:   Mon,  1 Aug 2022 15:02:13 -0400
Message-Id: <20220801190222.3818378-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 41ef3c1a6bb0fd4a3f81170dd17de3adbff80783 ]

It was observed that by allowing pinctrl_amd to be loaded
later in the boot process that interrupts sent to the GPIO
controller early in the boot are not serviced.  The kernel treats
these as a spurious IRQ and disables the IRQ.

This problem was exacerbated because it happened on a system with
an encrypted partition so the kernel object was not accesssible for
an extended period of time while waiting for a passphrase.

To avoid this situation from occurring, stop allowing pinctrl-amd
from being built as a module and instead require it to be built-in
or disabled.

Reported-by: madcatx@atlas.cz
Suggested-by: jwrdegoede@fedoraproject.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216230
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20220713175950.964-1-mario.limonciello@amd.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index f52960d2dfbe..bff144c97e66 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -32,7 +32,7 @@ config DEBUG_PINCTRL
 	  Say Y here to add some extra checks and diagnostics to PINCTRL calls.
 
 config PINCTRL_AMD
-	tristate "AMD GPIO pin control"
+	bool "AMD GPIO pin control"
 	depends on HAS_IOMEM
 	depends on ACPI || COMPILE_TEST
 	select GPIOLIB
-- 
2.35.1

