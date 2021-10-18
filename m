Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9DBB431BAF
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbhJRNeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:34:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232217AbhJRNcY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:32:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FA1C61373;
        Mon, 18 Oct 2021 13:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563756;
        bh=D8C0AOKW1fnp0DZkjSIFA6LZL+p9AeMn9ho1k5778jI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pRyEKlDy3gVFtC0vMzVCOwCB0nUeJq/aHTmQj+uyqxQo+60fmjkgtt2HzeD7CvHrP
         3izS904yJflRu+Ykujik7mVTGaS1+ql2+jh3u4Ffk126oE/UIQYh4IpBjAPYiM1EGk
         atGliZ5v8s/CyTgMKW5DLlUvButrzyAhrtvXvGmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
        Borislav Petkov <bp@suse.de>,
        Alex Deucher <alexander.deucher@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 4.19 26/50] x86/Kconfig: Do not enable AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT automatically
Date:   Mon, 18 Oct 2021 15:24:33 +0200
Message-Id: <20211018132327.405038283@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132326.529486647@linuxfoundation.org>
References: <20211018132326.529486647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

commit 711885906b5c2df90746a51f4cd674f1ab9fbb1d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1496,7 +1496,6 @@ config AMD_MEM_ENCRYPT
 
 config AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT
 	bool "Activate AMD Secure Memory Encryption (SME) by default"
-	default y
 	depends on AMD_MEM_ENCRYPT
 	---help---
 	  Say yes to have system memory encrypted by default if running on


