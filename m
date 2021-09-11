Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 885B640763E
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 13:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbhIKLWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 07:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbhIKLWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Sep 2021 07:22:37 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708B7C061574
        for <stable@vger.kernel.org>; Sat, 11 Sep 2021 04:21:25 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id j1so3073950pjv.3
        for <stable@vger.kernel.org>; Sat, 11 Sep 2021 04:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kJJwtO9lB/Xezb44Hovfs3VS8ns8msbsl33JR663TRw=;
        b=kFt+rNpsHh6vcDhYnI5L0HfAVrfZNNXVYNwKzBkga2NIwZBltLslp1Q8ZRUxh5Tn3D
         Dz8MruNhp5KGpwwYwIsBQB/OKZ8GS6d99d2U9D0Ke5PUMkhmzMd+gm1aOwaNGBbe8HHI
         q8d0Iou94kajVTq/N8DGYGT37jYpRHvQ9YezpX6GINO1v9MzHLoFmeetZ7r/YKaxQgVQ
         3rqJiQYde6GLSSL+TZriypz7s0Q0OTczKOdIkZH3Etzt7TfgLRm8pPbVarjFZV5/UAgq
         B593h9aKOzWaF3U4xWxAmiucD3WwAXPIhwcLA119qWUiJflE+roHUyitjzu6NmSqAdkr
         s/Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kJJwtO9lB/Xezb44Hovfs3VS8ns8msbsl33JR663TRw=;
        b=MrOfXEkBc2YOaqCwRdX0Jxcrw6HRyfoBHyAZb7PCMMSTqXqykzR8TS7Ncnwy+QCZTa
         pBo0X8SEDlkrBsPrIt/+MQiYWEs4/kFMUki/eYa+dGt/VKo1reGBSAxzgmC5QtT1dwez
         uvo4VdzmTYDdiYbsje199LLWQpFJSFAZBD6GmIufX0LyqrEG19EaY2ykmRLl/m+RGbDF
         XL0Hg3n4hUz8yNZi6tmPUXG1RRvaw5536Uvc1wB8EXH3/+dXppB8dsLkiCpH7JeD7pEc
         kkQH65G6IHF+ZojGziY6UW44xXQ0jZotoEslBdlApSzIfBVLRrj0c2PpOYhwYVt3k3k1
         kIEw==
X-Gm-Message-State: AOAM5327oRo3Wgs7wTJCn3tdiBshO2qV7PhLEjOVu/523/y0auhM7DX4
        wG7j7wH0HT2TSM1U51GXfeI=
X-Google-Smtp-Source: ABdhPJzVIFoi2nSdhCT/vFkJAyOitLLkhq9MHE9JCUc572licN0EMOMfUa0KbyChkJ4Gtt/IfqLpIA==
X-Received: by 2002:a17:90a:1282:: with SMTP id g2mr2490917pja.230.1631359284923;
        Sat, 11 Sep 2021 04:21:24 -0700 (PDT)
Received: from localhost.localdomain ([119.8.124.150])
        by smtp.gmail.com with ESMTPSA id g13sm1702101pfi.176.2021.09.11.04.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Sep 2021 04:21:24 -0700 (PDT)
From:   Cheng Chao <cs.os.kernel@gmail.com>
To:     labbott@redhat.com, sumit.semwal@linaro.org,
        gregkh@linuxfoundation.org, arve@android.com,
        riandrews@android.com, devel@driverdev.osuosl.org
Cc:     stable@vger.kernel.org, Cheng Chao <cs.os.kernel@gmail.com>
Subject: [PATCH] [PATCH 4.9] staging: android: ion: fix page is NULL
Date:   Sat, 11 Sep 2021 19:21:15 +0800
Message-Id: <20210911112115.47202-1-cs.os.kernel@gmail.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

kernel panic is here:

Unable to handle kernel paging request at virtual address b0380000
pgd = d9d94000
[b0380000] *pgd=00000000
Internal error: Oops: 2805 [#1] PREEMPT SMP ARM
...
task: daa2dd00 task.stack: da194000
PC is at v7_dma_clean_range+0x1c/0x34
LR is at arm_dma_sync_single_for_device+0x44/0x58
pc : [<c011aa0c>]    lr : [<c011645c>]    psr: 200f0013
sp : da195da0  ip : dc1f9000  fp : c1043dc4
r10: 00000000  r9 : c16f1f58  r8 : 00000001
r7 : c1621f94  r6 : c0116418  r5 : 00000000  r4 : c011aa58
r3 : 0000003f  r2 : 00000040  r1 : b0480000  r0 : b0380000
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
Control: 10c5383d  Table: 19d9406a  DAC: 00000051
...
[<c011aa0c>] (v7_dma_clean_range) from [<c011645c>] (arm_dma_sync_single_for_device+0x44/0x58)
[<c011645c>] (arm_dma_sync_single_for_device) from [<c0117088>] (arm_dma_sync_sg_for_device+0x50/0x7c)
[<c0117088>] (arm_dma_sync_sg_for_device) from [<c0c033c4>] (ion_pages_sync_for_device+0xb0/0xec)
[<c0c033c4>] (ion_pages_sync_for_device) from [<c0c054ac>] (ion_system_heap_allocate+0x2a0/0x2e0)
[<c0c054ac>] (ion_system_heap_allocate) from [<c0c02c78>] (ion_alloc+0x12c/0x494)
[<c0c02c78>] (ion_alloc) from [<c0c03eac>] (ion_ioctl+0x510/0x63c)
[<c0c03eac>] (ion_ioctl) from [<c027c4b0>] (do_vfs_ioctl+0xa8/0x9b4)
[<c027c4b0>] (do_vfs_ioctl) from [<c027ce28>] (SyS_ioctl+0x6c/0x7c)
[<c027ce28>] (SyS_ioctl) from [<c0108a40>] (ret_fast_syscall+0x0/0x48)
Code: e3a02004 e1a02312 e2423001 e1c00003 (ee070f3a)
---[ end trace 89278304932c0e87 ]---
Kernel panic - not syncing: Fatal exception

Signed-off-by: Cheng Chao <cs.os.kernel@gmail.com>
---
 drivers/staging/android/ion/ion_system_heap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 22c481f2ae4f..2a35b99cf628 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -75,7 +75,7 @@ static struct page *alloc_buffer_page(struct ion_system_heap *heap,
 
 	page = ion_page_pool_alloc(pool);
 
-	if (cached)
+	if (page && cached)
 		ion_pages_sync_for_device(NULL, page, PAGE_SIZE << order,
 					  DMA_BIDIRECTIONAL);
 	return page;
-- 
2.26.3

