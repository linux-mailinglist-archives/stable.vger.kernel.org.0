Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8181DD06A
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 16:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729520AbgEUOoq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 10:44:46 -0400
Received: from foss.arm.com ([217.140.110.172]:48292 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728229AbgEUOop (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 May 2020 10:44:45 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 42419D6E;
        Thu, 21 May 2020 07:44:43 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9562A3F305;
        Thu, 21 May 2020 07:44:42 -0700 (PDT)
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     <stable@vger.kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4.9] arm64: fix the flush_icache_range arguments in machine_kexec
Date:   Thu, 21 May 2020 15:44:34 +0100
Message-Id: <20200521144434.23750-1-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Commit d51c214541c5154dda3037289ee895ea3ded5ebd upstream.

The second argument is the end "pointer", not the length.

Fixes: d28f6df1305a ("arm64/kexec: Add core kexec support")
Cc: <stable@vger.kernel.org> # 4.8.x-
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/kernel/machine_kexec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/machine_kexec.c b/arch/arm64/kernel/machine_kexec.c
index bc96c8a7fc79..3e4b778f16a5 100644
--- a/arch/arm64/kernel/machine_kexec.c
+++ b/arch/arm64/kernel/machine_kexec.c
@@ -177,7 +177,8 @@ void machine_kexec(struct kimage *kimage)
 	/* Flush the reboot_code_buffer in preparation for its execution. */
 	__flush_dcache_area(reboot_code_buffer, arm64_relocate_new_kernel_size);
 	flush_icache_range((uintptr_t)reboot_code_buffer,
-		arm64_relocate_new_kernel_size);
+			   (uintptr_t)reboot_code_buffer +
+			   arm64_relocate_new_kernel_size);
 
 	/* Flush the kimage list and its buffers. */
 	kexec_list_flush(kimage);
