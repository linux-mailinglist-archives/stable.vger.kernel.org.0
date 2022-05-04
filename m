Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABB0F519975
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 10:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346138AbiEDIUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 04:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346106AbiEDITq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 04:19:46 -0400
Received: from theia.8bytes.org (8bytes.org [81.169.241.247])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E7022BF8
        for <stable@vger.kernel.org>; Wed,  4 May 2022 01:16:04 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 5B4573FA; Wed,  4 May 2022 10:16:02 +0200 (CEST)
Date:   Wed, 4 May 2022 10:16:01 +0200
From:   JoergRoedel <joro@8bytes.org>
To:     =?iso-8859-1?Q?J=F6rg-Volker?= Peetz <jvpeetz@web.de>
Cc:     SuraveeSuthikulpanit <suravee.suthikulpanit@amd.com>,
        vasant.hegde@amd.com, WillDeacon <will@kernel.org>,
        stable@vger.kernel.org
Subject: Re: Linux 5.17.5
Message-ID: <YnI2QYZ1GqmORC10@8bytes.org>
References: <165106510338255@kroah.com>
 <a5c7406e-64b0-7522-fef0-27fec1ac6698@web.de>
 <Ym+oOjFrkdju5H6X@8bytes.org>
 <4bfd2811-69ec-e4ec-2957-7054a075aa50@web.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nJNxpaLVPZDIqGdr"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4bfd2811-69ec-e4ec-2957-7054a075aa50@web.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--nJNxpaLVPZDIqGdr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Jörg,

On Tue, May 03, 2022 at 12:17:40AM +0200, Jörg-Volker Peetz wrote:
> May  2 21:50:27 xxx kernel: WARNING: CPU: 0 PID: 1 at
> drivers/iommu/amd/init.c:851 amd_iommu_enable_interrupts+0x312/0x3f0

Are you sure you tested the right kernel? My patch removes that warning,
so it can't trigger anymore. It also adds a new warning, but in
different file and line.

> In 'kern.log' I also found this:
> 
> May  2 21:53:27 xxx kernel: [drm:amdgpu_job_timedout [amdgpu]] *ERROR* ring gfx
> timeout, signaled seq=16, emitted seq=17

GPU errors, hard to say what triggered this. Can you please send me your
exact MB and CPU model? There is a chance this is firmware-related.

Besides that I learned that on some systems this warning only triggers
on resume. So increasing the timeout seems to be the only viable fix.
Can you please try the attached diff? It also prints the time it took to
enable the GA log.

Regards,

	Joerg

--nJNxpaLVPZDIqGdr
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="amd-iommu-warn-fix.diff"

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 7bfe37e52e21..12eb83d22019 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -22,6 +22,7 @@
 #include <linux/kmemleak.h>
 #include <linux/cc_platform.h>
 #include <linux/iopoll.h>
+#include <linux/ktime.h>
 #include <asm/pci-direct.h>
 #include <asm/iommu.h>
 #include <asm/apic.h>
@@ -84,7 +85,7 @@
 #define ACPI_DEVFLAG_LINT1              0x80
 #define ACPI_DEVFLAG_ATSDIS             0x10000000
 
-#define LOOP_TIMEOUT	100000
+#define LOOP_TIMEOUT	10000000
 /*
  * ACPI table definitions
  *
@@ -816,6 +817,7 @@ static void free_ga_log(struct amd_iommu *iommu)
 static int iommu_ga_log_enable(struct amd_iommu *iommu)
 {
 #ifdef CONFIG_IRQ_REMAP
+	ktime_t start, end;
 	u32 status, i;
 	u64 entry;
 
@@ -841,15 +843,20 @@ static int iommu_ga_log_enable(struct amd_iommu *iommu)
 	iommu_feature_enable(iommu, CONTROL_GAINT_EN);
 	iommu_feature_enable(iommu, CONTROL_GALOG_EN);
 
+	start = ktime_get();
 	for (i = 0; i < LOOP_TIMEOUT; ++i) {
 		status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
 		if (status & (MMIO_STATUS_GALOG_RUN_MASK))
 			break;
 		udelay(10);
 	}
+	end = ktime_get();
 
 	if (WARN_ON(i >= LOOP_TIMEOUT))
 		return -EINVAL;
+
+	pr_info("Enabling GA log took %lld ms\n", ktime_to_ms(ktime_sub(end, start)));
+
 #endif /* CONFIG_IRQ_REMAP */
 	return 0;
 }

--nJNxpaLVPZDIqGdr--
