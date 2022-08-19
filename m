Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B28E559A48D
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353376AbiHSQmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353882AbiHSQlM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:41:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE81D1256DB;
        Fri, 19 Aug 2022 09:09:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D9E661838;
        Fri, 19 Aug 2022 16:08:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F45CC433D7;
        Fri, 19 Aug 2022 16:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925293;
        bh=zrrn6LAh6NYx6fLBmOiaBaMtl8pQ4I2f5vpr76aVJU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xJdMp2tLEumL1h05TGJd+6/hpBa2LPj0qaqDl1uZ3IWwjnP9tDASMauD4fuyeZUZO
         9Hh3vlROK0rRyU+xcCJurEd8X7D/uzFP1cvB+n9YY/CADh9vT5HKoypLlaSRyVw6Hk
         zORc1/7YMcLcUI76Wl7ALKs4+ggSXviTipy7W88s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 406/545] s390/dump: fix old lowcore virtual vs physical address confusion
Date:   Fri, 19 Aug 2022 17:42:56 +0200
Message-Id: <20220819153847.598763008@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
index 483051e10db3..e070073930a9 100644
--- a/arch/s390/kernel/asm-offsets.c
+++ b/arch/s390/kernel/asm-offsets.c
@@ -150,6 +150,8 @@ int main(void)
 	OFFSET(__LC_BR_R1, lowcore, br_r1_trampoline);
 	/* software defined ABI-relevant lowcore locations 0xe00 - 0xe20 */
 	OFFSET(__LC_DUMP_REIPL, lowcore, ipib);
+	OFFSET(__LC_VMCORE_INFO, lowcore, vmcore_info);
+	OFFSET(__LC_OS_INFO, lowcore, os_info);
 	/* hardware defined lowcore locations 0x1000 - 0x18ff */
 	OFFSET(__LC_MCESAD, lowcore, mcesad);
 	OFFSET(__LC_EXT_PARAMS2, lowcore, ext_params2);
diff --git a/arch/s390/kernel/crash_dump.c b/arch/s390/kernel/crash_dump.c
index 205b2e2648aa..76762dc67ca9 100644
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
index 0a5e4bafb6ad..1b8e2aff20e3 100644
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
 	if (!OLDMEM_BASE)
 		goto fail;
-	if (copy_oldmem_kernel(&addr, &S390_lowcore.os_info, sizeof(addr)))
+	if (copy_oldmem_kernel(&addr, (void *)__LC_OS_INFO, sizeof(addr)))
 		goto fail;
 	if (addr == 0 || addr % PAGE_SIZE)
 		goto fail;
-- 
2.35.1



