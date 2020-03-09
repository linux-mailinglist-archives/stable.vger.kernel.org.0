Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 747BD17E1F6
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 15:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbgCIOBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 10:01:52 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56196 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726998AbgCIOBv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 10:01:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583762510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dwNeQ2bGQI9YeQt7X0VtkLkJtoPfZRFbqYALX2APQi4=;
        b=J0zZHAnr2MVy8YLcGZEVRmPLS/oqMyVTFFYPTfXnVsREe2UntKZoTm2xIIMUKhy2RAX7xV
        4WzQytjO4Naq4PIW80g9Zz/U6zJRJt5XTmvUq0AjAdglUhLww5v3+SxrUCMOG/omLqX0ov
        5Top3XTOXHILj1O2b69mmHD3KNTmzfg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-uUEhLOoRPJSOV2WNfFkmqA-1; Mon, 09 Mar 2020 10:01:49 -0400
X-MC-Unique: uUEhLOoRPJSOV2WNfFkmqA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6AF5CF98C;
        Mon,  9 Mar 2020 14:01:47 +0000 (UTC)
Received: from x1.localdomain.com (unknown [10.36.118.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EEFA960C05;
        Mon,  9 Mar 2020 14:01:44 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        iommu@lists.linux-foundation.org, Barret Rhoden <brho@google.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] iommu/vt-d: dmar_parse_one_rmrr: replace WARN_TAINT with pr_warn + add_taint
Date:   Mon,  9 Mar 2020 15:01:38 +0100
Message-Id: <20200309140138.3753-3-hdegoede@redhat.com>
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
this when these are encountered. The WARN_TAINT in dmar_parse_one_rmrr
+ another iommu WARN_TAINT, addressed in another patch, have lead to over
a 100 bugs being filed this way.

This commit replaces the WARN_TAINT("...") call, with a
pr_warn(FW_BUG "...") + add_taint(TAINT_FIRMWARE_WORKAROUND, ...) call
avoiding the backtrace and thus also avoiding bug-reports being filed
about this against the kernel.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=3D1808874
Fixes: f5a68bb0752e ("iommu/vt-d: Mark firmware tainted if RMRR fails san=
ity check")
Cc: Barret Rhoden <brho@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/iommu/intel-iommu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 6fa6de2b6ad5..3857a5cd1a75 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4460,14 +4460,16 @@ int __init dmar_parse_one_rmrr(struct acpi_dmar_h=
eader *header, void *arg)
 	struct dmar_rmrr_unit *rmrru;
=20
 	rmrr =3D (struct acpi_dmar_reserved_memory *)header;
-	if (rmrr_sanity_check(rmrr))
-		WARN_TAINT(1, TAINT_FIRMWARE_WORKAROUND,
+	if (rmrr_sanity_check(rmrr)) {
+		pr_warn(FW_BUG
 			   "Your BIOS is broken; bad RMRR [%#018Lx-%#018Lx]\n"
 			   "BIOS vendor: %s; Ver: %s; Product Version: %s\n",
 			   rmrr->base_address, rmrr->end_address,
 			   dmi_get_system_info(DMI_BIOS_VENDOR),
 			   dmi_get_system_info(DMI_BIOS_VERSION),
 			   dmi_get_system_info(DMI_PRODUCT_VERSION));
+		add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_STILL_OK);
+	}
=20
 	rmrru =3D kzalloc(sizeof(*rmrru), GFP_KERNEL);
 	if (!rmrru)
--=20
2.25.1

