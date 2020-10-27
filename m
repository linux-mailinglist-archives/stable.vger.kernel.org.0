Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49AD29B08D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901028AbgJ0OUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:20:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:44756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2895033AbgJ0OUi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:20:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB2B92072D;
        Tue, 27 Oct 2020 14:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808438;
        bh=hVObMkP4w4Evwr+FFTtiTi63sgwcJ8Cg+PrCq/AqQto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yfkh9wsAIytHwLDsSkn/caQKzJuMauCDdqN50tnRDNE49SRAUt3BZ/lqYfclc/WuD
         UuqQs89ELQMaxl06QsOErvU5kTyuAePPPDzFJTLomHlpHCTInJOA89dgU0sYNLj2YB
         01vKYyAKeFcfSTvnotSaSi0ClYq7wAtliAbdGZFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 092/264] HID: roccat: add bounds checking in kone_sysfs_write_settings()
Date:   Tue, 27 Oct 2020 14:52:30 +0100
Message-Id: <20201027135435.013630670@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit d4f98dbfe717490e771b6e701904bfcf4b4557f0 ]

This code doesn't check if "settings->startup_profile" is within bounds
and that could result in an out of bounds array access.  What the code
does do is it checks if the settings can be written to the firmware, so
it's possible that the firmware has a bounds check?  It's safer and
easier to verify when the bounds checking is done in the kernel.

Fixes: 14bf62cde794 ("HID: add driver for Roccat Kone gaming mouse")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-roccat-kone.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
index bf4675a273965..9be8c31f613fd 100644
--- a/drivers/hid/hid-roccat-kone.c
+++ b/drivers/hid/hid-roccat-kone.c
@@ -297,31 +297,40 @@ static ssize_t kone_sysfs_write_settings(struct file *fp, struct kobject *kobj,
 	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
 	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
 	int retval = 0, difference, old_profile;
+	struct kone_settings *settings = (struct kone_settings *)buf;
 
 	/* I need to get my data in one piece */
 	if (off != 0 || count != sizeof(struct kone_settings))
 		return -EINVAL;
 
 	mutex_lock(&kone->kone_lock);
-	difference = memcmp(buf, &kone->settings, sizeof(struct kone_settings));
+	difference = memcmp(settings, &kone->settings,
+			    sizeof(struct kone_settings));
 	if (difference) {
-		retval = kone_set_settings(usb_dev,
-				(struct kone_settings const *)buf);
-		if (retval) {
-			mutex_unlock(&kone->kone_lock);
-			return retval;
+		if (settings->startup_profile < 1 ||
+		    settings->startup_profile > 5) {
+			retval = -EINVAL;
+			goto unlock;
 		}
 
+		retval = kone_set_settings(usb_dev, settings);
+		if (retval)
+			goto unlock;
+
 		old_profile = kone->settings.startup_profile;
-		memcpy(&kone->settings, buf, sizeof(struct kone_settings));
+		memcpy(&kone->settings, settings, sizeof(struct kone_settings));
 
 		kone_profile_activated(kone, kone->settings.startup_profile);
 
 		if (kone->settings.startup_profile != old_profile)
 			kone_profile_report(kone, kone->settings.startup_profile);
 	}
+unlock:
 	mutex_unlock(&kone->kone_lock);
 
+	if (retval)
+		return retval;
+
 	return sizeof(struct kone_settings);
 }
 static BIN_ATTR(settings, 0660, kone_sysfs_read_settings,
-- 
2.25.1



