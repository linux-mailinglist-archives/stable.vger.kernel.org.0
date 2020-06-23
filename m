Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C987F206565
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387859AbgFWUCe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:02:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387851AbgFWUCb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:02:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F71D2080C;
        Tue, 23 Jun 2020 20:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942551;
        bh=6KHaJGlTD33dc/Mhhdf5nkQEiRXizBWuNBH2O25zAj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NGER7u1HTaK+nMpFco01T8K0KiqhAHYD9LSdMtaD7kyRggEZknsV50aQd6MdFC6YZ
         Ec2G8/aMvg7lJrepFG8H4LbHZsmMlngwimJDCneBx8Z/JZ04VEuFQ39P62wW8SVKeO
         a9qIVoM7jggLn7DUnvSX2fICpWYHv0bkKgwjYS6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Auchter <michael.auchter@ni.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 043/477] nvmem: ensure sysfs writes handle write-protect pin
Date:   Tue, 23 Jun 2020 21:50:40 +0200
Message-Id: <20200623195409.640278150@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Auchter <michael.auchter@ni.com>

[ Upstream commit b96fc5416b099a0c2509ca07a80b140d34db2b9b ]

Commit 2a127da461a9 ("nvmem: add support for the write-protect pin")
added support for handling write-protect pins to the nvmem core, and
Commit 1c89074bf850 ("eeprom: at24: remove the write-protect pin support")
retrofitted the at24 driver to use this support.

These changes broke write() on the nvmem sysfs attribute for eeproms
which utilize a write-protect pin, as the write callback invokes the
nvmem device's reg_write callback directly which no longer handles
changing the state of the write-protect pin.

Change the read and write callbacks for the sysfs attribute to invoke
nvmme_reg_read/nvmem_reg_write helpers which handle this, rather than
calling reg_read/reg_write directly.

Fixes: 2a127da461a9 ("nvmem: add support for the write-protect pin")
Signed-off-by: Michael Auchter <michael.auchter@ni.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20200511145042.31223-3-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/core.c | 52 ++++++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 05c6ae4b0b973..a8300202a7fbb 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -66,6 +66,30 @@ static LIST_HEAD(nvmem_lookup_list);
 
 static BLOCKING_NOTIFIER_HEAD(nvmem_notifier);
 
+static int nvmem_reg_read(struct nvmem_device *nvmem, unsigned int offset,
+			  void *val, size_t bytes)
+{
+	if (nvmem->reg_read)
+		return nvmem->reg_read(nvmem->priv, offset, val, bytes);
+
+	return -EINVAL;
+}
+
+static int nvmem_reg_write(struct nvmem_device *nvmem, unsigned int offset,
+			   void *val, size_t bytes)
+{
+	int ret;
+
+	if (nvmem->reg_write) {
+		gpiod_set_value_cansleep(nvmem->wp_gpio, 0);
+		ret = nvmem->reg_write(nvmem->priv, offset, val, bytes);
+		gpiod_set_value_cansleep(nvmem->wp_gpio, 1);
+		return ret;
+	}
+
+	return -EINVAL;
+}
+
 #ifdef CONFIG_NVMEM_SYSFS
 static const char * const nvmem_type_str[] = {
 	[NVMEM_TYPE_UNKNOWN] = "Unknown",
@@ -122,7 +146,7 @@ static ssize_t bin_attr_nvmem_read(struct file *filp, struct kobject *kobj,
 	if (!nvmem->reg_read)
 		return -EPERM;
 
-	rc = nvmem->reg_read(nvmem->priv, pos, buf, count);
+	rc = nvmem_reg_read(nvmem, pos, buf, count);
 
 	if (rc)
 		return rc;
@@ -159,7 +183,7 @@ static ssize_t bin_attr_nvmem_write(struct file *filp, struct kobject *kobj,
 	if (!nvmem->reg_write)
 		return -EPERM;
 
-	rc = nvmem->reg_write(nvmem->priv, pos, buf, count);
+	rc = nvmem_reg_write(nvmem, pos, buf, count);
 
 	if (rc)
 		return rc;
@@ -311,30 +335,6 @@ static void nvmem_sysfs_remove_compat(struct nvmem_device *nvmem,
 
 #endif /* CONFIG_NVMEM_SYSFS */
 
-static int nvmem_reg_read(struct nvmem_device *nvmem, unsigned int offset,
-			  void *val, size_t bytes)
-{
-	if (nvmem->reg_read)
-		return nvmem->reg_read(nvmem->priv, offset, val, bytes);
-
-	return -EINVAL;
-}
-
-static int nvmem_reg_write(struct nvmem_device *nvmem, unsigned int offset,
-			   void *val, size_t bytes)
-{
-	int ret;
-
-	if (nvmem->reg_write) {
-		gpiod_set_value_cansleep(nvmem->wp_gpio, 0);
-		ret = nvmem->reg_write(nvmem->priv, offset, val, bytes);
-		gpiod_set_value_cansleep(nvmem->wp_gpio, 1);
-		return ret;
-	}
-
-	return -EINVAL;
-}
-
 static void nvmem_release(struct device *dev)
 {
 	struct nvmem_device *nvmem = to_nvmem_device(dev);
-- 
2.25.1



