Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17BA84891A8
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240321AbiAJHeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:34:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240278AbiAJHbi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:31:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4BDC0254AD;
        Sun,  9 Jan 2022 23:28:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2C4E611B8;
        Mon, 10 Jan 2022 07:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60FDC36AE9;
        Mon, 10 Jan 2022 07:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799704;
        bh=Z+zCmTEq1nUUaLCcSgs4oup25kLMn11yeAWlNCsjOKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YI1DkmmY3/7daHgqrBC8UAn63C8Rb5lcThW1RXsiwmYlRLZ5Ynb9EMXA3aLNfcgxq
         UyxG9H1zSovK2umpGAUmvJH7mime1A08FezHEDis68XDtUTmMrNhR3Tv4tKLmCU4Qv
         3THOETya/QWJr3TPT35XSTDw0vjLks4VG3DwkDEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+6d532fa8f9463da290bc@syzkaller.appspotmail.com,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.4 08/34] RDMA/core: Dont infoleak GRH fields
Date:   Mon, 10 Jan 2022 08:23:03 +0100
Message-Id: <20220110071815.928781935@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071815.647309738@linuxfoundation.org>
References: <20220110071815.647309738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

commit b35a0f4dd544eaa6162b6d2f13a2557a121ae5fd upstream.

If dst->is_global field is not set, the GRH fields are not cleared
and the following infoleak is reported.

=====================================================
BUG: KMSAN: kernel-infoleak in instrument_copy_to_user include/linux/instrumented.h:121 [inline]
BUG: KMSAN: kernel-infoleak in _copy_to_user+0x1c9/0x270 lib/usercopy.c:33
 instrument_copy_to_user include/linux/instrumented.h:121 [inline]
 _copy_to_user+0x1c9/0x270 lib/usercopy.c:33
 copy_to_user include/linux/uaccess.h:209 [inline]
 ucma_init_qp_attr+0x8c7/0xb10 drivers/infiniband/core/ucma.c:1242
 ucma_write+0x637/0x6c0 drivers/infiniband/core/ucma.c:1732
 vfs_write+0x8ce/0x2030 fs/read_write.c:588
 ksys_write+0x28b/0x510 fs/read_write.c:643
 __do_sys_write fs/read_write.c:655 [inline]
 __se_sys_write fs/read_write.c:652 [inline]
 __ia32_sys_write+0xdb/0x120 fs/read_write.c:652
 do_syscall_32_irqs_on arch/x86/entry/common.c:114 [inline]
 __do_fast_syscall_32+0x96/0xf0 arch/x86/entry/common.c:180
 do_fast_syscall_32+0x34/0x70 arch/x86/entry/common.c:205
 do_SYSENTER_32+0x1b/0x20 arch/x86/entry/common.c:248
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c

Local variable resp created at:
 ucma_init_qp_attr+0xa4/0xb10 drivers/infiniband/core/ucma.c:1214
 ucma_write+0x637/0x6c0 drivers/infiniband/core/ucma.c:1732

Bytes 40-59 of 144 are uninitialized
Memory access of size 144 starts at ffff888167523b00
Data copied to user address 0000000020000100

CPU: 1 PID: 25910 Comm: syz-executor.1 Not tainted 5.16.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
=====================================================

Fixes: 4ba66093bdc6 ("IB/core: Check for global flag when using ah_attr")
Link: https://lore.kernel.org/r/0e9dd51f93410b7b2f4f5562f52befc878b71afa.1641298868.git.leonro@nvidia.com
Reported-by: syzbot+6d532fa8f9463da290bc@syzkaller.appspotmail.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/uverbs_marshall.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/core/uverbs_marshall.c
+++ b/drivers/infiniband/core/uverbs_marshall.c
@@ -66,7 +66,7 @@ void ib_copy_ah_attr_to_user(struct ib_d
 	struct rdma_ah_attr *src = ah_attr;
 	struct rdma_ah_attr conv_ah;
 
-	memset(&dst->grh.reserved, 0, sizeof(dst->grh.reserved));
+	memset(&dst->grh, 0, sizeof(dst->grh));
 
 	if ((ah_attr->type == RDMA_AH_ATTR_TYPE_OPA) &&
 	    (rdma_ah_get_dlid(ah_attr) > be16_to_cpu(IB_LID_PERMISSIVE)) &&


