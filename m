Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9710A15C32B
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387526AbgBMP2a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:28:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:55820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729253AbgBMP2a (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:28:30 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39E432168B;
        Thu, 13 Feb 2020 15:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607709;
        bh=z/WtUz4AKZSnQtO/cXvJ2xEDaFhOkKkM2eHlX7OLMVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xc3pAlAcObPzKWxu9L5Mkz2TH6WZDPH/cV6uQWa6kvdM24SPG1l9zdf5GY3Q8Yo5o
         hHnHh2YxCsuKmadkNxrvhSSEnDj86CE9B+M322NNUfNqcS3DNGIany+PLlAp9fD0+n
         FBAMDUpfGyQnS0AfwbQWcP8QaRKmaOyqQaZC4VX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH 5.5 046/120] netdevsim: use __GFP_NOWARN to avoid memalloc warning
Date:   Thu, 13 Feb 2020 07:20:42 -0800
Message-Id: <20200213151917.303017548@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
References: <20200213151901.039700531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

commit 83cf4213bafc4e3c747f0a25ad22cfbf55af7e84 upstream.

vfnum buffer size and binary_len buffer size is received by user-space.
So, this buffer size could be too large. If so, kmalloc will internally
print a warning message.
This warning message is actually not necessary for the netdevsim module.
So, this patch adds __GFP_NOWARN.

Test commands:
    modprobe netdevsim
    echo 1 > /sys/bus/netdevsim/new_device
    echo 1000000000 > /sys/devices/netdevsim1/sriov_numvfs

Splat looks like:
[  357.847266][ T1000] WARNING: CPU: 0 PID: 1000 at mm/page_alloc.c:4738 __alloc_pages_nodemask+0x2f3/0x740
[  357.850273][ T1000] Modules linked in: netdevsim veth openvswitch nsh nf_conncount nf_nat nf_conntrack nf_defrx
[  357.852989][ T1000] CPU: 0 PID: 1000 Comm: bash Tainted: G    B             5.5.0-rc5+ #270
[  357.854334][ T1000] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  357.855703][ T1000] RIP: 0010:__alloc_pages_nodemask+0x2f3/0x740
[  357.856669][ T1000] Code: 64 fe ff ff 65 48 8b 04 25 c0 0f 02 00 48 05 f0 12 00 00 41 be 01 00 00 00 49 89 47 0
[  357.860272][ T1000] RSP: 0018:ffff8880b7f47bd8 EFLAGS: 00010246
[  357.861009][ T1000] RAX: ffffed1016fe8f80 RBX: 1ffff11016fe8fae RCX: 0000000000000000
[  357.861843][ T1000] RDX: 0000000000000000 RSI: 0000000000000017 RDI: 0000000000000000
[  357.862661][ T1000] RBP: 0000000000040dc0 R08: 1ffff11016fe8f67 R09: dffffc0000000000
[  357.863509][ T1000] R10: ffff8880b7f47d68 R11: fffffbfff2798180 R12: 1ffff11016fe8f80
[  357.864355][ T1000] R13: 0000000000000017 R14: 0000000000000017 R15: ffff8880c2038d68
[  357.865178][ T1000] FS:  00007fd9a5b8c740(0000) GS:ffff8880d9c00000(0000) knlGS:0000000000000000
[  357.866248][ T1000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  357.867531][ T1000] CR2: 000055ce01ba8100 CR3: 00000000b7dbe005 CR4: 00000000000606f0
[  357.868972][ T1000] Call Trace:
[  357.869423][ T1000]  ? lock_contended+0xcd0/0xcd0
[  357.870001][ T1000]  ? __alloc_pages_slowpath+0x21d0/0x21d0
[  357.870673][ T1000]  ? _kstrtoull+0x76/0x160
[  357.871148][ T1000]  ? alloc_pages_current+0xc1/0x1a0
[  357.871704][ T1000]  kmalloc_order+0x22/0x80
[  357.872184][ T1000]  kmalloc_order_trace+0x1d/0x140
[  357.872733][ T1000]  __kmalloc+0x302/0x3a0
[  357.873204][ T1000]  nsim_bus_dev_numvfs_store+0x1ab/0x260 [netdevsim]
[  357.873919][ T1000]  ? kernfs_get_active+0x12c/0x180
[  357.874459][ T1000]  ? new_device_store+0x450/0x450 [netdevsim]
[  357.875111][ T1000]  ? kernfs_get_parent+0x70/0x70
[  357.875632][ T1000]  ? sysfs_file_ops+0x160/0x160
[  357.876152][ T1000]  kernfs_fop_write+0x276/0x410
[  357.876680][ T1000]  ? __sb_start_write+0x1ba/0x2e0
[  357.877225][ T1000]  vfs_write+0x197/0x4a0
[  357.877671][ T1000]  ksys_write+0x141/0x1d0
[ ... ]

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Fixes: 79579220566c ("netdevsim: add SR-IOV functionality")
Fixes: 82c93a87bf8b ("netdevsim: implement couple of testing devlink health reporters")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/netdevsim/bus.c    |    2 +-
 drivers/net/netdevsim/health.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -29,7 +29,7 @@ static int nsim_bus_dev_vfs_enable(struc
 {
 	nsim_bus_dev->vfconfigs = kcalloc(num_vfs,
 					  sizeof(struct nsim_vf_config),
-					  GFP_KERNEL);
+					  GFP_KERNEL | __GFP_NOWARN);
 	if (!nsim_bus_dev->vfconfigs)
 		return -ENOMEM;
 	nsim_bus_dev->num_vfs = num_vfs;
--- a/drivers/net/netdevsim/health.c
+++ b/drivers/net/netdevsim/health.c
@@ -82,7 +82,7 @@ static int nsim_dev_dummy_fmsg_put(struc
 	if (err)
 		return err;
 
-	binary = kmalloc(binary_len, GFP_KERNEL);
+	binary = kmalloc(binary_len, GFP_KERNEL | __GFP_NOWARN);
 	if (!binary)
 		return -ENOMEM;
 	get_random_bytes(binary, binary_len);


