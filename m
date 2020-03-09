Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E99917E1F4
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 15:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgCIOBv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 10:01:51 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:34889 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726666AbgCIOBv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 10:01:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583762510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gmrIgOpC5xCUrW/eGnewrWRJsVzMqiKXr2pMquelru0=;
        b=JA1ItilYzetbNw4oJsGdf4azifBbjZ5hrIZq7p5p8BZzKhy2AjrYDfrMusMC4NHrOr9Hge
        vxOe1AcbqXdti8TtPSogDc5opjfn0BXLYicsSOxbpbTmHk/93puiaeoQPvNfd3Pd5cjLIw
        naqErTXKThW/qZzLa2+R7gadWVR1XPY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-RMiKwbBMMEaQpN1NK9CkOA-1; Mon, 09 Mar 2020 10:01:46 -0400
X-MC-Unique: RMiKwbBMMEaQpN1NK9CkOA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ACE6C107ACC9;
        Mon,  9 Mar 2020 14:01:44 +0000 (UTC)
Received: from x1.localdomain.com (unknown [10.36.118.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C530A60C87;
        Mon,  9 Mar 2020 14:01:41 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        iommu@lists.linux-foundation.org, stable@vger.kernel.org
Subject: [PATCH 1/2] iommu/vt-d: dmar: replace WARN_TAINT with pr_warn + add_taint
Date:   Mon,  9 Mar 2020 15:01:37 +0100
Message-Id: <20200309140138.3753-2-hdegoede@redhat.com>
In-Reply-To: <20200309140138.3753-1-hdegoede@redhat.com>
References: <20200309140138.3753-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting from the comment describing the WARN functions in
include/asm-generic/bug.h:

 * WARN(), WARN_ON(), WARN_ON_ONCE, and so on can be used to report
 * significant kernel issues that need prompt attention if they should ev=
er
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

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=3D1564895
Fixes: e625b4a95d50 ("iommu/vt-d: Parse ANDD records")
Fixes: fd0c8894893c ("intel-iommu: Set a more specific taint flag for inv=
alid BI
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/iommu/dmar.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 071bb42bbbc5..87194a46cb0b 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -440,12 +440,13 @@ static int __init dmar_parse_one_andd(struct acpi_d=
mar_header *header,
=20
 	/* Check for NUL termination within the designated length */
 	if (strnlen(andd->device_name, header->length - 8) =3D=3D header->lengt=
h - 8) {
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
@@ -471,14 +472,14 @@ static int dmar_parse_one_rhsa(struct acpi_dmar_hea=
der *header, void *arg)
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
=20
 	return 0;
 }
@@ -827,14 +828,14 @@ int __init dmar_table_init(void)
=20
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
=20
 static int __ref
--=20
2.25.1

