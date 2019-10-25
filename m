Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05464E4CD8
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 15:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505247AbfJYN4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 09:56:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505244AbfJYN4J (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 09:56:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2094C222C4;
        Fri, 25 Oct 2019 13:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011768;
        bh=pMRvbdDCb4dImnhTz2eaL8s9Wnfeqq0pbrx6tQqzFUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vH9YQTXkSLH0RSFM9TnDV3JA9GtB38aOiz87Ldl2whCttA+57qH7d+Ta3Lgm1ORMv
         i2iLjyC1WfdHKrIgikNxDuijt4IlU64RtJeOv/Mq1mmUpDTdRzo7Y0ILprjkOzEPGe
         2wpyIyeoTgRJ1vckmil5ALNHNOdv+fO22UmgNgtM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Rui <rui.zhang@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 03/37] ACPI: video: Use vendor backlight on Sony VPCEH3U1E
Date:   Fri, 25 Oct 2019 09:55:27 -0400
Message-Id: <20191025135603.25093-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135603.25093-1-sashal@kernel.org>
References: <20191025135603.25093-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit aefa763b18a220f5fc1d5ab02af09158b6cc36ea ]

On Sony Vaio VPCEH3U1E, ACPI backlight control does not work, and native
backlight works. Thus force use vendor backlight control on this system.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=202401
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 43587ac680e47..0e0a3929e34e2 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -141,6 +141,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "UL30A"),
 		},
 	},
+	{
+	.callback = video_detect_force_vendor,
+	.ident = "Sony VPCEH3U1E",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VPCEH3U1E"),
+		},
+	},
 
 	/*
 	 * These models have a working acpi_video backlight control, and using
-- 
2.20.1

