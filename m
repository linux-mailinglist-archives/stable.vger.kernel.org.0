Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D43766DEFC8
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbjDLIxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbjDLIxp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:53:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8708A261
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:53:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8627C62F83
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:53:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC8CC433D2;
        Wed, 12 Apr 2023 08:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289588;
        bh=+cu7bMwclJKo8nNvNGCXDxFxRanEM7PNY35n75a2pII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cp8WzoT/n/4a9a+86XwXZFSlcV9iJTm085n/+OAnr8CFSMbOitRtegLg9DBZcRNG1
         v9geQ42u0/WV2lf7nTn2zp9CD3TDS64swT48QhuQdwNjZfsVUu/e0QeldGkBKkl4j8
         n/9dntj0mQ0DLFDfqGjj/xfJlsJXhJds2DIdg4DQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Pengfei Xu <pengfei.xu@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.2 127/173] iommufd: Do not corrupt the pfn list when doing batch carry
Date:   Wed, 12 Apr 2023 10:34:13 +0200
Message-Id: <20230412082843.291084057@linuxfoundation.org>
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

commit 13a0d1ae7ee6b438f5537711a8c60cba00554943 upstream.

If batch->end is 0 then setting npfns[0] before computing the new value of
pfns will fail to adjust the pfn and result in various page accounting
corruptions. It should be ordered after.

This seems to result in various kinds of page meta-data corruption related
failures:

  WARNING: CPU: 1 PID: 527 at mm/gup.c:75 try_grab_folio+0x503/0x740
  Modules linked in:
  CPU: 1 PID: 527 Comm: repro Not tainted 6.3.0-rc2-eeac8ede1755+ #1
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
  RIP: 0010:try_grab_folio+0x503/0x740
  Code: e3 01 48 89 de e8 6d c1 dd ff 48 85 db 0f 84 7c fe ff ff e8 4f bf dd ff 49 8d 47 ff 48 89 45 d0 e9 73 fe ff ff e8 3d bf dd ff <0f> 0b 31 db e9 d0 fc ff ff e8 2f bf dd ff 48 8b 5d c8 31 ff 48 89
  RSP: 0018:ffffc90000f37908 EFLAGS: 00010046
  RAX: 0000000000000000 RBX: 00000000fffffc02 RCX: ffffffff81504c26
  RDX: 0000000000000000 RSI: ffff88800d030000 RDI: 0000000000000002
  RBP: ffffc90000f37948 R08: 000000000003ca24 R09: 0000000000000008
  R10: 000000000003ca00 R11: 0000000000000023 R12: ffffea000035d540
  R13: 0000000000000001 R14: 0000000000000000 R15: ffffea000035d540
  FS:  00007fecbf659740(0000) GS:ffff88807dd00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00000000200011c3 CR3: 000000000ef66006 CR4: 0000000000770ee0
  PKRU: 55555554
  Call Trace:
   <TASK>
   internal_get_user_pages_fast+0xd32/0x2200
   pin_user_pages_fast+0x65/0x90
   pfn_reader_user_pin+0x376/0x390
   pfn_reader_next+0x14a/0x7b0
   pfn_reader_first+0x140/0x1b0
   iopt_area_fill_domain+0x74/0x210
   iopt_table_add_domain+0x30e/0x6e0
   iommufd_device_selftest_attach+0x7f/0x140
   iommufd_test+0x10ff/0x16f0
   iommufd_fops_ioctl+0x206/0x330
   __x64_sys_ioctl+0x10e/0x160
   do_syscall_64+0x3b/0x90
   entry_SYSCALL_64_after_hwframe+0x72/0xdc

Cc: <stable@vger.kernel.org>
Fixes: f394576eb11d ("iommufd: PFN handling for iopt_pages")
Link: https://lore.kernel.org/r/3-v1-ceab6a4d7d7a+94-iommufd_syz_jgg@nvidia.com
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/pages.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -294,9 +294,9 @@ static void batch_clear_carry(struct pfn
 			batch->npfns[batch->end - 1] < keep_pfns);
 
 	batch->total_pfns = keep_pfns;
-	batch->npfns[0] = keep_pfns;
 	batch->pfns[0] = batch->pfns[batch->end - 1] +
 			 (batch->npfns[batch->end - 1] - keep_pfns);
+	batch->npfns[0] = keep_pfns;
 	batch->end = 0;
 }
 


