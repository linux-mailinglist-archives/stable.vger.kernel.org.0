Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F14202E162F
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728966AbgLWC6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:58:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:45508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728964AbgLWCUZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:20:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E9322256F;
        Wed, 23 Dec 2020 02:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690010;
        bh=C1V8F8DQ0RPPzESWTdeKqnGzBe0X7hN6HCddQAmlQDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r0Lu3fhHL/wABqfp6KavItaLYkvzURTBS1wMnpzDRXuDWzYV29VduG4gMONGJAe3N
         7Wi51F8MLCSHGveNpHmXntPXsAG2bDOiPLeBb4fUFj9E4vXCklcIsGS1FgAnbEHM0M
         XQD4dU+R6tcfo2YI4h2T3Y4cB2wd8OAkrkw8w9Q4Jq4V2F8/jcjZ0RlxqEBhA/E8N3
         yL9akp6S9+P02Ug5GlBWyD20mAOYduqGrK2vvxmUK4GT3LdB6ZqGT/L0/0bsVH8ZgZ
         n5Vf7qW4MPk1dJNjW+8b+klK1Ppae+M8+UophaGPxQ2XyAJKboFw+dv4S3aBBRJ7oS
         jHuLY0itnegfg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jasper St. Pierre" <jstpierre@mecheye.net>,
        Chris Chiu <chiu@endlessos.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 090/130] ACPI: video: Add DMI quirk for GIGABYTE GB-BXBT-2807
Date:   Tue, 22 Dec 2020 21:17:33 -0500
Message-Id: <20201223021813.2791612-90-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jasper St. Pierre" <jstpierre@mecheye.net>

[ Upstream commit 25417185e9b5ff90746d50769d2a3fcd1629e254 ]

The GIGABYTE GB-BXBT-2807 is a mini-PC which uses off the shelf
components, like an Intel GPU which is meant for mobile systems.
As such, it, by default, has a backlight controller exposed.

Unfortunately, the backlight controller only confuses userspace, which
sees the existence of a backlight device node and has the unrealistic
belief that there is actually a backlight there!

Add a DMI quirk to force the backlight off on this system.

Signed-off-by: Jasper St. Pierre <jstpierre@mecheye.net>
Reviewed-by: Chris Chiu <chiu@endlessos.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 55af78b55c513..301ffe5b8feb0 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -143,6 +143,13 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 	},
 	{
 	.callback = video_detect_force_vendor,
+	.ident = "GIGABYTE GB-BXBT-2807",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "GB-BXBT-2807"),
+		},
+	},
+	{
 	.ident = "Sony VPCEH3U1E",
 	.matches = {
 		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-- 
2.27.0

