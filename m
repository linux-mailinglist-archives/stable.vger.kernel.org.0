Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27636DD1D0
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730661AbfJRWGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:06:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730287AbfJRWGE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:06:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AC71205F4;
        Fri, 18 Oct 2019 22:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436363;
        bh=A+nXIhWOh/hn+hSxK3tP54icEmodpvMjam53PuBkrA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MI+tbiTdsoRX+ycBpVxs92MWoCr2Abb1yYbZZ4GQrJwNJ9C72w4vWfCW4VYPDMvXt
         jrhGfwdZcVUdFPyGZNJRClb/5ylyB4pwKU336LFBP7TaFsRl9hGxOQV/6zlMkUhRwX
         HH2GnW7q13Ka5wqzBhs3Ho+ULxOIzJKw4tg3D5V4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Rene Wagner <redhatbugzilla@callerid.de>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 019/100] HID: i2c-hid: Add Odys Winbook 13 to descriptor override
Date:   Fri, 18 Oct 2019 18:04:04 -0400
Message-Id: <20191018220525.9042-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
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
index 89f2976f9c534..fd1b6eea6d2fd 100644
--- a/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
+++ b/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
@@ -346,6 +346,14 @@ static const struct dmi_system_id i2c_hid_dmi_desc_override_table[] = {
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

