Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9C5359B0C
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233964AbhDIKHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:07:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234117AbhDIKEo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 06:04:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 344E061289;
        Fri,  9 Apr 2021 10:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962467;
        bh=QJXJaZp1t8B7Gn2SWJTKo5a1MX75+jxDlJbZeUzMPR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PUqb9wlz4Uk5L2833h7eMHZW8ExRnD8/sVoQPgqjxhJ1nOFRUB3JScABGp5kGeb+R
         tga70KyTIFIGNyeRlIfmOujdbK4NGyDZl08LApE/apyY0vRpJ37h96gwXXE+TLWzsh
         5k+MU0ZsTwsGgjcl0IDXTtmVx5jxzZGrS888hLso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "David E. Box" <david.e.box@linux.intel.com>,
        Sasha Neftin <sasha.neftin@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 26/45] platform/x86: intel_pmc_core: Ignore GBE LTR on Tiger Lake platforms
Date:   Fri,  9 Apr 2021 11:53:52 +0200
Message-Id: <20210409095306.262914731@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095305.397149021@linuxfoundation.org>
References: <20210409095305.397149021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David E. Box <david.e.box@linux.intel.com>

[ Upstream commit d1635448f1105e549b4041aab930dbc6945fc635 ]

Due to a HW limitation, the Latency Tolerance Reporting (LTR) value
programmed in the Tiger Lake GBE controller is not large enough to allow
the platform to enter Package C10, which in turn prevents the platform from
achieving its low power target during suspend-to-idle.  Ignore the GBE LTR
value on Tiger Lake. LTR ignore functionality is currently performed solely
by a debugfs write call. Split out the LTR code into its own function that
can be called by both the debugfs writer and by this work around.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Reviewed-by: Sasha Neftin <sasha.neftin@intel.com>
Cc: intel-wired-lan@lists.osuosl.org
Reviewed-by: Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>
Link: https://lore.kernel.org/r/20210319201844.3305399-2-david.e.box@linux.intel.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_pmc_core.c | 50 +++++++++++++++++++--------
 1 file changed, 35 insertions(+), 15 deletions(-)

diff --git a/drivers/platform/x86/intel_pmc_core.c b/drivers/platform/x86/intel_pmc_core.c
index ee2f757515b0..b5888aeb4bcf 100644
--- a/drivers/platform/x86/intel_pmc_core.c
+++ b/drivers/platform/x86/intel_pmc_core.c
@@ -863,34 +863,45 @@ static int pmc_core_pll_show(struct seq_file *s, void *unused)
 }
 DEFINE_SHOW_ATTRIBUTE(pmc_core_pll);
 
-static ssize_t pmc_core_ltr_ignore_write(struct file *file,
-					 const char __user *userbuf,
-					 size_t count, loff_t *ppos)
+static int pmc_core_send_ltr_ignore(u32 value)
 {
 	struct pmc_dev *pmcdev = &pmc;
 	const struct pmc_reg_map *map = pmcdev->map;
-	u32 val, buf_size, fd;
-	int err;
-
-	buf_size = count < 64 ? count : 64;
-
-	err = kstrtou32_from_user(userbuf, buf_size, 10, &val);
-	if (err)
-		return err;
+	u32 reg;
+	int err = 0;
 
 	mutex_lock(&pmcdev->lock);
 
-	if (val > map->ltr_ignore_max) {
+	if (value > map->ltr_ignore_max) {
 		err = -EINVAL;
 		goto out_unlock;
 	}
 
-	fd = pmc_core_reg_read(pmcdev, map->ltr_ignore_offset);
-	fd |= (1U << val);
-	pmc_core_reg_write(pmcdev, map->ltr_ignore_offset, fd);
+	reg = pmc_core_reg_read(pmcdev, map->ltr_ignore_offset);
+	reg |= BIT(value);
+	pmc_core_reg_write(pmcdev, map->ltr_ignore_offset, reg);
 
 out_unlock:
 	mutex_unlock(&pmcdev->lock);
+
+	return err;
+}
+
+static ssize_t pmc_core_ltr_ignore_write(struct file *file,
+					 const char __user *userbuf,
+					 size_t count, loff_t *ppos)
+{
+	u32 buf_size, value;
+	int err;
+
+	buf_size = min_t(u32, count, 64);
+
+	err = kstrtou32_from_user(userbuf, buf_size, 10, &value);
+	if (err)
+		return err;
+
+	err = pmc_core_send_ltr_ignore(value);
+
 	return err == 0 ? count : err;
 }
 
@@ -1244,6 +1255,15 @@ static int pmc_core_probe(struct platform_device *pdev)
 	pmcdev->pmc_xram_read_bit = pmc_core_check_read_lock_bit();
 	dmi_check_system(pmc_core_dmi_table);
 
+	/*
+	 * On TGL, due to a hardware limitation, the GBE LTR blocks PC10 when
+	 * a cable is attached. Tell the PMC to ignore it.
+	 */
+	if (pmcdev->map == &tgl_reg_map) {
+		dev_dbg(&pdev->dev, "ignoring GBE LTR\n");
+		pmc_core_send_ltr_ignore(3);
+	}
+
 	pmc_core_dbgfs_register(pmcdev);
 
 	device_initialized = true;
-- 
2.30.2



