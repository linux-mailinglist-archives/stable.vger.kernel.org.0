Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5956DEFC5
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbjDLIxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbjDLIxl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:53:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42047681
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:53:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A6A562FEB
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B434C433EF;
        Wed, 12 Apr 2023 08:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289582;
        bh=HwGD20aw2Uhk8LR08LDswf1QCrkCA7G1qh2arg/pkpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zzGlVdU4doWsX1vUqG6rnzQ+Kx69WdLHDQF034AQ4H1prmPDgnYVeZj3oXr0KA7Qp
         JoQHqSbXydwN6pxj4pHWHVcgymoHysbE4b9a4nS3l5CfIGl2m/M3cV+bKfPcEloLnV
         MaSes+DEb9h41KRUq5ekponNpp9bk2XMdoAGyMDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Pengfei Xu <pengfei.xu@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.2 125/173] iommufd: Check for uptr overflow
Date:   Wed, 12 Apr 2023 10:34:11 +0200
Message-Id: <20230412082843.195963548@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

commit e4395701330fc4aee530905039516fe770b81417 upstream.

syzkaller found that setting up a map with a user VA that wraps past zero
can trigger WARN_ONs, particularly from pin_user_pages weirdly returning 0
due to invalid arguments.

Prevent creating a pages with a uptr and size that would math overflow.

  WARNING: CPU: 0 PID: 518 at drivers/iommu/iommufd/pages.c:793 pfn_reader_user_pin+0x2e6/0x390
  Modules linked in:
  CPU: 0 PID: 518 Comm: repro Not tainted 6.3.0-rc2-eeac8ede1755+ #1
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
  RIP: 0010:pfn_reader_user_pin+0x2e6/0x390
  Code: b1 11 e9 25 fe ff ff e8 28 e4 0f ff 31 ff 48 89 de e8 2e e6 0f ff 48 85 db 74 0a e8 14 e4 0f ff e9 4d ff ff ff e8 0a e4 0f ff <0f> 0b bb f2 ff ff ff e9 3c ff ff ff e8 f9 e3 0f ff ba 01 00 00 00
  RSP: 0018:ffffc90000f9fa30 EFLAGS: 00010246
  RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff821e2b72
  RDX: 0000000000000000 RSI: ffff888014184680 RDI: 0000000000000002
  RBP: ffffc90000f9fa78 R08: 00000000000000ff R09: 0000000079de6f4e
  R10: ffffc90000f9f790 R11: ffff888014185418 R12: ffffc90000f9fc60
  R13: 0000000000000002 R14: ffff888007879800 R15: 0000000000000000
  FS:  00007f4227555740(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000020000043 CR3: 000000000e748005 CR4: 0000000000770ef0
  PKRU: 55555554
  Call Trace:
   <TASK>
   pfn_reader_next+0x14a/0x7b0
   ? interval_tree_double_span_iter_update+0x11a/0x140
   pfn_reader_first+0x140/0x1b0
   iopt_pages_rw_slow+0x71/0x280
   ? __this_cpu_preempt_check+0x20/0x30
   iopt_pages_rw_access+0x2b2/0x5b0
   iommufd_access_rw+0x19f/0x2f0
   iommufd_test+0xd11/0x16f0
   ? write_comp_data+0x2f/0x90
   iommufd_fops_ioctl+0x206/0x330
   __x64_sys_ioctl+0x10e/0x160
   ? __pfx_iommufd_fops_ioctl+0x10/0x10
   do_syscall_64+0x3b/0x90
   entry_SYSCALL_64_after_hwframe+0x72/0xdc

Cc: <stable@vger.kernel.org>
Fixes: 8d160cd4d506 ("iommufd: Algorithms for PFN storage")
Link: https://lore.kernel.org/r/1-v1-ceab6a4d7d7a+94-iommufd_syz_jgg@nvidia.com
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/pages.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -1140,6 +1140,7 @@ struct iopt_pages *iopt_alloc_pages(void
 				    bool writable)
 {
 	struct iopt_pages *pages;
+	unsigned long end;
 
 	/*
 	 * The iommu API uses size_t as the length, and protect the DIV_ROUND_UP
@@ -1148,6 +1149,9 @@ struct iopt_pages *iopt_alloc_pages(void
 	if (length > SIZE_MAX - PAGE_SIZE || length == 0)
 		return ERR_PTR(-EINVAL);
 
+	if (check_add_overflow((unsigned long)uptr, length, &end))
+		return ERR_PTR(-EOVERFLOW);
+
 	pages = kzalloc(sizeof(*pages), GFP_KERNEL_ACCOUNT);
 	if (!pages)
 		return ERR_PTR(-ENOMEM);


