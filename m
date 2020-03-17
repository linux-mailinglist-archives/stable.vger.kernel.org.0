Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73CFA188076
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbgCQLKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:10:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728732AbgCQLKX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:10:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1B2820719;
        Tue, 17 Mar 2020 11:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443423;
        bh=TqzSN8xFqfpfvI+NHKACxrAa2ySUTguUnqUqWhkLzcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m/vDBz0LgL2VgPKBY/SH3BdCmEu5XVBxPgyYg/fM7lPjkmCFmMpWOenN4mHiHc6Yw
         XY2rLGYpSMLtBpBVXDovIT4fP4kTf24q4WVN04lZXBDFivZR7ZxDuq0li6nJijif29
         FeaOrnE21JduyKtVvaGK4F+wh/ZycG6wxQrwln50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.5 078/151] iommu/vt-d: quirk_ioat_snb_local_iommu: replace WARN_TAINT with pr_warn + add_taint
Date:   Tue, 17 Mar 2020 11:54:48 +0100
Message-Id: <20200317103332.017905584@linuxfoundation.org>
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

commit 81ee85d0462410de8eeeec1b9761941fd6ed8c7b upstream.

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

Fixes: 556ab45f9a77 ("ioat2: catch and recover from broken vtd configurations v6")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20200309182510.373875-1-hdegoede@redhat.com
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=701847
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel-iommu.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4141,10 +4141,11 @@ static void quirk_ioat_snb_local_iommu(s
 
 	/* we know that the this iommu should be at offset 0xa000 from vtbar */
 	drhd = dmar_find_matched_drhd_unit(pdev);
-	if (WARN_TAINT_ONCE(!drhd || drhd->reg_base_addr - vtbar != 0xa000,
-			    TAINT_FIRMWARE_WORKAROUND,
-			    "BIOS assigned incorrect VT-d unit for Intel(R) QuickData Technology device\n"))
+	if (!drhd || drhd->reg_base_addr - vtbar != 0xa000) {
+		pr_warn_once(FW_BUG "BIOS assigned incorrect VT-d unit for Intel(R) QuickData Technology device\n");
+		add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_STILL_OK);
 		pdev->dev.archdata.iommu = DUMMY_DEVICE_DOMAIN_INFO;
+	}
 }
 DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_SNB, quirk_ioat_snb_local_iommu);
 


