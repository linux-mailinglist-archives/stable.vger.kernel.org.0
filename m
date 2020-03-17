Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31848188108
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbgCQLMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:12:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729433AbgCQLMf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:12:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A366A205ED;
        Tue, 17 Mar 2020 11:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443555;
        bh=TIFv1eJhMB46bxCCEH8/py43ZzDYOz+st9aB/rJARgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RQO/Fhnd9keKuRA0rLQHnnNfTaheLrpcwwZCpIDQaNC8rRibqJcl1mf+pSFQyw2zI
         kWclQI5cy1DpQuEzf9EhWcj2zM+RwpyzOw7IOM2wK5e9PI8x3zsivlhYFHcwBYLt22
         Unnp3YxQrMPyjhOsHggTnXgnepu4wL7Eh6+/M/vs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Joerg Roedel <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Barret Rhoden <brho@google.com>
Subject: [PATCH 5.5 121/151] iommu/vt-d: dmar_parse_one_rmrr: replace WARN_TAINT with pr_warn + add_taint
Date:   Tue, 17 Mar 2020 11:55:31 +0100
Message-Id: <20200317103335.060135771@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 96788c7a7f1e7206519d4d736f89a2072dcfe0fc upstream.

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
this when these are encountered. The WARN_TAINT in dmar_parse_one_rmrr
+ another iommu WARN_TAINT, addressed in another patch, have lead to over
a 100 bugs being filed this way.

This commit replaces the WARN_TAINT("...") call, with a
pr_warn(FW_BUG "...") + add_taint(TAINT_FIRMWARE_WORKAROUND, ...) call
avoiding the backtrace and thus also avoiding bug-reports being filed
about this against the kernel.

Fixes: f5a68bb0752e ("iommu/vt-d: Mark firmware tainted if RMRR fails sanity check")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Cc: stable@vger.kernel.org
Cc: Barret Rhoden <brho@google.com>
Link: https://lore.kernel.org/r/20200309140138.3753-3-hdegoede@redhat.com
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1808874
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel-iommu.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4330,14 +4330,16 @@ int __init dmar_parse_one_rmrr(struct ac
 	struct dmar_rmrr_unit *rmrru;
 
 	rmrr = (struct acpi_dmar_reserved_memory *)header;
-	if (arch_rmrr_sanity_check(rmrr))
-		WARN_TAINT(1, TAINT_FIRMWARE_WORKAROUND,
+	if (arch_rmrr_sanity_check(rmrr)) {
+		pr_warn(FW_BUG
 			   "Your BIOS is broken; bad RMRR [%#018Lx-%#018Lx]\n"
 			   "BIOS vendor: %s; Ver: %s; Product Version: %s\n",
 			   rmrr->base_address, rmrr->end_address,
 			   dmi_get_system_info(DMI_BIOS_VENDOR),
 			   dmi_get_system_info(DMI_BIOS_VERSION),
 			   dmi_get_system_info(DMI_PRODUCT_VERSION));
+		add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_STILL_OK);
+	}
 
 	rmrru = kzalloc(sizeof(*rmrru), GFP_KERNEL);
 	if (!rmrru)


