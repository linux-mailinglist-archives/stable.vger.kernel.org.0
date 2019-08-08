Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCC9886A2C
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404530AbfHHTOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:14:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405007AbfHHTI5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:08:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13881214C6;
        Thu,  8 Aug 2019 19:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291336;
        bh=rxiTNpmN3JfowyIDYyku5rB8rgfj5MmDvzXltVZD1vU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yy58jnSV+W267cOjRACNfs6Q2J+iAbIsacloXvVjac6zm96hi3Ed1Gc3BOws5jXS6
         CFz4g6v//s2J/7vkOXMCeRS35N/YGYA+x7bYjxLBG2l4EWk1lVHCcH0PpeLM2VtPvw
         jZnsFm+AnshGoUSCtYTsx/34/ZF1om8kqINm1h+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 07/45] libnvdimm/bus: Prepare the nd_ioctl() path to be re-entrant
Date:   Thu,  8 Aug 2019 21:04:53 +0200
Message-Id: <20190808190454.189996943@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.827571908@linuxfoundation.org>
References: <20190808190453.827571908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 6de5d06e657acdbcf9637dac37916a4a5309e0f4 upstream.

In preparation for not holding a lock over the execution of nd_ioctl(),
update the implementation to allow multiple threads to be attempting
ioctls at the same time. The bus lock still prevents multiple in-flight
->ndctl() invocations from corrupting each other's state, but static
global staging buffers are moved to the heap.

Reported-by: Vishal Verma <vishal.l.verma@intel.com>
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Tested-by: Vishal Verma <vishal.l.verma@intel.com>
Link: https://lore.kernel.org/r/156341208947.292348.10560140326807607481.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/bus.c | 59 +++++++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 22 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 11cfd23e5aff7..5abcdb4faa644 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -951,20 +951,19 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		int read_only, unsigned int ioctl_cmd, unsigned long arg)
 {
 	struct nvdimm_bus_descriptor *nd_desc = nvdimm_bus->nd_desc;
-	static char out_env[ND_CMD_MAX_ENVELOPE];
-	static char in_env[ND_CMD_MAX_ENVELOPE];
 	const struct nd_cmd_desc *desc = NULL;
 	unsigned int cmd = _IOC_NR(ioctl_cmd);
 	struct device *dev = &nvdimm_bus->dev;
 	void __user *p = (void __user *) arg;
+	char *out_env = NULL, *in_env = NULL;
 	const char *cmd_name, *dimm_name;
 	u32 in_len = 0, out_len = 0;
 	unsigned int func = cmd;
 	unsigned long cmd_mask;
 	struct nd_cmd_pkg pkg;
 	int rc, i, cmd_rc;
+	void *buf = NULL;
 	u64 buf_len = 0;
-	void *buf;
 
 	if (nvdimm) {
 		desc = nd_cmd_dimm_desc(cmd);
@@ -1004,6 +1003,9 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		}
 
 	/* process an input envelope */
+	in_env = kzalloc(ND_CMD_MAX_ENVELOPE, GFP_KERNEL);
+	if (!in_env)
+		return -ENOMEM;
 	for (i = 0; i < desc->in_num; i++) {
 		u32 in_size, copy;
 
@@ -1011,14 +1013,17 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		if (in_size == UINT_MAX) {
 			dev_err(dev, "%s:%s unknown input size cmd: %s field: %d\n",
 					__func__, dimm_name, cmd_name, i);
-			return -ENXIO;
+			rc = -ENXIO;
+			goto out;
 		}
-		if (in_len < sizeof(in_env))
-			copy = min_t(u32, sizeof(in_env) - in_len, in_size);
+		if (in_len < ND_CMD_MAX_ENVELOPE)
+			copy = min_t(u32, ND_CMD_MAX_ENVELOPE - in_len, in_size);
 		else
 			copy = 0;
-		if (copy && copy_from_user(&in_env[in_len], p + in_len, copy))
-			return -EFAULT;
+		if (copy && copy_from_user(&in_env[in_len], p + in_len, copy)) {
+			rc = -EFAULT;
+			goto out;
+		}
 		in_len += in_size;
 	}
 
@@ -1030,6 +1035,12 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 	}
 
 	/* process an output envelope */
+	out_env = kzalloc(ND_CMD_MAX_ENVELOPE, GFP_KERNEL);
+	if (!out_env) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
 	for (i = 0; i < desc->out_num; i++) {
 		u32 out_size = nd_cmd_out_size(nvdimm, cmd, desc, i,
 				(u32 *) in_env, (u32 *) out_env, 0);
@@ -1038,15 +1049,18 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		if (out_size == UINT_MAX) {
 			dev_dbg(dev, "%s unknown output size cmd: %s field: %d\n",
 					dimm_name, cmd_name, i);
-			return -EFAULT;
+			rc = -EFAULT;
+			goto out;
 		}
-		if (out_len < sizeof(out_env))
-			copy = min_t(u32, sizeof(out_env) - out_len, out_size);
+		if (out_len < ND_CMD_MAX_ENVELOPE)
+			copy = min_t(u32, ND_CMD_MAX_ENVELOPE - out_len, out_size);
 		else
 			copy = 0;
 		if (copy && copy_from_user(&out_env[out_len],
-					p + in_len + out_len, copy))
-			return -EFAULT;
+					p + in_len + out_len, copy)) {
+			rc = -EFAULT;
+			goto out;
+		}
 		out_len += out_size;
 	}
 
@@ -1054,12 +1068,15 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 	if (buf_len > ND_IOCTL_MAX_BUFLEN) {
 		dev_dbg(dev, "%s cmd: %s buf_len: %llu > %d\n", dimm_name,
 				cmd_name, buf_len, ND_IOCTL_MAX_BUFLEN);
-		return -EINVAL;
+		rc = -EINVAL;
+		goto out;
 	}
 
 	buf = vmalloc(buf_len);
-	if (!buf)
-		return -ENOMEM;
+	if (!buf) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	if (copy_from_user(buf, p, buf_len)) {
 		rc = -EFAULT;
@@ -1081,17 +1098,15 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		nvdimm_account_cleared_poison(nvdimm_bus, clear_err->address,
 				clear_err->cleared);
 	}
-	nvdimm_bus_unlock(&nvdimm_bus->dev);
 
 	if (copy_to_user(p, buf, buf_len))
 		rc = -EFAULT;
 
-	vfree(buf);
-	return rc;
-
- out_unlock:
+out_unlock:
 	nvdimm_bus_unlock(&nvdimm_bus->dev);
- out:
+out:
+	kfree(in_env);
+	kfree(out_env);
 	vfree(buf);
 	return rc;
 }
-- 
2.20.1



