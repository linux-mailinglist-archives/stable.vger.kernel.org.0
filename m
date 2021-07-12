Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F4D3C48CE
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237851AbhGLGlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:41:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237131AbhGLGiL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:38:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 573A560238;
        Mon, 12 Jul 2021 06:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071663;
        bh=YVJukNQFMmciva0G0vYcP3V0SxYJ+N3HSDg3G7Zy4bA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iJFAXwo301txe58nDHZ6vEnprypo99erTwuZi14rczY91WqnMumXtzQrS3J/18Hbs
         8ILjoYhpz35OFa52glm7HyGw6lGxzCBrebCnT2OMy768OrDw+e//w/n/Rj/5J+b5mg
         lS1AtxJEmpyhTKxHhdxfMRXQT+dAxkdlxr8mu/fQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Luke D. Jones" <luke@ljones.dev>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 167/593] ACPI: video: use native backlight for GA401/GA502/GA503
Date:   Mon, 12 Jul 2021 08:05:27 +0200
Message-Id: <20210712060901.407044131@linuxfoundation.org>
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

From: Luke D Jones <luke@ljones.dev>

[ Upstream commit 2dfbacc65d1d2eae587ccb6b93f6280542641858 ]

Force backlight control in these models to use the native interface
at /sys/class/backlight/amdgpu_bl0.

Signed-off-by: Luke D. Jones <luke@ljones.dev>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 83cd4c95faf0..33474fd96991 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -385,6 +385,30 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_BOARD_NAME, "BA51_MV"),
 		},
 	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "ASUSTeK COMPUTER INC. GA401",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "GA401"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "ASUSTeK COMPUTER INC. GA502",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "GA502"),
+		},
+	},
+	{
+	.callback = video_detect_force_native,
+	.ident = "ASUSTeK COMPUTER INC. GA503",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "GA503"),
+		},
+	},
 
 	/*
 	 * Desktops which falsely report a backlight and which our heuristics
-- 
2.30.2



