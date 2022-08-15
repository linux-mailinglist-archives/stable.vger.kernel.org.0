Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A794593A6B
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243148AbiHOTgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244181AbiHOTef (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:34:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416CEE60;
        Mon, 15 Aug 2022 11:45:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5C6C611C1;
        Mon, 15 Aug 2022 18:45:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD959C433D6;
        Mon, 15 Aug 2022 18:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589120;
        bh=66U9M5aFiEG9ZonRvU6aDKIvHi2Duefgh838xmhafKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G3R4RAA72bzrXVIFsB6TJKrqlWBozTgTTS/sHyrk0NZAM7U+b0MW4vGVOWr5vrryx
         3zsCaLFXrDvvBCzP8LjVqKG5cknq15qt0w2GV8w2syq+yrSh8FW3r2w4MbLF9RX3Xt
         wMT3aOCKTjIBSCbowok0O+Q7mr41E3f/qXdp9tWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 619/779] s390/dump: fix old lowcore virtual vs physical address confusion
Date:   Mon, 15 Aug 2022 20:04:23 +0200
Message-Id: <20220815180403.828592726@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit dc306186a130c6d9feb0aabc1c71b8ed1674a3bf ]

Virtual addresses of vmcore_info and os_info members are
wrongly passed to copy_oldmem_kernel(), while the function
expects physical address of the source. Instead, __pa()
macro should have been applied.

Yet, use of __pa() macro could be somehow confusing, since
copy_oldmem_kernel() may treat the source as an offset, not
as a direct physical address (that depens from the oldmem
availability and location).

Fix the virtual vs physical address confusion and make the
way the old lowcore is read consistent across all sources.

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/asm-offsets.c | 2 ++
 arch/s390/kernel/crash_dump.c  | 2 +-
 arch/s390/kernel/os_info.c     | 3 ++-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/asm-offsets.c b/arch/s390/kernel/asm-offsets.c
index b57da9338588..9242d7ad71e7 100644
--- a/arch/s390/kernel/asm-offsets.c
+++ b/arch/s390/kernel/asm-offsets.c
@@ -128,6 +128,8 @@ int main(void)
 	OFFSET(__LC_BR_R1, lowcore, br_r1_trampoline);
 	/* software defined ABI-relevant lowcore locations 0xe00 - 0xe20 */
 	OFFSET(__LC_DUMP_REIPL, lowcore, ipib);
+	OFFSET(__LC_VMCORE_INFO, lowcore, vmcore_info);
+	OFFSET(__LC_OS_INFO, lowcore, os_info);
 	/* hardware defined lowcore locations 0x1000 - 0x18ff */
 	OFFSET(__LC_MCESAD, lowcore, mcesad);
 	OFFSET(__LC_EXT_PARAMS2, lowcore, ext_params2);
diff --git a/arch/s390/kernel/crash_dump.c b/arch/s390/kernel/crash_dump.c
index 785d54c9350c..9c2597be28dc 100644
--- a/arch/s390/kernel/crash_dump.c
+++ b/arch/s390/kernel/crash_dump.c
@@ -432,7 +432,7 @@ static void *get_vmcoreinfo_old(unsigned long *size)
 	Elf64_Nhdr note;
 	void *addr;
 
-	if (copy_oldmem_kernel(&addr, &S390_lowcore.vmcore_info, sizeof(addr)))
+	if (copy_oldmem_kernel(&addr, (void *)__LC_VMCORE_INFO, sizeof(addr)))
 		return NULL;
 	memset(nt_name, 0, sizeof(nt_name));
 	if (copy_oldmem_kernel(&note, addr, sizeof(note)))
diff --git a/arch/s390/kernel/os_info.c b/arch/s390/kernel/os_info.c
index 4bef35b79b93..198f9694e439 100644
--- a/arch/s390/kernel/os_info.c
+++ b/arch/s390/kernel/os_info.c
@@ -15,6 +15,7 @@
 #include <asm/checksum.h>
 #include <asm/lowcore.h>
 #include <asm/os_info.h>
+#include <asm/asm-offsets.h>
 
 /*
  * OS info structure has to be page aligned
@@ -123,7 +124,7 @@ static void os_info_old_init(void)
 		return;
 	if (!oldmem_data.start)
 		goto fail;
-	if (copy_oldmem_kernel(&addr, &S390_lowcore.os_info, sizeof(addr)))
+	if (copy_oldmem_kernel(&addr, (void *)__LC_OS_INFO, sizeof(addr)))
 		goto fail;
 	if (addr == 0 || addr % PAGE_SIZE)
 		goto fail;
-- 
2.35.1



