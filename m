Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33AAB38A641
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236550AbhETKZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:25:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235475AbhETKXc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:23:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DCF761A06;
        Thu, 20 May 2021 09:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504120;
        bh=WMIvnGqZP8fbk7TW3/WdbvJBGE40rGQX0At37Gs+x94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uo67uN99AxCUZUnblS/56JDNdMluw8LdPeTWLJEsfP7TcGYYhRoMpmmLCiXEd0S02
         4cVFb4kmJcEUHZR2WIfIPr5mHqMCruflRX4bTZgTgt9FzCMJObpdGODVNfWodCbhwi
         hVJzxPUb7o9SHN2roUJXHGFHWCntug9C8/q8njD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Block <bblock@linux.ibm.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.14 102/323] dm rq: fix double free of blk_mq_tag_set in dev remove after table load fails
Date:   Thu, 20 May 2021 11:19:54 +0200
Message-Id: <20210520092123.597541465@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Block <bblock@linux.ibm.com>

commit 8e947c8f4a5620df77e43c9c75310dc510250166 upstream.

When loading a device-mapper table for a request-based mapped device,
and the allocation/initialization of the blk_mq_tag_set for the device
fails, a following device remove will cause a double free.

E.g. (dmesg):
  device-mapper: core: Cannot initialize queue for request-based dm-mq mapped device
  device-mapper: ioctl: unable to set up device queue for new table.
  Unable to handle kernel pointer dereference in virtual kernel address space
  Failing address: 0305e098835de000 TEID: 0305e098835de803
  Fault in home space mode while using kernel ASCE.
  AS:000000025efe0007 R3:0000000000000024
  Oops: 0038 ilc:3 [#1] SMP
  Modules linked in: ... lots of modules ...
  Supported: Yes, External
  CPU: 0 PID: 7348 Comm: multipathd Kdump: loaded Tainted: G        W      X    5.3.18-53-default #1 SLE15-SP3
  Hardware name: IBM 8561 T01 7I2 (LPAR)
  Krnl PSW : 0704e00180000000 000000025e368eca (kfree+0x42/0x330)
             R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
  Krnl GPRS: 000000000000004a 000000025efe5230 c1773200d779968d 0000000000000000
             000000025e520270 000000025e8d1b40 0000000000000003 00000007aae10000
             000000025e5202a2 0000000000000001 c1773200d779968d 0305e098835de640
             00000007a8170000 000003ff80138650 000000025e5202a2 000003e00396faa8
  Krnl Code: 000000025e368eb8: c4180041e100       lgrl    %r1,25eba50b8
             000000025e368ebe: ecba06b93a55       risbg   %r11,%r10,6,185,58
            #000000025e368ec4: e3b010000008       ag      %r11,0(%r1)
            >000000025e368eca: e310b0080004       lg      %r1,8(%r11)
             000000025e368ed0: a7110001           tmll    %r1,1
             000000025e368ed4: a7740129           brc     7,25e369126
             000000025e368ed8: e320b0080004       lg      %r2,8(%r11)
             000000025e368ede: b904001b           lgr     %r1,%r11
  Call Trace:
   [<000000025e368eca>] kfree+0x42/0x330
   [<000000025e5202a2>] blk_mq_free_tag_set+0x72/0xb8
   [<000003ff801316a8>] dm_mq_cleanup_mapped_device+0x38/0x50 [dm_mod]
   [<000003ff80120082>] free_dev+0x52/0xd0 [dm_mod]
   [<000003ff801233f0>] __dm_destroy+0x150/0x1d0 [dm_mod]
   [<000003ff8012bb9a>] dev_remove+0x162/0x1c0 [dm_mod]
   [<000003ff8012a988>] ctl_ioctl+0x198/0x478 [dm_mod]
   [<000003ff8012ac8a>] dm_ctl_ioctl+0x22/0x38 [dm_mod]
   [<000000025e3b11ee>] ksys_ioctl+0xbe/0xe0
   [<000000025e3b127a>] __s390x_sys_ioctl+0x2a/0x40
   [<000000025e8c15ac>] system_call+0xd8/0x2c8
  Last Breaking-Event-Address:
   [<000000025e52029c>] blk_mq_free_tag_set+0x6c/0xb8
  Kernel panic - not syncing: Fatal exception: panic_on_oops

When allocation/initialization of the blk_mq_tag_set fails in
dm_mq_init_request_queue(), it is uninitialized/freed, but the pointer
is not reset to NULL; so when dev_remove() later gets into
dm_mq_cleanup_mapped_device() it sees the pointer and tries to
uninitialize and free it again.

Fix this by setting the pointer to NULL in dm_mq_init_request_queue()
error-handling. Also set it to NULL in dm_mq_cleanup_mapped_device().

Cc: <stable@vger.kernel.org> # 4.6+
Fixes: 1c357a1e86a4 ("dm: allocate blk_mq_tag_set rather than embed in mapped_device")
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-rq.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -822,6 +822,7 @@ out_tag_set:
 	blk_mq_free_tag_set(md->tag_set);
 out_kfree_tag_set:
 	kfree(md->tag_set);
+	md->tag_set = NULL;
 
 	return err;
 }
@@ -831,6 +832,7 @@ void dm_mq_cleanup_mapped_device(struct
 	if (md->tag_set) {
 		blk_mq_free_tag_set(md->tag_set);
 		kfree(md->tag_set);
+		md->tag_set = NULL;
 	}
 }
 


