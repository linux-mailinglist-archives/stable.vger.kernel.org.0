Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98B7D2C1D8B
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 06:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgKXF1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 00:27:43 -0500
Received: from mga14.intel.com ([192.55.52.115]:48669 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbgKXF1n (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Nov 2020 00:27:43 -0500
IronPort-SDR: 4glW/VM9wevnqIbOO5fZaaF/yv5iqcERsxlZp88COaA9ko6qVbmH2PBSxalvN7w9aWhZKAmSm0
 WocJ4+mgLVHA==
X-IronPort-AV: E=McAfee;i="6000,8403,9814"; a="171111795"
X-IronPort-AV: E=Sophos;i="5.78,365,1599548400"; 
   d="scan'208";a="171111795"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2020 21:27:43 -0800
IronPort-SDR: slVFfxUjVUc5hAVhYANK4q6P8xaOpwCaklMmE441hegdvLl6m4iEchBe6uUU5YnIo5WSePVbu7
 MrTpzDEzBqGg==
X-IronPort-AV: E=Sophos;i="5.78,365,1599548400"; 
   d="scan'208";a="332439281"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2020 21:27:42 -0800
Subject: [PATCH] ACPI: NFIT: Fix input validation of bus-family
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-nvdimm@lists.01.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Date:   Mon, 23 Nov 2020 21:27:42 -0800
Message-ID: <160619566216.201177.9354229595539334957.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dan reports that smatch thinks userspace can craft an out-of-bound bus
family number. However, nd_cmd_clear_to_send() blocks all non-zero
values of bus-family since only the kernel can initiate these commands.
However, in the speculation path, family is a user controlled array
index value so mask it for speculation safety. Also, since the
nd_cmd_clear_to_send() safety is non-obvious and possibly may change in
the future include input validation is if userspace could get past the
nd_cmd_clear_to_send() gatekeeper.

Link: http://lore.kernel.org/r/20201111113000.GA1237157@mwanda
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 6450ddbd5d8e ("ACPI: NFIT: Define runtime firmware activation commands")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index cda7b6c52504..b11b08a60684 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -5,6 +5,7 @@
 #include <linux/list_sort.h>
 #include <linux/libnvdimm.h>
 #include <linux/module.h>
+#include <linux/nospec.h>
 #include <linux/mutex.h>
 #include <linux/ndctl.h>
 #include <linux/sysfs.h>
@@ -479,8 +480,11 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 		cmd_mask = nd_desc->cmd_mask;
 		if (cmd == ND_CMD_CALL && call_pkg->nd_family) {
 			family = call_pkg->nd_family;
-			if (!test_bit(family, &nd_desc->bus_family_mask))
+			if (family > NVDIMM_BUS_FAMILY_MAX ||
+			    !test_bit(family, &nd_desc->bus_family_mask))
 				return -EINVAL;
+			family = array_index_nospec(family,
+						    NVDIMM_BUS_FAMILY_MAX + 1);
 			dsm_mask = acpi_desc->family_dsm_mask[family];
 			guid = to_nfit_bus_uuid(family);
 		} else {

