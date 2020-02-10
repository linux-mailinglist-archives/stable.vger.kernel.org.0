Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A51BF157832
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729668AbgBJNFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:05:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:38512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728730AbgBJMj6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:58 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A07924683;
        Mon, 10 Feb 2020 12:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338398;
        bh=/UYY92hIuxlKCb4IasHxTkK8sZop0UB/Sp72zc2SlF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2KN0n6HuDl5glrchobofBvZwXp/85nT0ijU7LoArk+c56l/YdbqyVEQGUJjuD51UT
         0TYsbKW+9zFcAY+7QCu/o/AdkICTQoDaUBSXP6eibvksUGGyGfuBBaIRq0pMgRLhks
         85IPD1ntWn7TIr+zuVVu9QLiZEIRan4yXCtR+JWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.5 095/367] ACPI: video: Do not export a non working backlight interface on MSI MS-7721 boards
Date:   Mon, 10 Feb 2020 04:30:08 -0800
Message-Id: <20200210122433.134091289@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit d21a91629f4b8e794fc4c0e0c17c85cedf1d806c upstream.

Despite our heuristics to not wrongly export a non working ACPI backlight
interface on desktop machines, we still end up exporting one on desktops
using a motherboard from the MSI MS-7721 series.

I've looked at improving the heuristics, but in this case a quirk seems
to be the only way to solve this.

While at it also add a comment to separate the video_detect_force_none
entries in the video_detect_dmi_table from other type of entries, as we
already do for the other entry types.

Cc: All applicable <stable@vger.kernel.org>
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1783786
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/video_detect.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -336,6 +336,11 @@ static const struct dmi_system_id video_
 		DMI_MATCH(DMI_PRODUCT_NAME, "Precision 7510"),
 		},
 	},
+
+	/*
+	 * Desktops which falsely report a backlight and which our heuristics
+	 * for this do not catch.
+	 */
 	{
 	 .callback = video_detect_force_none,
 	 .ident = "Dell OptiPlex 9020M",
@@ -344,6 +349,14 @@ static const struct dmi_system_id video_
 		DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 9020M"),
 		},
 	},
+	{
+	 .callback = video_detect_force_none,
+	 .ident = "MSI MS-7721",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "MSI"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "MS-7721"),
+		},
+	},
 	{ },
 };
 


