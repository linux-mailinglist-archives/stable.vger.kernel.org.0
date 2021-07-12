Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE7A3C48E0
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237199AbhGLGlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:41:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236502AbhGLGjP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:39:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6A88601FC;
        Mon, 12 Jul 2021 06:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071682;
        bh=VKOJSyVDFgfKJRBNIrvLF5o2jZGSt9PNpLQ8gcEGNQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jbEA4oMqAvemfrLID5VVpbFdWEpqQ2GNSNLwdxKBBefWPZd9z7BX2tvFSBJrsE/xn
         Uj9KmWEyvfMZb8dSY1CASj9+crPbf1zjmQ6yrwo3h/AD9XLAtimdPfZOcmpKc+EwzM
         T81gdK9ajyHLb1nr9VrwqcfPCm3E0DHnbqX5NY+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 174/593] platform/x86: touchscreen_dmi: Add an extra entry for the upside down Goodix touchscreen on Teclast X89 tablets
Date:   Mon, 12 Jul 2021 08:05:34 +0200
Message-Id: <20210712060902.164112562@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index e52ff09b81de..ebae21b78327 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -1285,6 +1285,14 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
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



