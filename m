Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 521966A09FD
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234471AbjBWNMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:12:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234457AbjBWNMS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:12:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF305709B
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:11:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81606616E2
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A72BC433D2;
        Thu, 23 Feb 2023 13:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157898;
        bh=sa98HqRTL9MtJaaPFAn23CxWn5Aa8YRrGHp9Gudoazk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J5HPnuzR1Ax9FHz96BF2OXx7EqGiWwmZBUUjMteoU003ZtSagaRYR16KwtDwZawlc
         bYSC8d2M2b2AQr8lXkTJwFUe4Tnw5mY9e+ijSa1qf+HK+8006FRv0KV/QyYUYExy8c
         GA2CkLhkBMU9ujc0hhPkYCm/wX/FBVjMTTVlZCIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 16/36] powerpc: use generic version of arch_is_kernel_initmem_freed()
Date:   Thu, 23 Feb 2023 14:06:52 +0100
Message-Id: <20230223130429.831053507@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130429.072633724@linuxfoundation.org>
References: <20230223130429.072633724@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit e012a25d81a12fb332e862b51bfb59321acf96e4 ]

The generic version of arch_is_kernel_initmem_freed() now does the same
as powerpc version.

Remove the powerpc version.

Link: https://lkml.kernel.org/r/c53764eb45d41491e2b21da2e7812239897dbebb.1633001016.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 111bcb373853 ("powerpc/64s/radix: Fix RWX mapping with relocated kernel")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/sections.h | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/arch/powerpc/include/asm/sections.h b/arch/powerpc/include/asm/sections.h
index 6e4af4492a144..79cb7a25a5fb6 100644
--- a/arch/powerpc/include/asm/sections.h
+++ b/arch/powerpc/include/asm/sections.h
@@ -6,21 +6,8 @@
 #include <linux/elf.h>
 #include <linux/uaccess.h>
 
-#define arch_is_kernel_initmem_freed arch_is_kernel_initmem_freed
-
 #include <asm-generic/sections.h>
 
-extern bool init_mem_is_free;
-
-static inline int arch_is_kernel_initmem_freed(unsigned long addr)
-{
-	if (!init_mem_is_free)
-		return 0;
-
-	return addr >= (unsigned long)__init_begin &&
-		addr < (unsigned long)__init_end;
-}
-
 extern char __head_end[];
 
 #ifdef __powerpc64__
-- 
2.39.0



