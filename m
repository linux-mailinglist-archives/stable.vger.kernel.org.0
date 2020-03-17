Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 007681881B7
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbgCQLTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:19:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728326AbgCQLEz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:04:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E171A2071C;
        Tue, 17 Mar 2020 11:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443094;
        bh=VSkvZ2CSeMDWA3EVHHRCuGOMnRRxMVLwPUGFuYsELMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tvh60/hbQbbaq1C8bHIcC30JFVPdAs7DzPDVufOGawBRkGfvWxAnjEVRNUnDGYloC
         iBOmtuGT3BT56aBf0j4E/kQ+QUW2Ag/4yoQPjQ09Hb3vLn/oHwhSYbn8GwGUhClbD2
         eokLDTDsOO5QTwGh5vCE3vshYj78qWeFeo0GoX+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Joerg Roedel <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH 5.4 094/123] iommu/vt-d: dmar: replace WARN_TAINT with pr_warn + add_taint
Date:   Tue, 17 Mar 2020 11:55:21 +0100
Message-Id: <20200317103317.419424556@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 59833696442c674acbbd297772ba89e7ad8c753d upstream.

Quoting from the comment describing the WARN functions in
include/asm-generic/bug.h:

 * WARN(), WARN_ON(), WARN_ON_ONCE, and so on can be used to report
 * significant kernel issues that need prompt attention if they should ever
 * appear at runtime.
 *
 * Do not use these macros when checking for invalid external inputs

The (buggy) firmware tables which the dmar code was calling WARN_TAINT
for really are invalid external inputs. They are not under the kernel's
control and the issues in them cannot be fixed by a kernel update.
So logging a backtrace, which invites bug reports to be filed about this,
is not helpful.

Some distros, e.g. Fedora, have tools watching for the kernel backtraces
logged by the WARN macros and offer the user an option to file a bug for
this when these are encountered. The WARN_TAINT in warn_invalid_dmar()
+ another iommu WARN_TAINT, addressed in another patch, have lead to over
a 100 bugs being filed this way.

This commit replaces the WARN_TAINT("...") calls, with
pr_warn(FW_BUG "...") + add_taint(TAINT_FIRMWARE_WORKAROUND, ...) calls
avoiding the backtrace and thus also avoiding bug-reports being filed
about this against the kernel.

Fixes: fd0c8894893c ("intel-iommu: Set a more specific taint flag for invalid BIOS DMAR tables")
Fixes: e625b4a95d50 ("iommu/vt-d: Parse ANDD records")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200309140138.3753-2-hdegoede@redhat.com
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1564895
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/dmar.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -440,12 +440,13 @@ static int __init dmar_parse_one_andd(st
 
 	/* Check for NUL termination within the designated length */
 	if (strnlen(andd->device_name, header->length - 8) == header->length - 8) {
-		WARN_TAINT(1, TAINT_FIRMWARE_WORKAROUND,
+		pr_warn(FW_BUG
 			   "Your BIOS is broken; ANDD object name is not NUL-terminated\n"
 			   "BIOS vendor: %s; Ver: %s; Product Version: %s\n",
 			   dmi_get_system_info(DMI_BIOS_VENDOR),
 			   dmi_get_system_info(DMI_BIOS_VERSION),
 			   dmi_get_system_info(DMI_PRODUCT_VERSION));
+		add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_STILL_OK);
 		return -EINVAL;
 	}
 	pr_info("ANDD device: %x name: %s\n", andd->device_number,
@@ -471,14 +472,14 @@ static int dmar_parse_one_rhsa(struct ac
 			return 0;
 		}
 	}
-	WARN_TAINT(
-		1, TAINT_FIRMWARE_WORKAROUND,
+	pr_warn(FW_BUG
 		"Your BIOS is broken; RHSA refers to non-existent DMAR unit at %llx\n"
 		"BIOS vendor: %s; Ver: %s; Product Version: %s\n",
 		drhd->reg_base_addr,
 		dmi_get_system_info(DMI_BIOS_VENDOR),
 		dmi_get_system_info(DMI_BIOS_VERSION),
 		dmi_get_system_info(DMI_PRODUCT_VERSION));
+	add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_STILL_OK);
 
 	return 0;
 }
@@ -827,14 +828,14 @@ int __init dmar_table_init(void)
 
 static void warn_invalid_dmar(u64 addr, const char *message)
 {
-	WARN_TAINT_ONCE(
-		1, TAINT_FIRMWARE_WORKAROUND,
+	pr_warn_once(FW_BUG
 		"Your BIOS is broken; DMAR reported at address %llx%s!\n"
 		"BIOS vendor: %s; Ver: %s; Product Version: %s\n",
 		addr, message,
 		dmi_get_system_info(DMI_BIOS_VENDOR),
 		dmi_get_system_info(DMI_BIOS_VERSION),
 		dmi_get_system_info(DMI_PRODUCT_VERSION));
+	add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_STILL_OK);
 }
 
 static int __ref


