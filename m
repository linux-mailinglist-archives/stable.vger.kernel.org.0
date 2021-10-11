Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A56429576
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 19:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbhJKRUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 13:20:07 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:41290 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233954AbhJKRUH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 13:20:07 -0400
Date:   Mon, 11 Oct 2021 17:18:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633972685;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=60pRUpMDA+d0VcX1H7ww0x5DaVSA92hmwjZ9mCQf1Mo=;
        b=HkO1FYSo7FfAakTh+UgUfO4Ukfx8G5uuFBLFP+Z+8ktbiDoeXjBjQPkRMd6ouI8QuUWAwM
        V18xUnDgULDC2uwomqhuoG1kAUtoFL5h/aQ1hv6lXAMDnC+ZzqMw1G944ACEiTsn3niT00
        3CygRme2bbm1OY3nbYelVi4Xjv3szKajOAEQuHpp+XM3uZxH1/D4uLQR496S0OUkmwKmhT
        FTfg+nVpDNIYgcbzpUHSVMgbu0jQMEiwAOR5g47RNTNetZorQ3HNYrlpsJtZU9FOwamb59
        N9Lryg6adMIfZxFi9yQs3IaLBCH29NX8iuf/ny/Dd07fir1fFn0zA6fRGnxn6g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633972685;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=60pRUpMDA+d0VcX1H7ww0x5DaVSA92hmwjZ9mCQf1Mo=;
        b=z7de5qiL2C5baehYTfx/6xFFJst0w1v35iNbiGWPOAZ1ee7PlhEUWTu9mGz8qRDcDjmkYA
        MzJf3NhV4tLXfTCg==
From:   "tip-bot2 for Borislav Petkov" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/Kconfig: Do not enable
 AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT automatically
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>, Borislav Petkov <bp@suse.de>,
        Alex Deucher <alexander.deucher@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        <stable@vger.kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <8bbacd0e-4580-3194-19d2-a0ecad7df09c@molgen.mpg.de>
References: <8bbacd0e-4580-3194-19d2-a0ecad7df09c@molgen.mpg.de>
MIME-Version: 1.0
Message-ID: <163397268455.25758.9385335529425752157.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     711885906b5c2df90746a51f4cd674f1ab9fbb1d
Gitweb:        https://git.kernel.org/tip/711885906b5c2df90746a51f4cd674f1ab9fbb1d
Author:        Borislav Petkov <bp@suse.de>
AuthorDate:    Wed, 06 Oct 2021 19:34:55 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Mon, 11 Oct 2021 19:14:22 +02:00

x86/Kconfig: Do not enable AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT automatically

This Kconfig option was added initially so that memory encryption is
enabled by default on machines which support it.

However, devices which have DMA masks that are less than the bit
position of the encryption bit, aka C-bit, require the use of an IOMMU
or the use of SWIOTLB.

If the IOMMU is disabled or in passthrough mode, the kernel would switch
to SWIOTLB bounce-buffering for those transfers.

In order to avoid that,

  2cc13bb4f59f ("iommu: Disable passthrough mode when SME is active")

disables the default IOMMU passthrough mode so that devices for which the
default 256K DMA is insufficient, can use the IOMMU instead.

However 2, there are cases where the IOMMU is disabled in the BIOS, etc.
(think the usual hardware folk "oops, I dropped the ball there" cases) or a
driver doesn't properly use the DMA APIs or a device has a firmware or
hardware bug, e.g.:

  ea68573d408f ("drm/amdgpu: Fail to load on RAVEN if SME is active")

However 3, in the above GPU use case, there are APIs like Vulkan and
some OpenGL/OpenCL extensions which are under the assumption that
user-allocated memory can be passed in to the kernel driver and both the
GPU and CPU can do coherent and concurrent access to the same memory.
That cannot work with SWIOTLB bounce buffers, of course.

So, in order for those devices to function, drop the "default y" for the
SME by default active option so that users who want to have SME enabled,
will need to either enable it in their config or use "mem_encrypt=on" on
the kernel command line.

 [ tlendacky: Generalize commit message. ]

Fixes: 7744ccdbc16f ("x86/mm: Add Secure Memory Encryption (SME) support")
Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/8bbacd0e-4580-3194-19d2-a0ecad7df09c@molgen.mpg.de
---
 arch/x86/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index bd70e8a..d9830e7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1525,7 +1525,6 @@ config AMD_MEM_ENCRYPT
 
 config AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT
 	bool "Activate AMD Secure Memory Encryption (SME) by default"
-	default y
 	depends on AMD_MEM_ENCRYPT
 	help
 	  Say yes to have system memory encrypted by default if running on
