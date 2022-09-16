Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2F865BAAB0
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbiIPKZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232137AbiIPKYQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:24:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4B8ABF1F;
        Fri, 16 Sep 2022 03:15:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64F19B82487;
        Fri, 16 Sep 2022 10:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935EFC433D6;
        Fri, 16 Sep 2022 10:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323280;
        bh=C/uLCVTsYiMRoMsNycUwdSTE8dIo1zbVElHnME0DYIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZCc5XmFHQ/OZixM2cQ0z/pvXEUgN+NlS8PXnbyT1OQNNKPlSFaahsVLbWrclixolZ
         GpxwWgkFcKWlzo+OOpE19I1o0YIsg+VEhq2D0Lvd8JF0Jr0/nFV2nRxzrDqMj4juwD
         u2pHlskbRKu3W/KLpPLFTMaUgp+SLu0r4QmqxcVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yupeng Li <liyupeng@zbhlos.com>,
        Caicai <caizp2008@163.com>, Huacai Chen <chenhuacai@loongson.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 34/38] LoongArch: Fix arch_remove_memory() undefined build error
Date:   Fri, 16 Sep 2022 12:09:08 +0200
Message-Id: <20220916100449.895575408@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100448.431016349@linuxfoundation.org>
References: <20220916100448.431016349@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yupeng Li <liyupeng@zbhlos.com>

[ Upstream commit 1a470ce4e9106cc4c3c0edfb2e213dcbb7224dc4 ]

The kernel build error when unslected CONFIG_MEMORY_HOTREMOVE because
arch_remove_memory() is needed by mm/memory_hotplug.c but undefined.

Some build error messages like:

 LD      vmlinux.o
 MODPOST vmlinux.symvers
 MODINFO modules.builtin.modinfo
 GEN     modules.builtin
 LD      .tmp_vmlinux.kallsyms1
loongarch64-linux-gnu-ld: mm/memory_hotplug.o: in function `.L242':
memory_hotplug.c:(.ref.text+0x930): undefined reference to `arch_remove_memory'
make: *** [Makefile:1169：vmlinux] 错误 1

Removed CONFIG_MEMORY_HOTREMOVE requirement and rearrange the file refer
to the definitions of other platform architectures.

Signed-off-by: Yupeng Li <liyupeng@zbhlos.com>
Signed-off-by: Caicai <caizp2008@163.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/mm/init.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
index 7094a68c9b832..3c3fbff0b8f86 100644
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -131,18 +131,6 @@ int arch_add_memory(int nid, u64 start, u64 size, struct mhp_params *params)
 	return ret;
 }
 
-#ifdef CONFIG_NUMA
-int memory_add_physaddr_to_nid(u64 start)
-{
-	int nid;
-
-	nid = pa_to_nid(start);
-	return nid;
-}
-EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
-#endif
-
-#ifdef CONFIG_MEMORY_HOTREMOVE
 void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
@@ -154,6 +142,16 @@ void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 		page += vmem_altmap_offset(altmap);
 	__remove_pages(start_pfn, nr_pages, altmap);
 }
+
+#ifdef CONFIG_NUMA
+int memory_add_physaddr_to_nid(u64 start)
+{
+	int nid;
+
+	nid = pa_to_nid(start);
+	return nid;
+}
+EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
 #endif
 #endif
 
-- 
2.35.1



