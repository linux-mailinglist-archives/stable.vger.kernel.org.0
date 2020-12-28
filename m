Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 845B12E3E25
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503119AbgL1OYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:24:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:60706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503114AbgL1OYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:24:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FFA0229C5;
        Mon, 28 Dec 2020 14:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165438;
        bh=3EEhOlEurmIC09uDV5qvb5mP6poKmMSiplCtiTjKOdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ga+xZGWjuAOPxtxGaTaPXm46X15wI+iNGIgmAwi5WMqb/Mc9atyviwCLQT1adsykm
         +m7q6kSvv5JtodJtfPnSnvLbzJIXtOlpJ+0hCQwE0wFzadQm2MohKzePSCBv2bvYNh
         12q9s4w6igIstYjnh/f13KXIPkjXyQfjkW1cnhHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.10 531/717] ACPI: NFIT: Fix input validation of bus-family
Date:   Mon, 28 Dec 2020 13:48:49 +0100
Message-Id: <20201228125046.408298346@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

commit 9a7e3d7f056831a6193d6d737fb7a26dfdceb04b upstream.

Dan reports that smatch thinks userspace can craft an out-of-bound bus
family number. However, nd_cmd_clear_to_send() blocks all non-zero
values of bus-family since only the kernel can initiate these commands.
However, in the speculation path, family is a user controlled array
index value so mask it for speculation safety. Also, since the
nd_cmd_clear_to_send() safety is non-obvious and possibly may change in
the future include input validation as if userspace could get past the
nd_cmd_clear_to_send() gatekeeper.

Link: http://lore.kernel.org/r/20201111113000.GA1237157@mwanda
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 6450ddbd5d8e ("ACPI: NFIT: Define runtime firmware activation commands")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/nfit/core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

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
@@ -478,8 +479,11 @@ int acpi_nfit_ctl(struct nvdimm_bus_desc
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


