Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 484A6333E06
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbhCJNZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:46196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233027AbhCJNYs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 232E364FFC;
        Wed, 10 Mar 2021 13:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382687;
        bh=1uhXVIS//+Clk2H0qeN43XnBqr6HjMCTkAP1apyCX+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HbsCtTagiZJOlKBm/dmkyb1gadSV+/w89mhevXUoSu1ZNrtCZYdym7v/OFOfbje+D
         1ZdWWfVVUUFUQ4ZdJosPwaoNgVG6QViB+SbHTuqj5JV/SblkFq/lciuLBMJteLHxH5
         eIoQnlAGBChVHdy0YzBwlIC0QKVL/6XGzpPsloEI=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Jasper St. Pierre" <jstpierre@mecheye.net>,
        Chris Chiu <chiu@endlessos.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 23/49] ACPI: video: Add DMI quirk for GIGABYTE GB-BXBT-2807
Date:   Wed, 10 Mar 2021 14:23:34 +0100
Message-Id: <20210310132322.685806668@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132321.948258062@linuxfoundation.org>
References: <20210310132321.948258062@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Jasper St. Pierre <jstpierre@mecheye.net>

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
index 4f5463b2a217..811d298637cb 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -140,6 +140,13 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
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
2.30.1



