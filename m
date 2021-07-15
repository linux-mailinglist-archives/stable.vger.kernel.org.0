Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375B73CAAE5
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241609AbhGOTP6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:15:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:51090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244624AbhGOTO7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:14:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F15261408;
        Thu, 15 Jul 2021 19:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376253;
        bh=a9XVL2KJ0JroVTPxy1S9ksp1mr+U+sM7H6KVZIxwG1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C3ClqWWXebZkboT4Q/d6c0iV5rtCbX6RwrwCS9v8NiJVO/gIB832rKh7h2qW+WuB7
         ScD064D/AyZSUw/YeKhnifnKtVm2YKECxIDFx2Dd65bSKHWsB4GAQAc2QQ8r86rYvg
         SOwGOAR83A/Lpb1h8/ZKzIYhhBcpmSnmqmlZe1gQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianmin Lv <lvjianmin@loongson.cn>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.13 191/266] drm/radeon: Call radeon_suspend_kms() in radeon_pci_shutdown() for Loongson64
Date:   Thu, 15 Jul 2021 20:39:06 +0200
Message-Id: <20210715182644.634870525@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit c1bfd74bfef77bcefc88d12eaf8996c0dfd51331 upstream.

On the Loongson64 platform used with Radeon GPU, shutdown or reboot failed
when console=tty is in the boot cmdline.

radeon_suspend_kms() puts the hw in the suspend state, especially set fb
state as FBINFO_STATE_SUSPENDED:

        if (fbcon) {
                console_lock();
                radeon_fbdev_set_suspend(rdev, 1);
                console_unlock();
        }

Then avoid to do any more fb operations in the related functions:

        if (p->state != FBINFO_STATE_RUNNING)
                return;

So call radeon_suspend_kms() in radeon_pci_shutdown() for Loongson64 to fix
this issue, it looks like some kind of workaround like powerpc.

Co-developed-by: Jianmin Lv <lvjianmin@loongson.cn>
Signed-off-by: Jianmin Lv <lvjianmin@loongson.cn>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_drv.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -386,13 +386,13 @@ radeon_pci_shutdown(struct pci_dev *pdev
 	if (radeon_device_is_virtual())
 		radeon_pci_remove(pdev);
 
-#ifdef CONFIG_PPC64
+#if defined(CONFIG_PPC64) || defined(CONFIG_MACH_LOONGSON64)
 	/*
 	 * Some adapters need to be suspended before a
 	 * shutdown occurs in order to prevent an error
-	 * during kexec.
-	 * Make this power specific becauase it breaks
-	 * some non-power boards.
+	 * during kexec, shutdown or reboot.
+	 * Make this power and Loongson specific because
+	 * it breaks some other boards.
 	 */
 	radeon_suspend_kms(pci_get_drvdata(pdev), true, true, false);
 #endif


