Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B30356AA445
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 23:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbjCCWZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 17:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233324AbjCCWZf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 17:25:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC14C59E42;
        Fri,  3 Mar 2023 14:18:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4522A61958;
        Fri,  3 Mar 2023 21:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CC3C4339E;
        Fri,  3 Mar 2023 21:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677880100;
        bh=nhI+dErhOR7W6KnBDPC6kIMB6vX+XedcG9dfbS8rOFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lg1BaQWruUui1mLJOkiED9eDAE1uJ8vQ1rt/F7SO/aOJlBTLiv1ddHMdO01kUTVLX
         O/RQtjuDBF/R6jDAX1+OBHSG1tAcb3e8+vV4NMVeLsYKinP07KjIzg1q3pa5HzhspN
         N2Q21tW5fTmIW76wIirgUWzOMnomRDRF7dk2uQvfSAHLE72VLXXanv9Ztc5fHxiTe2
         p+ElP/TBbR/z1B91X5CVwzJh+0EpzdvOuVmLK4sDdiCOD3EnJwLkrykaGaimkqiv/S
         0KgnycDruEa+XAWv43Ee+tdzjtnrHvQAmOlOacQ+HlBf58UHyg1ivjXmQG3VBYkyto
         Z6aZqgEMensyQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Schnelle <svens@linux.ibm.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 07/20] tty: fix out-of-bounds access in tty_driver_lookup_tty()
Date:   Fri,  3 Mar 2023 16:47:53 -0500
Message-Id: <20230303214806.1453287-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214806.1453287-1-sashal@kernel.org>
References: <20230303214806.1453287-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index ddfe873b5fccb..37c46c65a65f4 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1156,14 +1156,16 @@ static struct tty_struct *tty_driver_lookup_tty(struct tty_driver *driver,
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

