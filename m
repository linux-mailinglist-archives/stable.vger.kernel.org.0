Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D500F27287D
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 16:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727871AbgIUOnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 10:43:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:49348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727856AbgIUOkm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 10:40:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52483221EC;
        Mon, 21 Sep 2020 14:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600699241;
        bh=lf35bmvkVf58PLzv2uXzL4aMrtSeqejjPYhEr5ev3Wc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C65I3KKaWvQ5pT9lmTTkPmpVDhLdqawKwUlXNU8J3F+afFwgYuV5d7+O6Kg3nzKDY
         K9rMVopF2rXtNzKrVq2JtHlmWMGZQ3+jYQer6bSaYnWik8KV9SiumODHMM+JAosMda
         CCG4jmpOl29ThNzFkxPhdCSZDEHnt/y4IVqiyxwQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>,
        linux-edac@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 11/20] EDAC/ghes: Check whether the driver is on the safe list correctly
Date:   Mon, 21 Sep 2020 10:40:18 -0400
Message-Id: <20200921144027.2135390-11-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921144027.2135390-1-sashal@kernel.org>
References: <20200921144027.2135390-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit 251c54ea26fa6029b01a76161a37a12fde5124e4 ]

With CONFIG_DEBUG_TEST_DRIVER_REMOVE=y, a system would try to probe,
unregister and probe again a driver.

When ghes_edac is attempted to be loaded on a system which is not on
the safe platforms list, ghes_edac_register() would return early. The
unregister counterpart ghes_edac_unregister() would still attempt to
unregister and exit early at the refcount test, leading to the refcount
underflow below.

In order to not do *anything* on the unregister path too, reuse the
force_load parameter and check it on that path too, before fumbling with
the refcount.

  ghes_edac: ghes_edac_register: entry
  ghes_edac: ghes_edac_register: return -ENODEV
  ------------[ cut here ]------------
  refcount_t: underflow; use-after-free.
  WARNING: CPU: 10 PID: 1 at lib/refcount.c:28 refcount_warn_saturate+0xb9/0x100
  Modules linked in:
  CPU: 10 PID: 1 Comm: swapper/0 Not tainted 5.9.0-rc4+ #12
  Hardware name: GIGABYTE MZ01-CE1-00/MZ01-CE1-00, BIOS F02 08/29/2018
  RIP: 0010:refcount_warn_saturate+0xb9/0x100
  Code: 82 e8 fb 8f 4d 00 90 0f 0b 90 90 c3 80 3d 55 4c f5 00 00 75 88 c6 05 4c 4c f5 00 01 90 48 c7 c7 d0 8a 10 82 e8 d8 8f 4d 00 90 <0f> 0b 90 90 c3 80 3d 30 4c f5 00 00 0f 85 61 ff ff ff c6 05 23 4c
  RSP: 0018:ffffc90000037d58 EFLAGS: 00010292
  RAX: 0000000000000026 RBX: ffff88840b8da000 RCX: 0000000000000000
  RDX: 0000000000000001 RSI: ffffffff8216b24f RDI: 00000000ffffffff
  RBP: ffff88840c662e00 R08: 0000000000000001 R09: 0000000000000001
  R10: 0000000000000001 R11: 0000000000000046 R12: 0000000000000000
  R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
  FS:  0000000000000000(0000) GS:ffff88840ee80000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000000 CR3: 0000800002211000 CR4: 00000000003506e0
  Call Trace:
   ghes_edac_unregister
   ghes_remove
   platform_drv_remove
   really_probe
   driver_probe_device
   device_driver_attach
   __driver_attach
   ? device_driver_attach
   ? device_driver_attach
   bus_for_each_dev
   bus_add_driver
   driver_register
   ? bert_init
   ghes_init
   do_one_initcall
   ? rcu_read_lock_sched_held
   kernel_init_freeable
   ? rest_init
   kernel_init
   ret_from_fork
   ...
  ghes_edac: ghes_edac_unregister: FALSE, refcount: -1073741824

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20200911164950.GB19320@zn.tnic
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/ghes_edac.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/edac/ghes_edac.c b/drivers/edac/ghes_edac.c
index cb3dab56a875d..efad23575b16b 100644
--- a/drivers/edac/ghes_edac.c
+++ b/drivers/edac/ghes_edac.c
@@ -469,6 +469,7 @@ int ghes_edac_register(struct ghes *ghes, struct device *dev)
 		if (!force_load && idx < 0)
 			return -ENODEV;
 	} else {
+		force_load = true;
 		idx = 0;
 	}
 
@@ -566,6 +567,9 @@ void ghes_edac_unregister(struct ghes *ghes)
 	struct mem_ctl_info *mci;
 	unsigned long flags;
 
+	if (!force_load)
+		return;
+
 	mutex_lock(&ghes_reg_mutex);
 
 	if (!refcount_dec_and_test(&ghes_refcount))
-- 
2.25.1

