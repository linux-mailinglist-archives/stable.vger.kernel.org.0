Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D709DE4D9E
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 16:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505476AbfJYN6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 09:58:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505469AbfJYN6H (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 09:58:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BBD2222C4;
        Fri, 25 Oct 2019 13:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011886;
        bh=JhgiOy7W35cOH2G64kH7kdFPGPQuCkXJeZQQJAg3rA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0/5EX1LCIKy+kl2mJ+i/5O9QF/ZwgPa5yoF8fl8A836YQFcIpgYPuU7juBZLHxYmU
         u9MMqNm6no0LWo+rMWX5CGh1Z4QPsc1ck/d9JgJmhVzSqEpoJIYDTkUUpQRapciqMR
         YBzM9pbDrFuZkg1XG64kWdznOXwMhKhF9V0LyBX0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Rene Wagner <redhatbugzilla@callerid.de>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 02/20] HID: i2c-hid: Add Odys Winbook 13 to descriptor override
Date:   Fri, 25 Oct 2019 09:57:42 -0400
Message-Id: <20191025135801.25739-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135801.25739-1-sashal@kernel.org>
References: <20191025135801.25739-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit f8f807441eefddc3c6d8a378421f0ede6361d565 ]

The Odys Winbook 13 uses a SIPODEV SP1064 touchpad, which does not
supply descriptors, add this to the DMI descriptor override list, fixing
the touchpad not working.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1526312
Reported-by: Rene Wagner <redhatbugzilla@callerid.de>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c b/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
index cac262a912c12..c5ac23b75143a 100644
--- a/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
+++ b/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
@@ -338,6 +338,14 @@ static const struct dmi_system_id i2c_hid_dmi_desc_override_table[] = {
 		},
 		.driver_data = (void *)&sipodev_desc
 	},
+	{
+		.ident = "Odys Winbook 13",
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "AXDIA International GmbH"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "WINBOOK 13"),
+		},
+		.driver_data = (void *)&sipodev_desc
+	},
 	{ }	/* Terminate list */
 };
 
-- 
2.20.1

