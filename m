Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E9C6DEFC7
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbjDLIxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbjDLIxm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:53:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A8B93E0
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:53:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E83916306D
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:53:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083FAC4339B;
        Wed, 12 Apr 2023 08:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289585;
        bh=fi7UIqVYSi1dBpAR/4HrYq3bT+qR+Nidi0EqXxox2uI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uw/Ysh93QM4RbLyF9LKqrLVnktkzaPLk+WRifHUhcBFCDXNErT+Gd2kUgt5+reG7u
         eN9v2YIKubpBATs/ebr62ugxo4A6CgQg/dejPPFOwV3ChOK60H7rogicMuBVYemms7
         K4dJxhvtV9aGbJ21BJI+EpmtUIFtK/TU2PBdGm58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Pengfei Xu <pengfei.xu@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.2 126/173] iommufd: Fix unpinning of pages when an access is present
Date:   Wed, 12 Apr 2023 10:34:12 +0200
Message-Id: <20230412082843.248249427@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

commit 727c28c1cef2bc013d2c8bb6c50e410a3882a04e upstream.

syzkaller found that the calculation of batch_last_index should use
'start_index' since at input to this function the batch is either empty or
it has already been adjusted to cross any accesses so it will start at the
point we are unmapping from.

Getting this wrong causes the unmap to run over the end of the pages
which corrupts pages that were never mapped. In most cases this triggers
the num pinned debugging:

  WARNING: CPU: 0 PID: 557 at drivers/iommu/iommufd/pages.c:294 __iopt_area_unfill_domain+0x152/0x560
  Modules linked in:
  CPU: 0 PID: 557 Comm: repro Not tainted 6.3.0-rc2-eeac8ede1755 #1
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
  RIP: 0010:__iopt_area_unfill_domain+0x152/0x560
  Code: d2 0f ff 44 8b 64 24 54 48 8b 44 24 48 31 ff 44 89 e6 48 89 44 24 38 e8 fc d3 0f ff 45 85 e4 0f 85 eb 01 00 00 e8 0e d2 0f ff <0f> 0b e8 07 d2 0f ff 48 8b 44 24 38 89 5c 24 58 89 18 8b 44 24 54
  RSP: 0018:ffffc9000108baf0 EFLAGS: 00010246
  RAX: 0000000000000000 RBX: 00000000ffffffff RCX: ffffffff821e3f85
  RDX: 0000000000000000 RSI: ffff88800faf0000 RDI: 0000000000000002
  RBP: ffffc9000108bd18 R08: 000000000003ca25 R09: 0000000000000014
  R10: 000000000003ca00 R11: 0000000000000024 R12: 0000000000000004
  R13: 0000000000000801 R14: 00000000000007ff R15: 0000000000000800
  FS:  00007f3499ce1740(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000020000243 CR3: 00000000179c2001 CR4: 0000000000770ef0
  PKRU: 55555554
  Call Trace:
   <TASK>
   iopt_area_unfill_domain+0x32/0x40
   iopt_table_remove_domain+0x23f/0x4c0
   iommufd_device_selftest_detach+0x3a/0x90
   iommufd_selftest_destroy+0x55/0x70
   iommufd_object_destroy_user+0xce/0x130
   iommufd_destroy+0xa2/0xc0
   iommufd_fops_ioctl+0x206/0x330
   __x64_sys_ioctl+0x10e/0x160
   do_syscall_64+0x3b/0x90
   entry_SYSCALL_64_after_hwframe+0x72/0xdc

Also add some useful WARN_ON sanity checks.

Cc: <stable@vger.kernel.org>
Fixes: 8d160cd4d506 ("iommufd: Algorithms for PFN storage")
Link: https://lore.kernel.org/r/2-v1-ceab6a4d7d7a+94-iommufd_syz_jgg@nvidia.com
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/pages.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -1205,13 +1205,21 @@ iopt_area_unpin_domain(struct pfn_batch
 			unsigned long start =
 				max(start_index, *unmapped_end_index);
 
+			if (IS_ENABLED(CONFIG_IOMMUFD_TEST) &&
+			    batch->total_pfns)
+				WARN_ON(*unmapped_end_index -
+						batch->total_pfns !=
+					start_index);
 			batch_from_domain(batch, domain, area, start,
 					  last_index);
-			batch_last_index = start + batch->total_pfns - 1;
+			batch_last_index = start_index + batch->total_pfns - 1;
 		} else {
 			batch_last_index = last_index;
 		}
 
+		if (IS_ENABLED(CONFIG_IOMMUFD_TEST))
+			WARN_ON(batch_last_index > real_last_index);
+
 		/*
 		 * unmaps must always 'cut' at a place where the pfns are not
 		 * contiguous to pair with the maps that always install


