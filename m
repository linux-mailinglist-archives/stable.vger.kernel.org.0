Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACCF72269A6
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732373AbgGTQ2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:28:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732245AbgGTP7e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:59:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA1762176B;
        Mon, 20 Jul 2020 15:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260772;
        bh=tcGMKR5WdAThsy1xT6ryAEhkxohIpEi3AlS1Ix3p688=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w3TpsZvjYEQCY9IuuKIropNm4/SrMcG7q3appc0b5863zFYX5MrwmjlQqTQbzJFlu
         akLE7f9g5q1D5ldOX4RN4otdzqjRBkZtow7HCUFUh2ejJh3D1PfMEEnSu9dhiKswM2
         RqMJ+0Y9BkJHv7ig9Na0uuIwG4b/1cqI0KnqqImc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 090/215] ACPI: video: Use native backlight on Acer TravelMate 5735Z
Date:   Mon, 20 Jul 2020 17:36:12 +0200
Message-Id: <20200720152824.488069546@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Menzel <pmenzel@molgen.mpg.de>

[ Upstream commit c41c36e900a337b4132b12ccabc97f5578248b44 ]

Currently, changing the brightness of the internal display of the Acer
TravelMate 5735Z does not work. Pressing the function keys or changing the
slider, GNOME Shell 3.36.2 displays the OSD (five steps), but the
brightness does not change.

The Acer TravelMate 5735Z shipped with Windows 7 and as such does not
trigger our "win8 ready" heuristic for preferring the native backlight
interface.

Still ACPI backlight control doesn't work on this model, where as the
native (intel_video) backlight interface does work by adding
`acpi_backlight=native` or `acpi_backlight=none` to Linux’ command line.

So, add a quirk to force using native backlight control on this model.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=207835
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 8daeeb5e3eb67..5bcb4c01ec5f0 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -345,6 +345,16 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_BOARD_NAME, "JV50"),
 		},
 	},
+	{
+	 /* https://bugzilla.kernel.org/show_bug.cgi?id=207835 */
+	 .callback = video_detect_force_native,
+	 .ident = "Acer TravelMate 5735Z",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 5735Z"),
+		DMI_MATCH(DMI_BOARD_NAME, "BA51_MV"),
+		},
+	},
 
 	/*
 	 * Desktops which falsely report a backlight and which our heuristics
-- 
2.25.1



