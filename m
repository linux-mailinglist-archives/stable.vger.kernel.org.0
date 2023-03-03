Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 748A46AA1BA
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbjCCVma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:42:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232099AbjCCVmC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:42:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56C164262;
        Fri,  3 Mar 2023 13:41:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0547A618C2;
        Fri,  3 Mar 2023 21:41:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400DDC433EF;
        Fri,  3 Mar 2023 21:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879692;
        bh=jAtidpuaujEU/MdsfTuilFqZ7n2O/Brc1NdJhzNg97A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MQST8L+EsRKrF53tEbWpV0ORqojqtWVKLhEvLhbFA5xlKuJ2KhvRms62GcfypxFDu
         96qOvSIdYmAYxRg3TGqPBJ8oRaKUJgv5gIrmKlOP76pFI4StbaMR7864TA87LCjKOI
         KxiilcqpxlhHFLmwPsMvrx7z1v7bVDkmQLQYqX0fJRyNmfVRDjXmZTkPZ3QS6kfFRz
         VaYgITB+AaR/fG3Dh3mZhbqvrx+S1usAt7FxO6NPQbg1aecIyXBhDYLl4+EfbG6uLI
         85TORmXcspN68TdWpDPLM2/XpR+4nHUu9jwPrd8Ye+8tdJAocZ/YStgbGv/NVyKWP1
         aEt120HstVuUA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Schnelle <svens@linux.ibm.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.2 15/64] tty: fix out-of-bounds access in tty_driver_lookup_tty()
Date:   Fri,  3 Mar 2023 16:40:17 -0500
Message-Id: <20230303214106.1446460-15-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214106.1446460-1-sashal@kernel.org>
References: <20230303214106.1446460-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit db4df8e9d79e7d37732c1a1b560958e8dadfefa1 ]

When specifying an invalid console= device like console=tty3270,
tty_driver_lookup_tty() returns the tty struct without checking
whether index is a valid number.

To reproduce:

qemu-system-x86_64 -enable-kvm -nographic -serial mon:stdio \
-kernel ../linux-build-x86/arch/x86/boot/bzImage \
-append "console=ttyS0 console=tty3270"

This crashes with:

[    0.770599] BUG: kernel NULL pointer dereference, address: 00000000000000ef
[    0.771265] #PF: supervisor read access in kernel mode
[    0.771773] #PF: error_code(0x0000) - not-present page
[    0.772609] Oops: 0000 [#1] PREEMPT SMP PTI
[    0.774878] RIP: 0010:tty_open+0x268/0x6f0
[    0.784013]  chrdev_open+0xbd/0x230
[    0.784444]  ? cdev_device_add+0x80/0x80
[    0.784920]  do_dentry_open+0x1e0/0x410
[    0.785389]  path_openat+0xca9/0x1050
[    0.785813]  do_filp_open+0xaa/0x150
[    0.786240]  file_open_name+0x133/0x1b0
[    0.786746]  filp_open+0x27/0x50
[    0.787244]  console_on_rootfs+0x14/0x4d
[    0.787800]  kernel_init_freeable+0x1e4/0x20d
[    0.788383]  ? rest_init+0xc0/0xc0
[    0.788881]  kernel_init+0x11/0x120
[    0.789356]  ret_from_fork+0x22/0x30

Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20221209112737.3222509-2-svens@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/tty_io.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 3149114bf130e..36fb945fdad48 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1224,14 +1224,16 @@ static struct tty_struct *tty_driver_lookup_tty(struct tty_driver *driver,
 {
 	struct tty_struct *tty;
 
-	if (driver->ops->lookup)
+	if (driver->ops->lookup) {
 		if (!file)
 			tty = ERR_PTR(-EIO);
 		else
 			tty = driver->ops->lookup(driver, file, idx);
-	else
+	} else {
+		if (idx >= driver->num)
+			return ERR_PTR(-EINVAL);
 		tty = driver->ttys[idx];
-
+	}
 	if (!IS_ERR(tty))
 		tty_kref_get(tty);
 	return tty;
-- 
2.39.2

