Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 467B365820B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234821AbiL1Qc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234706AbiL1Qcb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:32:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 217E419C16
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:29:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EACDB8171E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1CFCC433D2;
        Wed, 28 Dec 2022 16:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244962;
        bh=Da6gWwcZyOn9qM4GMEFzWvDv9vncCig2qTKEeta2DU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vw7Q5REuOZZcnTrLzkbDuM6oMuoTyd8vvZ0wEhYUWYT5ae6Fm5lY9Gdbr3PaG0Pv4
         bXugt3hY/bj2S8OcJSS7qxYcvRYB+k6Husvc8Vg1MZPZrzWGKScmLQLgCZ/OIqTnkM
         lId/jpa/vGg30W1NMqieiDLZYQkXPGl7msO7lLUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "=?UTF-8?q?Daniel=20P . =20Berrang=C3=A9?=" <berrange@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0769/1146] watchdog: iTCO_wdt: Set NO_REBOOT if the watchdog is not already running
Date:   Wed, 28 Dec 2022 15:38:28 +0100
Message-Id: <20221228144351.037224390@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit ef9b7bf52c2f47f0a9bf988543c577b92c92d15e ]

Daniel reported that the commit 1ae3e78c0820 ("watchdog: iTCO_wdt: No
need to stop the timer in probe") makes QEMU implementation of the iTCO
watchdog not to trigger reboot anymore when NO_REBOOT flag is initially
cleared using this option (in QEMU command line):

  -global ICH9-LPC.noreboot=false

The problem with the commit is that it left the unconditional setting of
NO_REBOOT that is not cleared anymore when the kernel keeps pinging the
watchdog (as opposed to the previous code that called iTCO_wdt_stop()
that cleared it).

Fix this so that we only set NO_REBOOT if the watchdog was not initially
running.

Fixes: 1ae3e78c0820 ("watchdog: iTCO_wdt: No need to stop the timer in probe")
Reported-by: Daniel P. Berrangé <berrange@redhat.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Tested-by: Daniel P. Berrangé <berrange@redhat.com>
Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20221028062750.45451-1-mika.westerberg@linux.intel.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/iTCO_wdt.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 34693f11385f..e937b4dd28be 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -423,14 +423,18 @@ static unsigned int iTCO_wdt_get_timeleft(struct watchdog_device *wd_dev)
 	return time_left;
 }
 
-static void iTCO_wdt_set_running(struct iTCO_wdt_private *p)
+/* Returns true if the watchdog was running */
+static bool iTCO_wdt_set_running(struct iTCO_wdt_private *p)
 {
 	u16 val;
 
-	/* Bit 11: TCO Timer Halt -> 0 = The TCO timer is * enabled */
+	/* Bit 11: TCO Timer Halt -> 0 = The TCO timer is enabled */
 	val = inw(TCO1_CNT(p));
-	if (!(val & BIT(11)))
+	if (!(val & BIT(11))) {
 		set_bit(WDOG_HW_RUNNING, &p->wddev.status);
+		return true;
+	}
+	return false;
 }
 
 /*
@@ -518,9 +522,6 @@ static int iTCO_wdt_probe(struct platform_device *pdev)
 		return -ENODEV;	/* Cannot reset NO_REBOOT bit */
 	}
 
-	/* Set the NO_REBOOT bit to prevent later reboots, just for sure */
-	p->update_no_reboot_bit(p->no_reboot_priv, true);
-
 	if (turn_SMI_watchdog_clear_off >= p->iTCO_version) {
 		/*
 		 * Bit 13: TCO_EN -> 0
@@ -572,7 +573,13 @@ static int iTCO_wdt_probe(struct platform_device *pdev)
 	watchdog_set_drvdata(&p->wddev, p);
 	platform_set_drvdata(pdev, p);
 
-	iTCO_wdt_set_running(p);
+	if (!iTCO_wdt_set_running(p)) {
+		/*
+		 * If the watchdog was not running set NO_REBOOT now to
+		 * prevent later reboots.
+		 */
+		p->update_no_reboot_bit(p->no_reboot_priv, true);
+	}
 
 	/* Check that the heartbeat value is within it's range;
 	   if not reset to the default */
-- 
2.35.1



