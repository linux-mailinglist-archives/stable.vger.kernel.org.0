Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD12D66C138
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbjAPOJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:09:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbjAPOH1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:07:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34FBC22DC1;
        Mon, 16 Jan 2023 06:03:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3AF2B80E93;
        Mon, 16 Jan 2023 14:03:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2D6C433F1;
        Mon, 16 Jan 2023 14:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877821;
        bh=IAwDKuIV0MxKhguQcN9TOpFeWEj6nnEjSeHGMGISau8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HRqoBb6Xqb9FYurdwu+D8sy2SI1tVoIBxwkj9C0JIQ4gXreK7R5UR7/46ip9xcnqp
         iFy43KQpZdOAF96q998KRNIFQ/G1ja2J7Cw0OCI0mhU6SFlYq7bMEUSpbTigMCqPZM
         4XW+8nzCnffPxMGGN7iMQHQ3JMmlhW+DJfCB/zx/ft1wqiLruiytDwhJt9FHZYCM74
         ufPj5NwULJ707Ix+vA6NL9gdEbjhjmwCR+7NTk3HnNbS9jiX/eZ+z71PwzI8Ur0j9C
         Try5RTHPtXAmDHmlnSppRxjYvdWa/VuAy20kRX1xQLRFXB2b5Ua0buVrXkyKNeGflk
         KelY4TB2lHDmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, corentin.chary@gmail.com,
        markgross@kernel.org, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 47/53] platform/x86: asus-wmi: Add quirk wmi_ignore_fan
Date:   Mon, 16 Jan 2023 09:01:47 -0500
Message-Id: <20230116140154.114951-47-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140154.114951-1-sashal@kernel.org>
References: <20230116140154.114951-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit c874b6de4cdfa2822a07b479887cd5f87fb5d078 ]

Some laptops have a fan device listed in their ACPI tables but do not
actually contain a fan.
Introduce a quirk that can be used to override the fan detection logic.

This was observed with a ASUS VivoBook E410MA running firmware
E410MAB.304.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20221221-asus-fan-v1-1-e07f3949725b@weissschuh.net
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 4 +++-
 drivers/platform/x86/asus-wmi.h | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 872efc1d5b36..2d0b0805ff29 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -2243,7 +2243,9 @@ static int asus_wmi_fan_init(struct asus_wmi *asus)
 	asus->fan_type = FAN_TYPE_NONE;
 	asus->agfn_pwm = -1;
 
-	if (asus_wmi_dev_is_present(asus, ASUS_WMI_DEVID_CPU_FAN_CTRL))
+	if (asus->driver->quirks->wmi_ignore_fan)
+		asus->fan_type = FAN_TYPE_NONE;
+	else if (asus_wmi_dev_is_present(asus, ASUS_WMI_DEVID_CPU_FAN_CTRL))
 		asus->fan_type = FAN_TYPE_SPEC83;
 	else if (asus_wmi_has_agfn_fan(asus))
 		asus->fan_type = FAN_TYPE_AGFN;
diff --git a/drivers/platform/x86/asus-wmi.h b/drivers/platform/x86/asus-wmi.h
index 65316998b898..a478ebfd34df 100644
--- a/drivers/platform/x86/asus-wmi.h
+++ b/drivers/platform/x86/asus-wmi.h
@@ -38,6 +38,7 @@ struct quirk_entry {
 	bool store_backlight_power;
 	bool wmi_backlight_set_devstate;
 	bool wmi_force_als_set;
+	bool wmi_ignore_fan;
 	enum asus_wmi_tablet_switch_mode tablet_switch_mode;
 	int wapf;
 	/*
-- 
2.35.1

