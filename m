Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9702C2269BE
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731374AbgGTQ3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:29:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732200AbgGTP7V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:59:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B59322CBB;
        Mon, 20 Jul 2020 15:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260761;
        bh=RnqPvbW0WCd7AN3mwXv903E996tC0ecYc6XsZIODR5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BNtTg3SvdUBxzzNY+a1wuLtwtb3+uxUTfCGFYnV9FJBrPMNSXjC8B+sAa0d4u4kG+
         mVPphDu9HVpSSJlfW6jG7llQmBMmZmyJDGC9gvyne7gMLjNHQfswQi0+Znjwa8fAQW
         q6m1T1mW56V8U4NOeEJYajdgdZ7Ggk2PkAQ0uyjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 086/215] ACPI: video: Use native backlight on Acer Aspire 5783z
Date:   Mon, 20 Jul 2020 17:36:08 +0200
Message-Id: <20200720152824.294111191@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 1c8fbc1f9bfb804ef2f0d4ee9397ab800e33f23a ]

The Acer Aspire 5783z shipped with Windows 7 and as such does not trigger
our "win8 ready" heuristic for prefering the native backlight interface.

Still ACPI backlight control doesn't work on this model, where as the
native (intel_video) backlight interface does work. Add a quirk to
force using native backlight control on this model.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index e63fd7bfd3a53..8daeeb5e3eb67 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -336,6 +336,15 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "Precision 7510"),
 		},
 	},
+	{
+	 .callback = video_detect_force_native,
+	 .ident = "Acer Aspire 5738z",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5738"),
+		DMI_MATCH(DMI_BOARD_NAME, "JV50"),
+		},
+	},
 
 	/*
 	 * Desktops which falsely report a backlight and which our heuristics
-- 
2.25.1



