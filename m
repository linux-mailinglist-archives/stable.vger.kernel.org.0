Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E790B1A47D9
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 17:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbgDJP1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Apr 2020 11:27:37 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38426 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbgDJP1h (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Apr 2020 11:27:37 -0400
Received: by mail-pf1-f196.google.com with SMTP id c21so1173939pfo.5
        for <stable@vger.kernel.org>; Fri, 10 Apr 2020 08:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=xwwwVLK0oILSngv688DLdSFHSXSem3phGmin4VS1Obk=;
        b=XmRRnoC7NwLJ6USHRfYZLDhk56jvG2goNYHCPxtGcCV4NqgEiiHTg63/F1+4w2joac
         Mm3RO32sWnq76+cFM0LPvgn6CUHeT8jasbRAF0mEt2I2z8rgTL+o2k1AEY0DgXSY93p/
         fxKQyx1ztLp10ZGyw9ZDStLEaT2MpfpUDC0f1LTqGnY75INlhn+0+c2RWESPH87Dnuw+
         Q0j0fyCut0QF1tGYVWCILXyFrIw8zyuuI+42YMBZmUG9rvGR580MN+IGnvmTDpBv5bJm
         oqzTIVjg1sXPYfgotxRRzOWAkg+NycxZleZcLzXZyhHnknY9t4TztNwolOs7pizLI+zv
         nwCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=xwwwVLK0oILSngv688DLdSFHSXSem3phGmin4VS1Obk=;
        b=cI4LCoR/8Yran4CiRJcGMDWmTrAovLa4K4ywvBPsea2w3q1y+LWUgj6dDe6dwvBe/q
         Ts7cIbYj/fYSAtCOV8ceSetId4W9EHLaX2JledDKNrh8X9VBiUg2EPtDw+3Gv2mDhh3M
         5iGvyNnWRoa99dqQwDxzEwCbDSdsdJXWpPWX88wGBY2fIRttmatF/73XbrymOrPvs1OH
         eH1qlojTxdAmaYZ0mEAedk1LxYbjplD+vmntf4grcY1eqOeve4Ou0Jw5d52Hv5zs+Xqi
         kz82WvPMRLx76VkSrJpmgNXbXCxjIqH889I9kN1pWj+Es6d24iVqJvWLnKvOk8/Vczpp
         TYcg==
X-Gm-Message-State: AGi0PuZ8KsLri7HQnuW0jIWKkxaGQhGUOEDWMBmGVvRC9GmND32l1i7y
        nZW5NUISvY8KtZaijqY+lbq+hl1o
X-Google-Smtp-Source: APiQypIJK2xSDOe6BSfMMo1bdYLevs23kPLHKs8RLa0FUPnKh8A5guZfQBZ+Xid/YJqnUSn7IHAG2A==
X-Received: by 2002:a62:b603:: with SMTP id j3mr5176168pff.208.1586532454662;
        Fri, 10 Apr 2020 08:27:34 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x123sm2013465pfd.39.2020.04.10.08.27.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 10 Apr 2020 08:27:34 -0700 (PDT)
From:   Guenter Roeck <linux@roeck-us.net>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v4.14.y] acpi/nfit: Fix bus command validation
Date:   Fri, 10 Apr 2020 08:27:31 -0700
Message-Id: <20200410152731.85430-1-linux@roeck-us.net>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit ebe9f6f19d80d8978d16078dff3d5bd93ad8d102 ]

Commit 11189c1089da "acpi/nfit: Fix command-supported detection" broke
ND_CMD_CALL for bus-level commands. The "func = cmd" assumption is only
valid for:

    ND_CMD_ARS_CAP
    ND_CMD_ARS_START
    ND_CMD_ARS_STATUS
    ND_CMD_CLEAR_ERROR

The function number otherwise needs to be pulled from the command
payload for:

    NFIT_CMD_TRANSLATE_SPA
    NFIT_CMD_ARS_INJECT_SET
    NFIT_CMD_ARS_INJECT_CLEAR
    NFIT_CMD_ARS_INJECT_GET

Update cmd_to_func() for the bus case and call it in the common path.

Fixes: 11189c1089da ("acpi/nfit: Fix command-supported detection")
Cc: <stable@vger.kernel.org>
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Reported-by: Grzegorz Burzynski <grzegorz.burzynski@intel.com>
Tested-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
[groeck: backport to v4.14.y: adjust for missing commit 4b27db7e26cdb]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
Commit 11189c1089da ("acpi/nfit: Fix command-supported detection")
has been applied to v4.14.y as commit 1c285c34a509, but not its fix.

This patch has already been applied to v4.19.y. v5.4.y and later are
not affected.

 drivers/acpi/nfit/core.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 05fb821c2558..68205002f561 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -214,7 +214,7 @@ static int cmd_to_func(struct nfit_mem *nfit_mem, unsigned int cmd,
 	if (call_pkg) {
 		int i;
 
-		if (nfit_mem->family != call_pkg->nd_family)
+		if (nfit_mem && nfit_mem->family != call_pkg->nd_family)
 			return -ENOTTY;
 
 		for (i = 0; i < ARRAY_SIZE(call_pkg->nd_reserved2); i++)
@@ -223,6 +223,10 @@ static int cmd_to_func(struct nfit_mem *nfit_mem, unsigned int cmd,
 		return call_pkg->nd_command;
 	}
 
+	/* In the !call_pkg case, bus commands == bus functions */
+	if (!nfit_mem)
+		return cmd;
+
 	/* Linux ND commands == NVDIMM_FAMILY_INTEL function numbers */
 	if (nfit_mem->family == NVDIMM_FAMILY_INTEL)
 		return cmd;
@@ -238,6 +242,7 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 		unsigned int cmd, void *buf, unsigned int buf_len, int *cmd_rc)
 {
 	struct acpi_nfit_desc *acpi_desc = to_acpi_nfit_desc(nd_desc);
+	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
 	union acpi_object in_obj, in_buf, *out_obj;
 	const struct nd_cmd_desc *desc = NULL;
 	struct device *dev = acpi_desc->dev;
@@ -252,18 +257,18 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 	if (cmd_rc)
 		*cmd_rc = -EINVAL;
 
+	if (cmd == ND_CMD_CALL)
+		call_pkg = buf;
+	func = cmd_to_func(nfit_mem, cmd, call_pkg);
+	if (func < 0)
+		return func;
+
 	if (nvdimm) {
-		struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
 		struct acpi_device *adev = nfit_mem->adev;
 
 		if (!adev)
 			return -ENOTTY;
 
-		if (cmd == ND_CMD_CALL)
-			call_pkg = buf;
-		func = cmd_to_func(nfit_mem, cmd, call_pkg);
-		if (func < 0)
-			return func;
 		dimm_name = nvdimm_name(nvdimm);
 		cmd_name = nvdimm_cmd_name(cmd);
 		cmd_mask = nvdimm_cmd_mask(nvdimm);
@@ -274,12 +279,9 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 	} else {
 		struct acpi_device *adev = to_acpi_dev(acpi_desc);
 
-		func = cmd;
 		cmd_name = nvdimm_bus_cmd_name(cmd);
 		cmd_mask = nd_desc->cmd_mask;
-		dsm_mask = cmd_mask;
-		if (cmd == ND_CMD_CALL)
-			dsm_mask = nd_desc->bus_dsm_mask;
+		dsm_mask = nd_desc->bus_dsm_mask;
 		desc = nd_cmd_bus_desc(cmd);
 		guid = to_nfit_uuid(NFIT_DEV_BUS);
 		handle = adev->handle;
-- 
2.17.1

