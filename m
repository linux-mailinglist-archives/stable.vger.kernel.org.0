Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6773BBBE6
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 13:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbhGELDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 07:03:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231453AbhGELDM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 07:03:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83EEA613BD;
        Mon,  5 Jul 2021 11:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625482835;
        bh=JU91PN3HQaOuFJBqe/B9cryRUcTzYLhF6BbHDvNyEhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z0KP6GGDrP4R0YAwgdniTkjbLXUoTBbdeYOWJNQleShhqiqpMy0cAZ9DQP9LEe1by
         UaAeknIUOPRnzmY1foJhRC4AL3NOlKu87P35RmFuimYJd3x0XSauHsaP5BMcD3IWim
         na005XVdyPVEBo0KFtdb9oMOkAsBnxH6gjD3YJm9c236lcZQJRd8BDxq2BTyjS7QxZ
         jhnSOq8Ql7vAsh0rhhJgzUZ7cjyrPaGoDvKM4ZuNovzYx62lJV6exKj6EN6ESmHqYQ
         u3DYHJ4eT7LeqGWvpwMJ2Mk9aZtqNgCgnySI6nHBrWHy5EH/tkKPJ2EVl3Vv6xW9F2
         BT6xPoaEwXokQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        kernel test robot <lkp@intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 4/6] gpio: AMD8111 and TQMX86 require HAS_IOPORT_MAP
Date:   Mon,  5 Jul 2021 07:00:27 -0400
Message-Id: <20210705110029.1513384-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705110029.1513384-1-sashal@kernel.org>
References: <20210705110029.1513384-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.130-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.130-rc1
X-KernelTest-Deadline: 2021-07-07T11:00+00:00
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
index f9263426af03..ae414045a750 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -1232,6 +1232,7 @@ config GPIO_TPS68470
 config GPIO_TQMX86
 	tristate "TQ-Systems QTMX86 GPIO"
 	depends on MFD_TQMX86 || COMPILE_TEST
+	depends on HAS_IOPORT_MAP
 	select GPIOLIB_IRQCHIP
 	help
 	  This driver supports GPIO on the TQMX86 IO controller.
@@ -1299,6 +1300,7 @@ menu "PCI GPIO expanders"
 config GPIO_AMD8111
 	tristate "AMD 8111 GPIO driver"
 	depends on X86 || COMPILE_TEST
+	depends on HAS_IOPORT_MAP
 	help
 	  The AMD 8111 south bridge contains 32 GPIO pins which can be used.
 
-- 
2.30.2

