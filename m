Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB27C1B0BBB
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgDTM6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:58:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726697AbgDTMnb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:43:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CF402075A;
        Mon, 20 Apr 2020 12:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386610;
        bh=jYo6b44XSM0muOLTX9c5vHpa/7SrsPs18J65+dSq6kM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lIfo8JWiMhE5twVntekhft2ryL10ceTA5qtLo9ZzoGmjcIM3InAuSwa/WgH/Rw1M5
         zmT8fw6rW7RnC/Jq95/c8KzGaVh8no8aVxmK9nPxi9eqVELxik17FAcRhgt4nIcwlU
         yx3RV/b/vJIYeOmNijKlm+5qNepDJ5005cZXdtDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.6 27/71] acpi/nfit: improve bounds checking for func
Date:   Mon, 20 Apr 2020 14:38:41 +0200
Message-Id: <20200420121513.982033898@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121508.491252919@linuxfoundation.org>
References: <20200420121508.491252919@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 01091c496f920e634ea84b689f480c39016752a8 upstream.

The 'func' variable can come from the user in the __nd_ioctl().  If it's
too high then the (1 << func) shift in acpi_nfit_clear_to_send() is
undefined.  In acpi_nfit_ctl() we pass 'func' to test_bit(func, &dsm_mask)
which could result in an out of bounds access.

To fix these issues, I introduced the NVDIMM_CMD_MAX (31) define and
updated nfit_dsm_revid() to use that define as well instead of magic
numbers.

Fixes: 11189c1089da ("acpi/nfit: Fix command-supported detection")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Link: https://lore.kernel.org/r/20200225161927.hvftuq7kjn547fyj@kili.mountain
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/nfit/core.c |   10 ++++++----
 drivers/acpi/nfit/nfit.h |    1 +
 2 files changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -360,7 +360,7 @@ static union acpi_object *acpi_label_inf
 
 static u8 nfit_dsm_revid(unsigned family, unsigned func)
 {
-	static const u8 revid_table[NVDIMM_FAMILY_MAX+1][32] = {
+	static const u8 revid_table[NVDIMM_FAMILY_MAX+1][NVDIMM_CMD_MAX+1] = {
 		[NVDIMM_FAMILY_INTEL] = {
 			[NVDIMM_INTEL_GET_MODES] = 2,
 			[NVDIMM_INTEL_GET_FWINFO] = 2,
@@ -386,7 +386,7 @@ static u8 nfit_dsm_revid(unsigned family
 
 	if (family > NVDIMM_FAMILY_MAX)
 		return 0;
-	if (func > 31)
+	if (func > NVDIMM_CMD_MAX)
 		return 0;
 	id = revid_table[family][func];
 	if (id == 0)
@@ -492,7 +492,8 @@ int acpi_nfit_ctl(struct nvdimm_bus_desc
 	 * Check for a valid command.  For ND_CMD_CALL, we also have to
 	 * make sure that the DSM function is supported.
 	 */
-	if (cmd == ND_CMD_CALL && !test_bit(func, &dsm_mask))
+	if (cmd == ND_CMD_CALL &&
+	    (func > NVDIMM_CMD_MAX || !test_bit(func, &dsm_mask)))
 		return -ENOTTY;
 	else if (!test_bit(cmd, &cmd_mask))
 		return -ENOTTY;
@@ -3492,7 +3493,8 @@ static int acpi_nfit_clear_to_send(struc
 	if (nvdimm && cmd == ND_CMD_CALL &&
 			call_pkg->nd_family == NVDIMM_FAMILY_INTEL) {
 		func = call_pkg->nd_command;
-		if ((1 << func) & NVDIMM_INTEL_SECURITY_CMDMASK)
+		if (func > NVDIMM_CMD_MAX ||
+		    (1 << func) & NVDIMM_INTEL_SECURITY_CMDMASK)
 			return -EOPNOTSUPP;
 	}
 
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -34,6 +34,7 @@
 		| ACPI_NFIT_MEM_NOT_ARMED | ACPI_NFIT_MEM_MAP_FAILED)
 
 #define NVDIMM_FAMILY_MAX NVDIMM_FAMILY_HYPERV
+#define NVDIMM_CMD_MAX 31
 
 #define NVDIMM_STANDARD_CMDMASK \
 (1 << ND_CMD_SMART | 1 << ND_CMD_SMART_THRESHOLD | 1 << ND_CMD_DIMM_FLAGS \


