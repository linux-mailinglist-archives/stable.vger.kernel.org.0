Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 628BB2ABF27
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 15:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730338AbgKIOsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 09:48:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:60642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729454AbgKIOsW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 09:48:22 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D8C12074F;
        Mon,  9 Nov 2020 14:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604933301;
        bh=S18UynIqkxjtp/P4yHsbWKU1WZ2FGUpwyE6i/9d/K7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=le4VBKFqOYpUGtDdCYd3/iHQ20jLaYP0QE1KSo+SOc5VtL60J6fRW06oLe6U0ZSkC
         zfxxR9hXtjRsmdurHDytzAu0uuct++KzKmHJL2nncV5qJ93TUw7upMBaMOMarvTQiJ
         vj/3/nER1qmNmY7xpKHx98jPVuz/nMJqw5Q+0OPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Xu Pengfei <pengfei.xu@intel.com>
Subject: [PATCH 5.9 063/133] iommu/vt-d: Fix kernel NULL pointer dereference in find_domain()
Date:   Mon,  9 Nov 2020 13:55:25 +0100
Message-Id: <20201109125033.765444553@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

commit 6097df457adfb67cb75ca700fd1085ede2e1201d upstream.

If calling find_domain() for a device which hasn't been probed by the
iommu core, below kernel NULL pointer dereference issue happens.

[  362.736947] BUG: kernel NULL pointer dereference, address: 0000000000000038
[  362.743953] #PF: supervisor read access in kernel mode
[  362.749115] #PF: error_code(0x0000) - not-present page
[  362.754278] PGD 0 P4D 0
[  362.756843] Oops: 0000 [#1] SMP NOPTI
[  362.760528] CPU: 0 PID: 844 Comm: cat Not tainted 5.9.0-rc4-intel-next+ #1
[  362.767428] Hardware name: Intel Corporation Ice Lake Client Platform/IceLake
               U DDR4 SODIMM PD RVP TLC, BIOS ICLSFWR1.R00.3384.A02.1909200816
               09/20/2019
[  362.781109] RIP: 0010:find_domain+0xd/0x40
[  362.785234] Code: 48 81 fb 60 28 d9 b2 75 de 5b 41 5c 41 5d 5d c3 0f 1f 00 66
                     2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 8b 87 e0 02 00
                     00 55 <48> 8b 40 38 48 89 e5 48 83 f8 fe 0f 94 c1 48 85 ff
                     0f 94 c2 08 d1
[  362.804041] RSP: 0018:ffffb09cc1f0bd38 EFLAGS: 00010046
[  362.809292] RAX: 0000000000000000 RBX: ffff905b98e4fac8 RCX: 0000000000000000
[  362.816452] RDX: 0000000000000001 RSI: ffff905b98e4fac8 RDI: ffff905b9ccd40d0
[  362.823617] RBP: ffffb09cc1f0bda0 R08: ffffb09cc1f0bd48 R09: 000000000000000f
[  362.830778] R10: ffffffffb266c080 R11: ffff905b9042602d R12: ffff905b98e4fac8
[  362.837944] R13: ffffb09cc1f0bd48 R14: ffff905b9ccd40d0 R15: ffff905b98e4fac8
[  362.845108] FS:  00007f8485460740(0000) GS:ffff905b9fc00000(0000)
               knlGS:0000000000000000
[  362.853227] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  362.858996] CR2: 0000000000000038 CR3: 00000004627a6003 CR4: 0000000000770ef0
[  362.866161] PKRU: fffffffc
[  362.868890] Call Trace:
[  362.871363]  ? show_device_domain_translation+0x32/0x100
[  362.876700]  ? bind_store+0x110/0x110
[  362.880387]  ? klist_next+0x91/0x120
[  362.883987]  ? domain_translation_struct_show+0x50/0x50
[  362.889237]  bus_for_each_dev+0x79/0xc0
[  362.893121]  domain_translation_struct_show+0x36/0x50
[  362.898204]  seq_read+0x135/0x410
[  362.901545]  ? handle_mm_fault+0xeb8/0x1750
[  362.905755]  full_proxy_read+0x5c/0x90
[  362.909526]  vfs_read+0xa6/0x190
[  362.912782]  ksys_read+0x61/0xe0
[  362.916037]  __x64_sys_read+0x1a/0x20
[  362.919725]  do_syscall_64+0x37/0x80
[  362.923329]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  362.928405] RIP: 0033:0x7f84855c5e95

Filter out those devices to avoid such error.

Fixes: e2726daea583d ("iommu/vt-d: debugfs: Add support to show page table internals")
Reported-and-tested-by: Xu Pengfei <pengfei.xu@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Cc: stable@vger.kernel.org#v5.6+
Link: https://lore.kernel.org/r/20201028070725.24979-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel/iommu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2490,6 +2490,9 @@ struct dmar_domain *find_domain(struct d
 {
 	struct device_domain_info *info;
 
+	if (unlikely(!dev || !dev->iommu))
+		return NULL;
+
 	if (unlikely(attach_deferred(dev)))
 		return NULL;
 


