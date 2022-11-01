Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0436148C6
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbiKAL3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbiKAL3N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:29:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C81660E7;
        Tue,  1 Nov 2022 04:28:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4986B81CC6;
        Tue,  1 Nov 2022 11:28:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D8A4C433C1;
        Tue,  1 Nov 2022 11:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302108;
        bh=bJGpsnaeqIW4OyysBJrOqqOPq6OzDc2JHGBYXmqPJEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kg289btFN8V8DcuR1CHr7UwGBl39yH39510M6nH9owraouE4KqkosMwk4NbEav/By
         z169SoSyhHjn8Iv9o5h6bcPr+TQgpvxIr3zrVUxiA1PIT3WfwaDRvxFPbKzeN9+xb1
         x8SDV6XNA7302kEFWKMxplAwHVGpCGnKBz+lot1GWYyvQY/Km6UvV+/WfbABT5pqmY
         n3uT2PqGCLi6kwXcKrIvvPqR3K8enCV934mT0hY2j0lk///8hPca65f6YiPt1L5HCl
         ghCeQGR+Jwv8d37PWF9m3WbCYHrZkyxtxNMW6Nxc4d+Ro8I6kWNGq9EjRdj5PkxfoH
         bO6y7I93QL2+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ashish Kalra <ashish.kalra@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        robert.moore@intel.com, xueshuai@linux.alibaba.com,
        tony.luck@intel.com, dave.hansen@linux.intel.com,
        linux-acpi@vger.kernel.org, devel@acpica.org
Subject: [PATCH AUTOSEL 6.0 21/34] ACPI: APEI: Fix integer overflow in ghes_estatus_pool_init()
Date:   Tue,  1 Nov 2022 07:27:13 -0400
Message-Id: <20221101112726.799368-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221101112726.799368-1-sashal@kernel.org>
References: <20221101112726.799368-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

[ Upstream commit 43d2748394c3feb86c0c771466f5847e274fc043 ]

Change num_ghes from int to unsigned int, preventing an overflow
and causing subsequent vmalloc() to fail.

The overflow happens in ghes_estatus_pool_init() when calculating
len during execution of the statement below as both multiplication
operands here are signed int:

len += (num_ghes * GHES_ESOURCE_PREALLOC_MAX_SIZE);

The following call trace is observed because of this bug:

[    9.317108] swapper/0: vmalloc error: size 18446744071562596352, exceeds total pages, mode:0xcc0(GFP_KERNEL), nodemask=(null),cpuset=/,mems_allowed=0-1
[    9.317131] Call Trace:
[    9.317134]  <TASK>
[    9.317137]  dump_stack_lvl+0x49/0x5f
[    9.317145]  dump_stack+0x10/0x12
[    9.317146]  warn_alloc.cold+0x7b/0xdf
[    9.317150]  ? __device_attach+0x16a/0x1b0
[    9.317155]  __vmalloc_node_range+0x702/0x740
[    9.317160]  ? device_add+0x17f/0x920
[    9.317164]  ? dev_set_name+0x53/0x70
[    9.317166]  ? platform_device_add+0xf9/0x240
[    9.317168]  __vmalloc_node+0x49/0x50
[    9.317170]  ? ghes_estatus_pool_init+0x43/0xa0
[    9.317176]  vmalloc+0x21/0x30
[    9.317177]  ghes_estatus_pool_init+0x43/0xa0
[    9.317179]  acpi_hest_init+0x129/0x19c
[    9.317185]  acpi_init+0x434/0x4a4
[    9.317188]  ? acpi_sleep_proc_init+0x2a/0x2a
[    9.317190]  do_one_initcall+0x48/0x200
[    9.317195]  kernel_init_freeable+0x221/0x284
[    9.317200]  ? rest_init+0xe0/0xe0
[    9.317204]  kernel_init+0x1a/0x130
[    9.317205]  ret_from_fork+0x22/0x30
[    9.317208]  </TASK>

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/apei/ghes.c | 2 +-
 include/acpi/ghes.h      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 80ad530583c9..9952f3a792ba 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -163,7 +163,7 @@ static void ghes_unmap(void __iomem *vaddr, enum fixed_addresses fixmap_idx)
 	clear_fixmap(fixmap_idx);
 }
 
-int ghes_estatus_pool_init(int num_ghes)
+int ghes_estatus_pool_init(unsigned int num_ghes)
 {
 	unsigned long addr, len;
 	int rc;
diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
index 34fb3431a8f3..292a5c40bd0c 100644
--- a/include/acpi/ghes.h
+++ b/include/acpi/ghes.h
@@ -71,7 +71,7 @@ int ghes_register_vendor_record_notifier(struct notifier_block *nb);
 void ghes_unregister_vendor_record_notifier(struct notifier_block *nb);
 #endif
 
-int ghes_estatus_pool_init(int num_ghes);
+int ghes_estatus_pool_init(unsigned int num_ghes);
 
 /* From drivers/edac/ghes_edac.c */
 
-- 
2.35.1

