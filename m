Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBDACD763
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbfJFR2L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:28:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727127AbfJFR2K (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:28:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09AAF2087E;
        Sun,  6 Oct 2019 17:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382889;
        bh=+uE/jBQW2nAhPbZwmWhhKdEgpP4dh01GAwNZwEB0lmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m7tLKh1yn0E+NRFzTafKdQd4e053WbWyxc/7iuQxJZ0+e8eSpoXjaOmWElStWE1mY
         Z/tzqxHXQ2+3znbRY0AL9Oz+xXE/V7BgML6zIbp/ujTtXy9VkEtt56JFPcEGP0uXjb
         GNX28JLfhEjFyRI/ROlwJbLw5mCsfOP49N74sUmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Alexander Steffen <Alexander.Steffen@infineon.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 001/106] tpm: use tpm_try_get_ops() in tpm-sysfs.c.
Date:   Sun,  6 Oct 2019 19:20:07 +0200
Message-Id: <20191006171125.167365005@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171124.641144086@linuxfoundation.org>
References: <20191006171124.641144086@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

commit 2677ca98ae377517930c183248221f69f771c921 upstream

Use tpm_try_get_ops() in tpm-sysfs.c so that we can consider moving
other decorations (locking, localities, power management for example)
inside it. This direction can be of course taken only after other call
sites for tpm_transmit() have been treated in the same way.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
Tested-by: Stefan Berger <stefanb@linux.ibm.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Reviewed-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Tested-by: Alexander Steffen <Alexander.Steffen@infineon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm-sysfs.c | 134 ++++++++++++++++++++++-------------
 1 file changed, 83 insertions(+), 51 deletions(-)

diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index 83a77a4455380..177a60e5c6ec9 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -39,7 +39,6 @@ static ssize_t pubek_show(struct device *dev, struct device_attribute *attr,
 {
 	struct tpm_buf tpm_buf;
 	struct tpm_readpubek_out *out;
-	ssize_t rc;
 	int i;
 	char *str = buf;
 	struct tpm_chip *chip = to_tpm_chip(dev);
@@ -47,19 +46,18 @@ static ssize_t pubek_show(struct device *dev, struct device_attribute *attr,
 
 	memset(&anti_replay, 0, sizeof(anti_replay));
 
-	rc = tpm_buf_init(&tpm_buf, TPM_TAG_RQU_COMMAND, TPM_ORD_READPUBEK);
-	if (rc)
-		return rc;
+	if (tpm_try_get_ops(chip))
+		return 0;
+
+	if (tpm_buf_init(&tpm_buf, TPM_TAG_RQU_COMMAND, TPM_ORD_READPUBEK))
+		goto out_ops;
 
 	tpm_buf_append(&tpm_buf, anti_replay, sizeof(anti_replay));
 
-	rc = tpm_transmit_cmd(chip, NULL, tpm_buf.data, PAGE_SIZE,
+	if (tpm_transmit_cmd(chip, NULL, tpm_buf.data, PAGE_SIZE,
 			      READ_PUBEK_RESULT_MIN_BODY_SIZE, 0,
-			      "attempting to read the PUBEK");
-	if (rc) {
-		tpm_buf_destroy(&tpm_buf);
-		return 0;
-	}
+			      "attempting to read the PUBEK"))
+		goto out_buf;
 
 	out = (struct tpm_readpubek_out *)&tpm_buf.data[10];
 	str +=
@@ -90,9 +88,11 @@ static ssize_t pubek_show(struct device *dev, struct device_attribute *attr,
 			str += sprintf(str, "\n");
 	}
 
-	rc = str - buf;
+out_buf:
 	tpm_buf_destroy(&tpm_buf);
-	return rc;
+out_ops:
+	tpm_put_ops(chip);
+	return str - buf;
 }
 static DEVICE_ATTR_RO(pubek);
 
@@ -106,12 +106,16 @@ static ssize_t pcrs_show(struct device *dev, struct device_attribute *attr,
 	char *str = buf;
 	struct tpm_chip *chip = to_tpm_chip(dev);
 
-	rc = tpm_getcap(chip, TPM_CAP_PROP_PCR, &cap,
-			"attempting to determine the number of PCRS",
-			sizeof(cap.num_pcrs));
-	if (rc)
+	if (tpm_try_get_ops(chip))
 		return 0;
 
+	if (tpm_getcap(chip, TPM_CAP_PROP_PCR, &cap,
+		       "attempting to determine the number of PCRS",
+		       sizeof(cap.num_pcrs))) {
+		tpm_put_ops(chip);
+		return 0;
+	}
+
 	num_pcrs = be32_to_cpu(cap.num_pcrs);
 	for (i = 0; i < num_pcrs; i++) {
 		rc = tpm_pcr_read_dev(chip, i, digest);
@@ -122,6 +126,7 @@ static ssize_t pcrs_show(struct device *dev, struct device_attribute *attr,
 			str += sprintf(str, "%02X ", digest[j]);
 		str += sprintf(str, "\n");
 	}
+	tpm_put_ops(chip);
 	return str - buf;
 }
 static DEVICE_ATTR_RO(pcrs);
@@ -129,16 +134,21 @@ static DEVICE_ATTR_RO(pcrs);
 static ssize_t enabled_show(struct device *dev, struct device_attribute *attr,
 		     char *buf)
 {
+	struct tpm_chip *chip = to_tpm_chip(dev);
+	ssize_t rc = 0;
 	cap_t cap;
-	ssize_t rc;
 
-	rc = tpm_getcap(to_tpm_chip(dev), TPM_CAP_FLAG_PERM, &cap,
-			"attempting to determine the permanent enabled state",
-			sizeof(cap.perm_flags));
-	if (rc)
+	if (tpm_try_get_ops(chip))
 		return 0;
 
+	if (tpm_getcap(chip, TPM_CAP_FLAG_PERM, &cap,
+		       "attempting to determine the permanent enabled state",
+		       sizeof(cap.perm_flags)))
+		goto out_ops;
+
 	rc = sprintf(buf, "%d\n", !cap.perm_flags.disable);
+out_ops:
+	tpm_put_ops(chip);
 	return rc;
 }
 static DEVICE_ATTR_RO(enabled);
@@ -146,16 +156,21 @@ static DEVICE_ATTR_RO(enabled);
 static ssize_t active_show(struct device *dev, struct device_attribute *attr,
 		    char *buf)
 {
+	struct tpm_chip *chip = to_tpm_chip(dev);
+	ssize_t rc = 0;
 	cap_t cap;
-	ssize_t rc;
 
-	rc = tpm_getcap(to_tpm_chip(dev), TPM_CAP_FLAG_PERM, &cap,
-			"attempting to determine the permanent active state",
-			sizeof(cap.perm_flags));
-	if (rc)
+	if (tpm_try_get_ops(chip))
 		return 0;
 
+	if (tpm_getcap(chip, TPM_CAP_FLAG_PERM, &cap,
+		       "attempting to determine the permanent active state",
+		       sizeof(cap.perm_flags)))
+		goto out_ops;
+
 	rc = sprintf(buf, "%d\n", !cap.perm_flags.deactivated);
+out_ops:
+	tpm_put_ops(chip);
 	return rc;
 }
 static DEVICE_ATTR_RO(active);
@@ -163,16 +178,21 @@ static DEVICE_ATTR_RO(active);
 static ssize_t owned_show(struct device *dev, struct device_attribute *attr,
 			  char *buf)
 {
+	struct tpm_chip *chip = to_tpm_chip(dev);
+	ssize_t rc = 0;
 	cap_t cap;
-	ssize_t rc;
 
-	rc = tpm_getcap(to_tpm_chip(dev), TPM_CAP_PROP_OWNER, &cap,
-			"attempting to determine the owner state",
-			sizeof(cap.owned));
-	if (rc)
+	if (tpm_try_get_ops(chip))
 		return 0;
 
+	if (tpm_getcap(to_tpm_chip(dev), TPM_CAP_PROP_OWNER, &cap,
+		       "attempting to determine the owner state",
+		       sizeof(cap.owned)))
+		goto out_ops;
+
 	rc = sprintf(buf, "%d\n", cap.owned);
+out_ops:
+	tpm_put_ops(chip);
 	return rc;
 }
 static DEVICE_ATTR_RO(owned);
@@ -180,16 +200,21 @@ static DEVICE_ATTR_RO(owned);
 static ssize_t temp_deactivated_show(struct device *dev,
 				     struct device_attribute *attr, char *buf)
 {
+	struct tpm_chip *chip = to_tpm_chip(dev);
+	ssize_t rc = 0;
 	cap_t cap;
-	ssize_t rc;
 
-	rc = tpm_getcap(to_tpm_chip(dev), TPM_CAP_FLAG_VOL, &cap,
-			"attempting to determine the temporary state",
-			sizeof(cap.stclear_flags));
-	if (rc)
+	if (tpm_try_get_ops(chip))
 		return 0;
 
+	if (tpm_getcap(to_tpm_chip(dev), TPM_CAP_FLAG_VOL, &cap,
+		       "attempting to determine the temporary state",
+		       sizeof(cap.stclear_flags)))
+		goto out_ops;
+
 	rc = sprintf(buf, "%d\n", cap.stclear_flags.deactivated);
+out_ops:
+	tpm_put_ops(chip);
 	return rc;
 }
 static DEVICE_ATTR_RO(temp_deactivated);
@@ -198,15 +223,18 @@ static ssize_t caps_show(struct device *dev, struct device_attribute *attr,
 			 char *buf)
 {
 	struct tpm_chip *chip = to_tpm_chip(dev);
-	cap_t cap;
-	ssize_t rc;
+	ssize_t rc = 0;
 	char *str = buf;
+	cap_t cap;
 
-	rc = tpm_getcap(chip, TPM_CAP_PROP_MANUFACTURER, &cap,
-			"attempting to determine the manufacturer",
-			sizeof(cap.manufacturer_id));
-	if (rc)
+	if (tpm_try_get_ops(chip))
 		return 0;
+
+	if (tpm_getcap(chip, TPM_CAP_PROP_MANUFACTURER, &cap,
+		       "attempting to determine the manufacturer",
+		       sizeof(cap.manufacturer_id)))
+		goto out_ops;
+
 	str += sprintf(str, "Manufacturer: 0x%x\n",
 		       be32_to_cpu(cap.manufacturer_id));
 
@@ -223,20 +251,22 @@ static ssize_t caps_show(struct device *dev, struct device_attribute *attr,
 			       cap.tpm_version_1_2.revMinor);
 	} else {
 		/* Otherwise just use TPM_STRUCT_VER */
-		rc = tpm_getcap(chip, TPM_CAP_VERSION_1_1, &cap,
-				"attempting to determine the 1.1 version",
-				sizeof(cap.tpm_version));
-		if (rc)
-			return 0;
+		if (tpm_getcap(chip, TPM_CAP_VERSION_1_1, &cap,
+			       "attempting to determine the 1.1 version",
+			       sizeof(cap.tpm_version)))
+			goto out_ops;
+
 		str += sprintf(str,
 			       "TCG version: %d.%d\nFirmware version: %d.%d\n",
 			       cap.tpm_version.Major,
 			       cap.tpm_version.Minor,
 			       cap.tpm_version.revMajor,
 			       cap.tpm_version.revMinor);
-	}
-
-	return str - buf;
+}
+	rc = str - buf;
+out_ops:
+	tpm_put_ops(chip);
+	return rc;
 }
 static DEVICE_ATTR_RO(caps);
 
@@ -244,10 +274,12 @@ static ssize_t cancel_store(struct device *dev, struct device_attribute *attr,
 			    const char *buf, size_t count)
 {
 	struct tpm_chip *chip = to_tpm_chip(dev);
-	if (chip == NULL)
+
+	if (tpm_try_get_ops(chip))
 		return 0;
 
 	chip->ops->cancel(chip);
+	tpm_put_ops(chip);
 	return count;
 }
 static DEVICE_ATTR_WO(cancel);
-- 
2.20.1



