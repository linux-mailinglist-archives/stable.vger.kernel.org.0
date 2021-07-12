Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3620B3C4B0F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239634AbhGLGz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:55:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233379AbhGLGxF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:53:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DDF361283;
        Mon, 12 Jul 2021 06:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072617;
        bh=YKAMSYzA1036o9x61Hxa0VrxHLMVvLdRs/KNHYKJQgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CslTnn1JDxCt3W9Dy3Di8Fyl0TwlCdrVV8gm7+VPkJZhOxOz9Yim0hBY5HNyeNLuv
         +pPkbE/rX+4UPl0zkZy258CJlMS9x1vrJ2oYjRzv3BPbAMp/tm2rlR2nC03IGklDyO
         fxJTS8BKC2iouOcPdMzPaxByVoBkRPeSIY/8YEwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vaibhav Jain <vaibhav@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 556/593] powerpc/papr_scm: Make perf_stats invisible if perf-stats unavailable
Date:   Mon, 12 Jul 2021 08:11:56 +0200
Message-Id: <20210712060955.652625073@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vaibhav Jain <vaibhav@linux.ibm.com>

[ Upstream commit ed78f56e1271f108e8af61baeba383dcd77adbec ]

In case performance stats for an nvdimm are not available, reading the
'perf_stats' sysfs file returns an -ENOENT error. A better approach is
to make the 'perf_stats' file entirely invisible to indicate that
performance stats for an nvdimm are unavailable.

So this patch updates 'papr_nd_attribute_group' to add a 'is_visible'
callback implemented as newly introduced 'papr_nd_attribute_visible()'
that returns an appropriate mode in case performance stats aren't
supported in a given nvdimm.

Also the initialization of 'papr_scm_priv.stat_buffer_len' is moved
from papr_scm_nvdimm_init() to papr_scm_probe() so that it value is
available when 'papr_nd_attribute_visible()' is called during nvdimm
initialization.

Even though 'perf_stats' attribute is available since v5.9, there are
no known user-space tools/scripts that are dependent on presence of its
sysfs file. Hence I dont expect any user-space breakage with this
patch.

Fixes: 2d02bf835e57 ("powerpc/papr_scm: Fetch nvdimm performance stats from PHYP")
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210513092349.285021-1-vaibhav@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-bus-papr-pmem |  8 +++--
 arch/powerpc/platforms/pseries/papr_scm.c     | 35 +++++++++++++------
 2 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-papr-pmem b/Documentation/ABI/testing/sysfs-bus-papr-pmem
index 8316c33862a0..0aa02bf2bde5 100644
--- a/Documentation/ABI/testing/sysfs-bus-papr-pmem
+++ b/Documentation/ABI/testing/sysfs-bus-papr-pmem
@@ -39,9 +39,11 @@ KernelVersion:	v5.9
 Contact:	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-nvdimm@lists.01.org,
 Description:
 		(RO) Report various performance stats related to papr-scm NVDIMM
-		device.  Each stat is reported on a new line with each line
-		composed of a stat-identifier followed by it value. Below are
-		currently known dimm performance stats which are reported:
+		device. This attribute is only available for NVDIMM devices
+		that support reporting NVDIMM performance stats. Each stat is
+		reported on a new line with each line composed of a
+		stat-identifier followed by it value. Below are currently known
+		dimm performance stats which are reported:
 
 		* "CtlResCt" : Controller Reset Count
 		* "CtlResTm" : Controller Reset Elapsed Time
diff --git a/arch/powerpc/platforms/pseries/papr_scm.c b/arch/powerpc/platforms/pseries/papr_scm.c
index 0693bc8d70ac..057acbb9116d 100644
--- a/arch/powerpc/platforms/pseries/papr_scm.c
+++ b/arch/powerpc/platforms/pseries/papr_scm.c
@@ -868,6 +868,20 @@ static ssize_t flags_show(struct device *dev,
 }
 DEVICE_ATTR_RO(flags);
 
+static umode_t papr_nd_attribute_visible(struct kobject *kobj,
+					 struct attribute *attr, int n)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct papr_scm_priv *p = nvdimm_provider_data(nvdimm);
+
+	/* For if perf-stats not available remove perf_stats sysfs */
+	if (attr == &dev_attr_perf_stats.attr && p->stat_buffer_len == 0)
+		return 0;
+
+	return attr->mode;
+}
+
 /* papr_scm specific dimm attributes */
 static struct attribute *papr_nd_attributes[] = {
 	&dev_attr_flags.attr,
@@ -877,6 +891,7 @@ static struct attribute *papr_nd_attributes[] = {
 
 static struct attribute_group papr_nd_attribute_group = {
 	.name = "papr",
+	.is_visible = papr_nd_attribute_visible,
 	.attrs = papr_nd_attributes,
 };
 
@@ -892,7 +907,6 @@ static int papr_scm_nvdimm_init(struct papr_scm_priv *p)
 	struct nd_region_desc ndr_desc;
 	unsigned long dimm_flags;
 	int target_nid, online_nid;
-	ssize_t stat_size;
 
 	p->bus_desc.ndctl = papr_scm_ndctl;
 	p->bus_desc.module = THIS_MODULE;
@@ -963,16 +977,6 @@ static int papr_scm_nvdimm_init(struct papr_scm_priv *p)
 	list_add_tail(&p->region_list, &papr_nd_regions);
 	mutex_unlock(&papr_ndr_lock);
 
-	/* Try retriving the stat buffer and see if its supported */
-	stat_size = drc_pmem_query_stats(p, NULL, 0);
-	if (stat_size > 0) {
-		p->stat_buffer_len = stat_size;
-		dev_dbg(&p->pdev->dev, "Max perf-stat size %lu-bytes\n",
-			p->stat_buffer_len);
-	} else {
-		dev_info(&p->pdev->dev, "Dimm performance stats unavailable\n");
-	}
-
 	return 0;
 
 err:	nvdimm_bus_unregister(p->bus);
@@ -1050,6 +1054,7 @@ static int papr_scm_probe(struct platform_device *pdev)
 	struct papr_scm_priv *p;
 	u8 uuid_raw[UUID_SIZE];
 	const char *uuid_str;
+	ssize_t stat_size;
 	uuid_t uuid;
 	int rc;
 
@@ -1133,6 +1138,14 @@ static int papr_scm_probe(struct platform_device *pdev)
 	p->res.name  = pdev->name;
 	p->res.flags = IORESOURCE_MEM;
 
+	/* Try retrieving the stat buffer and see if its supported */
+	stat_size = drc_pmem_query_stats(p, NULL, 0);
+	if (stat_size > 0) {
+		p->stat_buffer_len = stat_size;
+		dev_dbg(&p->pdev->dev, "Max perf-stat size %lu-bytes\n",
+			p->stat_buffer_len);
+	}
+
 	rc = papr_scm_nvdimm_init(p);
 	if (rc)
 		goto err2;
-- 
2.30.2



