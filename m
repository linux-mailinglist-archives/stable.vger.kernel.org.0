Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA28593C75
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346913AbiHOU1W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347520AbiHOUZz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:25:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5369C8E9;
        Mon, 15 Aug 2022 12:03:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B526DB81109;
        Mon, 15 Aug 2022 19:03:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08EF9C433C1;
        Mon, 15 Aug 2022 19:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590189;
        bh=3ujAZeKEOLhx37OJc1LDzbpYlVYHE67f9O0jS+7wG8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ft5y9Pttgxu8NtJFZvnFtwfNYaHAHCHjzYd8q8/j2nTVfICEpEWVWBZrr3RJBdhGu
         9ZZ5qqPZoApClQ7D9SPzrR57VB+JaWb6XrmVSC5QgucATOUiizrO+JouQPlc9Io56N
         8SUWR7PTQdsEAnT9CYzHA4but6PZmtxePL2N3cvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, madcatx@atlas.cz,
        jwrdegoede@fedoraproject.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0181/1095] pinctrl: Dont allow PINCTRL_AMD to be a module
Date:   Mon, 15 Aug 2022 19:53:00 +0200
Message-Id: <20220815180437.131239314@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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



