Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 621D85604C
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbfFZDqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:46:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728018AbfFZDqn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:46:43 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-90.mobile.att.net [107.77.172.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5872421743;
        Wed, 26 Jun 2019 03:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520801;
        bh=rofvzWsIBCAeGUFGJxZ/YQEGN7NmaGddgE4JIcTL0q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xJzQZaxmG07pT5JEAO832ywIodzzq1KIClRH1XboXgaudkM7RUG6OujZ3wtabHTEI
         cwf5vnImYygKM0yfg1N8SL08tqZqWHAYOudSGAB8O1vkrssHaawpZaFglTHl4oIo1T
         QJWe05/pZfDBrkSMY9k4DHBY66szAsuoytKebh/k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Axel Lin <axel.lin@ingics.com>,
        Mukesh Ojha <mojha@codeaurora.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 2/6] spi: bitbang: Fix NULL pointer dereference in spi_unregister_master
Date:   Tue, 25 Jun 2019 23:46:33 -0400
Message-Id: <20190626034637.24515-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626034637.24515-1-sashal@kernel.org>
References: <20190626034637.24515-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 5caaf29af5ca82d5da8bc1d0ad07d9e664ccf1d8 ]

If spi_register_master fails in spi_bitbang_start
because device_add failure, We should return the
error code other than 0, otherwise calling
spi_bitbang_stop may trigger NULL pointer dereference
like this:

BUG: KASAN: null-ptr-deref in __list_del_entry_valid+0x45/0xd0
Read of size 8 at addr 0000000000000000 by task syz-executor.0/3661

CPU: 0 PID: 3661 Comm: syz-executor.0 Not tainted 5.1.0+ #28
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
Call Trace:
 dump_stack+0xa9/0x10e
 ? __list_del_entry_valid+0x45/0xd0
 ? __list_del_entry_valid+0x45/0xd0
 __kasan_report+0x171/0x18d
 ? __list_del_entry_valid+0x45/0xd0
 kasan_report+0xe/0x20
 __list_del_entry_valid+0x45/0xd0
 spi_unregister_controller+0x99/0x1b0
 spi_lm70llp_attach+0x3ae/0x4b0 [spi_lm70llp]
 ? 0xffffffffc1128000
 ? klist_next+0x131/0x1e0
 ? driver_detach+0x40/0x40 [parport]
 port_check+0x3b/0x50 [parport]
 bus_for_each_dev+0x115/0x180
 ? subsys_dev_iter_exit+0x20/0x20
 __parport_register_driver+0x1f0/0x210 [parport]
 ? 0xffffffffc1150000
 do_one_initcall+0xb9/0x3b5
 ? perf_trace_initcall_level+0x270/0x270
 ? kasan_unpoison_shadow+0x30/0x40
 ? kasan_unpoison_shadow+0x30/0x40
 do_init_module+0xe0/0x330
 load_module+0x38eb/0x4270
 ? module_frob_arch_sections+0x20/0x20
 ? kernel_read_file+0x188/0x3f0
 ? find_held_lock+0x6d/0xd0
 ? fput_many+0x1a/0xe0
 ? __do_sys_finit_module+0x162/0x190
 __do_sys_finit_module+0x162/0x190
 ? __ia32_sys_init_module+0x40/0x40
 ? __mutex_unlock_slowpath+0xb4/0x3f0
 ? wait_for_completion+0x240/0x240
 ? vfs_write+0x160/0x2a0
 ? lockdep_hardirqs_off+0xb5/0x100
 ? mark_held_locks+0x1a/0x90
 ? do_syscall_64+0x14/0x2a0
 do_syscall_64+0x72/0x2a0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 702a4879ec33 ("spi: bitbang: Let spi_bitbang_start() take a reference to master")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Axel Lin <axel.lin@ingics.com>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bitbang.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bitbang.c b/drivers/spi/spi-bitbang.c
index 3aa9e6e3dac8..4ef54436b9d4 100644
--- a/drivers/spi/spi-bitbang.c
+++ b/drivers/spi/spi-bitbang.c
@@ -392,7 +392,7 @@ int spi_bitbang_start(struct spi_bitbang *bitbang)
 	if (ret)
 		spi_master_put(master);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(spi_bitbang_start);
 
-- 
2.20.1

