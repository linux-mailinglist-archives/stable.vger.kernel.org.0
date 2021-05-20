Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C17E38AA99
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240343AbhETLPW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:15:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239981AbhETLMh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:12:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01F5961D4E;
        Thu, 20 May 2021 10:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505269;
        bh=cvoZfSTAUw9JrapwZzE2DjN0socTY7hAVAnWIxQh1UE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FF9hS9gShOp05pQqdadvhkoIrBlHCwdXmS8xavckFYyyx53d78N4jxeZnpEq7jvmi
         i0/d5+Ii0IQR/bHXUmQrQgDS726JFxu7DVHlo4bbuu+/r4PZbVJwxk+A5S0G9zoydi
         k1jmzpqXF1vJgdfUuV+hhkIMXv1ZC1NqLEVZUucU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 4.4 058/190] misc: lis3lv02d: Fix false-positive WARN on various HP models
Date:   Thu, 20 May 2021 11:22:02 +0200
Message-Id: <20210520092104.087024625@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 3641762c1c9c7cfd84a7061a0a73054f09b412e3 upstream.

Before this commit lis3lv02d_get_pwron_wait() had a WARN_ONCE() to catch
a potential divide by 0. WARN macros should only be used to catch internal
kernel bugs and that is not the case here. We have been receiving a lot of
bug reports about kernel backtraces caused by this WARN.

The div value being checked comes from the lis3->odrs[] array. Which
is sized to be a power-of-2 matching the number of bits in lis3->odr_mask.

The only lis3 model where this array is not entirely filled with non zero
values. IOW the only model where we can hit the div == 0 check is the
3dc ("8 bits 3DC sensor") model:

int lis3_3dc_rates[16] = {0, 1, 10, 25, 50, 100, 200, 400, 1600, 5000};

Note the 0 value at index 0, according to the datasheet an odr index of 0
means "Power-down mode". HP typically uses a lis3 accelerometer for HDD
fall protection. What I believe is happening here is that on newer
HP devices, which only contain a SDD, the BIOS is leaving the lis3 device
powered-down since it is not used for HDD fall protection.

Note that the lis3_3dc_rates array initializer only specifies 10 values,
which matches the datasheet. So it also contains 6 zero values at the end.

Replace the WARN with a normal check, which treats an odr index of 0
as power-down and uses a normal dev_err() to report the error in case
odr index point past the initialized part of the array.

Fixes: 1510dd5954be ("lis3lv02d: avoid divide by zero due to unchecked")
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=785814
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1817027
BugLink: https://bugs.centos.org/view.php?id=10720
Link: https://lore.kernel.org/r/20210217102501.31758-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/lis3lv02d/lis3lv02d.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/drivers/misc/lis3lv02d/lis3lv02d.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d.c
@@ -220,7 +220,7 @@ static int lis3_3dc_rates[16] = {0, 1, 1
 static int lis3_3dlh_rates[4] = {50, 100, 400, 1000};
 
 /* ODR is Output Data Rate */
-static int lis3lv02d_get_odr(struct lis3lv02d *lis3)
+static int lis3lv02d_get_odr_index(struct lis3lv02d *lis3)
 {
 	u8 ctrl;
 	int shift;
@@ -228,15 +228,23 @@ static int lis3lv02d_get_odr(struct lis3
 	lis3->read(lis3, CTRL_REG1, &ctrl);
 	ctrl &= lis3->odr_mask;
 	shift = ffs(lis3->odr_mask) - 1;
-	return lis3->odrs[(ctrl >> shift)];
+	return (ctrl >> shift);
 }
 
 static int lis3lv02d_get_pwron_wait(struct lis3lv02d *lis3)
 {
-	int div = lis3lv02d_get_odr(lis3);
+	int odr_idx = lis3lv02d_get_odr_index(lis3);
+	int div = lis3->odrs[odr_idx];
 
-	if (WARN_ONCE(div == 0, "device returned spurious data"))
+	if (div == 0) {
+		if (odr_idx == 0) {
+			/* Power-down mode, not sampling no need to sleep */
+			return 0;
+		}
+
+		dev_err(&lis3->pdev->dev, "Error unknown odrs-index: %d\n", odr_idx);
 		return -ENXIO;
+	}
 
 	/* LIS3 power on delay is quite long */
 	msleep(lis3->pwron_delay / div);
@@ -819,9 +827,12 @@ static ssize_t lis3lv02d_rate_show(struc
 			struct device_attribute *attr, char *buf)
 {
 	struct lis3lv02d *lis3 = dev_get_drvdata(dev);
+	int odr_idx;
 
 	lis3lv02d_sysfs_poweron(lis3);
-	return sprintf(buf, "%d\n", lis3lv02d_get_odr(lis3));
+
+	odr_idx = lis3lv02d_get_odr_index(lis3);
+	return sprintf(buf, "%d\n", lis3->odrs[odr_idx]);
 }
 
 static ssize_t lis3lv02d_rate_set(struct device *dev,


