Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C168A272F04
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbgIUQqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:46:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727766AbgIUQqB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:46:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6833C20874;
        Mon, 21 Sep 2020 16:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706760;
        bh=RwSmV54ajcTgG4UbvUSgwwg4Oy/Ukgc6wF9GuWGal+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Slwr3Jzjux4KzHt0n1wCh1fvTbEweTPcyzRoE8uIvJWXOfVKkgOeW4lcn8JwggCX+
         Mt12Dd8geaKlGe//MSnXvnszsZ5BSRMF9COxIeG+lTE947GEBit2C2G3bH8DuL3nZt
         TQeoE139BxjkDOVQTOeZPtShgUk7KqOLE2BAmnQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Kuehling <Felix.Kuehling@amd.com>,
        Dennis Li <Dennis.Li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.8 083/118] drm/kfd: fix a system crash issue during GPU recovery
Date:   Mon, 21 Sep 2020 18:28:15 +0200
Message-Id: <20200921162040.195406950@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dennis Li <Dennis.Li@amd.com>

commit 66a5710beaf42903d553378f609166034bd219c7 upstream.

The crash log as the below:

[Thu Aug 20 23:18:14 2020] general protection fault: 0000 [#1] SMP NOPTI
[Thu Aug 20 23:18:14 2020] CPU: 152 PID: 1837 Comm: kworker/152:1 Tainted: G           OE     5.4.0-42-generic #46~18.04.1-Ubuntu
[Thu Aug 20 23:18:14 2020] Hardware name: GIGABYTE G482-Z53-YF/MZ52-G40-00, BIOS R12 05/13/2020
[Thu Aug 20 23:18:14 2020] Workqueue: events amdgpu_ras_do_recovery [amdgpu]
[Thu Aug 20 23:18:14 2020] RIP: 0010:evict_process_queues_cpsch+0xc9/0x130 [amdgpu]
[Thu Aug 20 23:18:14 2020] Code: 49 8d 4d 10 48 39 c8 75 21 eb 44 83 fa 03 74 36 80 78 72 00 74 0c 83 ab 68 01 00 00 01 41 c6 45 41 00 48 8b 00 48 39 c8 74 25 <80> 78 70 00 c6 40 6d 01 74 ee 8b 50 28 c6 40 70 00 83 ab 60 01 00
[Thu Aug 20 23:18:14 2020] RSP: 0018:ffffb29b52f6fc90 EFLAGS: 00010213
[Thu Aug 20 23:18:14 2020] RAX: 1c884edb0a118914 RBX: ffff8a0d45ff3c00 RCX: ffff8a2d83e41038
[Thu Aug 20 23:18:14 2020] RDX: 0000000000000000 RSI: 0000000000000082 RDI: ffff8a0e2e4178c0
[Thu Aug 20 23:18:14 2020] RBP: ffffb29b52f6fcb0 R08: 0000000000001b64 R09: 0000000000000004
[Thu Aug 20 23:18:14 2020] R10: ffffb29b52f6fb78 R11: 0000000000000001 R12: ffff8a0d45ff3d28
[Thu Aug 20 23:18:14 2020] R13: ffff8a2d83e41028 R14: 0000000000000000 R15: 0000000000000000
[Thu Aug 20 23:18:14 2020] FS:  0000000000000000(0000) GS:ffff8a0e2e400000(0000) knlGS:0000000000000000
[Thu Aug 20 23:18:14 2020] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Thu Aug 20 23:18:14 2020] CR2: 000055c783c0e6a8 CR3: 00000034a1284000 CR4: 0000000000340ee0
[Thu Aug 20 23:18:14 2020] Call Trace:
[Thu Aug 20 23:18:14 2020]  kfd_process_evict_queues+0x43/0xd0 [amdgpu]
[Thu Aug 20 23:18:14 2020]  kfd_suspend_all_processes+0x60/0xf0 [amdgpu]
[Thu Aug 20 23:18:14 2020]  kgd2kfd_suspend.part.7+0x43/0x50 [amdgpu]
[Thu Aug 20 23:18:14 2020]  kgd2kfd_pre_reset+0x46/0x60 [amdgpu]
[Thu Aug 20 23:18:14 2020]  amdgpu_amdkfd_pre_reset+0x1a/0x20 [amdgpu]
[Thu Aug 20 23:18:14 2020]  amdgpu_device_gpu_recover+0x377/0xf90 [amdgpu]
[Thu Aug 20 23:18:14 2020]  ? amdgpu_ras_error_query+0x1b8/0x2a0 [amdgpu]
[Thu Aug 20 23:18:14 2020]  amdgpu_ras_do_recovery+0x159/0x190 [amdgpu]
[Thu Aug 20 23:18:14 2020]  process_one_work+0x20f/0x400
[Thu Aug 20 23:18:14 2020]  worker_thread+0x34/0x410

When GPU hang, user process will fail to create a compute queue whose
struct object will be freed later, but driver wrongly add this queue to
queue list of the proccess. And then kfd_process_evict_queues will
access a freed memory, which cause a system crash.

v2:
The failure to execute_queues should probably not be reported to
the caller of create_queue, because the queue was already created.
Therefore change to ignore the return value from execute_queues.

Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Dennis Li <Dennis.Li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -1287,7 +1287,7 @@ static int create_queue_cpsch(struct dev
 	if (q->properties.is_active) {
 		increment_queue_count(dqm, q->properties.type);
 
-		retval = execute_queues_cpsch(dqm,
+		execute_queues_cpsch(dqm,
 				KFD_UNMAP_QUEUES_FILTER_DYNAMIC_QUEUES, 0);
 	}
 


