Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C96A681063
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236787AbjA3ODF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:03:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237025AbjA3OCy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:02:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0338610AB3
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:02:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88EAB6104F
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:02:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9395FC433D2;
        Mon, 30 Jan 2023 14:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087368;
        bh=Xe7J92i2sH5Zckn57n72NyncC0Xm1dnR3bR9VQWPKWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b/NHgj5b2TjUGlId836E2rZcrWc9uJmpeAbltMfqP0RKH75h5bkrxoIpnKf6/ZiNg
         87Zsd7qbxkx9E84HWGySUoWxACKnwSUQPtFt4OrScP4/YQAlIsoR3g7zuUu36T4FtA
         zRNkry9bJL9sdDkxGnwUeTgVznWIP7GSSrQ0KoLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 185/313] platform/x86: asus-wmi: Add quirk wmi_ignore_fan
Date:   Mon, 30 Jan 2023 14:50:20 +0100
Message-Id: <20230130134345.318695246@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index f051b21653d6..8e317d57ecc3 100644
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
2.39.0



