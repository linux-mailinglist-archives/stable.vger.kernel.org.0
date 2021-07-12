Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 713B53C5222
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349874AbhGLHoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:44:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347905AbhGLHkV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:40:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35CCB613C5;
        Mon, 12 Jul 2021 07:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075421;
        bh=rO/R9O6Nf0ZBXxZxkMffWHJCtxXIkGTKWnKSZx6gvX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SswVWgBEkB/nooZ4GqM1xhFo5frSoECx9H1hy05S4mCpq2Kzxx9J+g0d1dV8THxxU
         6Nhz3dVvNGAN874eZ8lZo7706i46NPvl2tzXt4TkwcaJJZsqrY2uhdcxxPNMhgm+0X
         +4w7p/HSs6aKne3wcfBvHhSgteVCSzEWeBefJ9xE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 216/800] platform/x86: touchscreen_dmi: Add an extra entry for the upside down Goodix touchscreen on Teclast X89 tablets
Date:   Mon, 12 Jul 2021 08:03:59 +0200
Message-Id: <20210712060944.070639481@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit a22e3803f2a4d947ff0083a9448a169269ea0f62 ]

Teclast X89 tablets come in 2 versions, with Windows pre-installed and with
Android pre-installed. These 2 versions have different DMI strings.

Add a match for the DMI strings used by the Android version BIOS.

Note the Android version BIOS has a bug in the DSDT where no IRQ is
provided, so for the touchscreen to work a DSDT override fixing this
is necessary as well.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210504185746.175461-4-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/touchscreen_dmi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index b452865da2a1..8b9926a9db7e 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -1347,6 +1347,14 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "X3 Plus"),
 		},
 	},
+	{
+		/* Teclast X89 (Android version / BIOS) */
+		.driver_data = (void *)&gdix1001_00_upside_down_data,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "WISKY"),
+			DMI_MATCH(DMI_BOARD_NAME, "3G062i"),
+		},
+	},
 	{
 		/* Teclast X89 (Windows version / BIOS) */
 		.driver_data = (void *)&gdix1001_01_upside_down_data,
-- 
2.30.2



