Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435F65A6A89
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbiH3Ra2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231800AbiH3R34 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:29:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1332AEB85A;
        Tue, 30 Aug 2022 10:26:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0678BB81CD0;
        Tue, 30 Aug 2022 17:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E5BC433C1;
        Tue, 30 Aug 2022 17:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661880315;
        bh=fPid+q0GoEnpfhUVAoMELTMnsoxydhxBhddicCiYKQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DlDu07CQKrBT5XmTgFKU55EfrtQVKEkMA2WcjNPuGq7H6x5/F9EK2DXxF3eyiY76Q
         I6KeysURbKF+OuSxTArXHLaMoTenQPYKjnv3p+05HeN23HPcCBuLi8eyu+Br5DP66z
         ImEnm71OdpgOUbg/yUheddgG+tD+6AgVeXLAPJhQgVQyrj09/vagYqPj2/4TOOvAU9
         zt6ThIM/DEQedsax8bY7B5RlmnBj7xfBzv27awBPHr2Q2Bglcwanj5i6z2ybQXcrkT
         pnfPEjhrhvhYpMLbpcX1UnNvd9fqg4Lo+hZo5Gemrhq73myOuUmoXJiKN6QE0i2qMl
         BRb0/n0bHhMTw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        Bruno Goncalves <bgoncalv@redhat.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        catalin.marinas@arm.com, peterz@infradead.org, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 08/12] arm64: cacheinfo: Fix incorrect assignment of signed error value to unsigned fw_level
Date:   Tue, 30 Aug 2022 13:24:39 -0400
Message-Id: <20220830172444.581654-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830172444.581654-1-sashal@kernel.org>
References: <20220830172444.581654-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit e75d18cecbb3805895d8ed64da4f78575ec96043 ]

Though acpi_find_last_cache_level() always returned signed value and the
document states it will return any errors caused by lack of a PPTT table,
it never returned negative values before.

Commit 0c80f9e165f8 ("ACPI: PPTT: Leave the table mapped for the runtime usage")
however changed it by returning -ENOENT if no PPTT was found. The value
returned from acpi_find_last_cache_level() is then assigned to unsigned
fw_level.

It will result in the number of cache leaves calculated incorrectly as
a huge value which will then cause the following warning from __alloc_pages
as the order would be great than MAX_ORDER because of incorrect and huge
cache leaves value.

  |  WARNING: CPU: 0 PID: 1 at mm/page_alloc.c:5407 __alloc_pages+0x74/0x314
  |  Modules linked in:
  |  CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.19.0-10393-g7c2a8d3ac4c0 #73
  |  pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  |  pc : __alloc_pages+0x74/0x314
  |  lr : alloc_pages+0xe8/0x318
  |  Call trace:
  |   __alloc_pages+0x74/0x314
  |   alloc_pages+0xe8/0x318
  |   kmalloc_order_trace+0x68/0x1dc
  |   __kmalloc+0x240/0x338
  |   detect_cache_attributes+0xe0/0x56c
  |   update_siblings_masks+0x38/0x284
  |   store_cpu_topology+0x78/0x84
  |   smp_prepare_cpus+0x48/0x134
  |   kernel_init_freeable+0xc4/0x14c
  |   kernel_init+0x2c/0x1b4
  |   ret_from_fork+0x10/0x20

Fix the same by changing fw_level to be signed integer and return the
error from init_cache_level() early in case of error.

Reported-and-Tested-by: Bruno Goncalves <bgoncalv@redhat.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Link: https://lore.kernel.org/r/20220808084640.3165368-1-sudeep.holla@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/cacheinfo.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/cacheinfo.c b/arch/arm64/kernel/cacheinfo.c
index 587543c6c51cb..97c42be71338a 100644
--- a/arch/arm64/kernel/cacheinfo.c
+++ b/arch/arm64/kernel/cacheinfo.c
@@ -45,7 +45,8 @@ static void ci_leaf_init(struct cacheinfo *this_leaf,
 
 int init_cache_level(unsigned int cpu)
 {
-	unsigned int ctype, level, leaves, fw_level;
+	unsigned int ctype, level, leaves;
+	int fw_level;
 	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
 
 	for (level = 1, leaves = 0; level <= MAX_CACHE_LEVEL; level++) {
@@ -63,6 +64,9 @@ int init_cache_level(unsigned int cpu)
 	else
 		fw_level = acpi_find_last_cache_level(cpu);
 
+	if (fw_level < 0)
+		return fw_level;
+
 	if (level < fw_level) {
 		/*
 		 * some external caches not specified in CLIDR_EL1
-- 
2.35.1

