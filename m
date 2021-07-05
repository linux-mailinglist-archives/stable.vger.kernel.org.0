Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 722563BBBC2
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 12:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhGELCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 07:02:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231290AbhGELCR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 07:02:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6169761447;
        Mon,  5 Jul 2021 10:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625482781;
        bh=1ZbRRTzwJnZv5CuLlpX0aVMy1kthfBVzavQ4o73ikms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rpzs88YF15QbZl1yJKyrsODtFRjkBXhXj6s+s0rkHhQrYBDb8qA3WHQWjfSfNJIqS
         CvRouNK1KcUs3r8ZQ1uzUDH7QnfoEGzDNMGVtw8IgGb5s8RGV96Xb6cvlRAHqvc5W0
         RAxVTH0S7+Z8ESos8n8ViE0XDppPeb25zj9aAaTajQgfgc6N+fZ7llRDvlpB+t2BN/
         RkuFFdcQv44yYQLAgjX8b+IbYII3G5AA1+wBjsx+SuoHpA+4g0LG62jkttAJGOexq3
         u223H+fO+vH+CgOywCiVm1SDey+MB2n54eTDgxq+cprYK+vIEfAgVEmTscKHpgndx6
         1uyZY9yEK6VoA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        kernel test robot <lkp@intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 5/7] gpio: AMD8111 and TQMX86 require HAS_IOPORT_MAP
Date:   Mon,  5 Jul 2021 06:59:32 -0400
Message-Id: <20210705105934.1513188-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705105934.1513188-1-sashal@kernel.org>
References: <20210705105934.1513188-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.15-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.15-rc1
X-KernelTest-Deadline: 2021-07-07T10:59+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit c6414e1a2bd26b0071e2b9d6034621f705dfd4c0 ]

Both of these drivers use ioport_map(), so they need to
depend on HAS_IOPORT_MAP. Otherwise, they cannot be built
even with COMPILE_TEST on architectures without an ioport
implementation, such as ARCH=um.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index e3607ec4c2e8..fb365aef336b 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -1361,6 +1361,7 @@ config GPIO_TPS68470
 config GPIO_TQMX86
 	tristate "TQ-Systems QTMX86 GPIO"
 	depends on MFD_TQMX86 || COMPILE_TEST
+	depends on HAS_IOPORT_MAP
 	select GPIOLIB_IRQCHIP
 	help
 	  This driver supports GPIO on the TQMX86 IO controller.
@@ -1428,6 +1429,7 @@ menu "PCI GPIO expanders"
 config GPIO_AMD8111
 	tristate "AMD 8111 GPIO driver"
 	depends on X86 || COMPILE_TEST
+	depends on HAS_IOPORT_MAP
 	help
 	  The AMD 8111 south bridge contains 32 GPIO pins which can be used.
 
-- 
2.30.2

