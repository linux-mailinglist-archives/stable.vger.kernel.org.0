Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AABD345D06C
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 23:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352207AbhKXWxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 17:53:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:47234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352323AbhKXWxP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 17:53:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2775861074;
        Wed, 24 Nov 2021 22:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637794205;
        bh=+6oRWEat2nhg5GbX0V+SgNq9qkeVe3nzCSidVOJW3iE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t+mgfRP74LdW1QELPd6jxrPhx924QHKrsh3MQ4lATQLBQdLsR15G1fXSk++V7BHbz
         AbFkP51ZAxtS8szr0yqAhWRMK4fef3y0V34kzEa/WFZz+4Ic70Vvi9LDpfGSp4TrMu
         uO5t2MJ9mrj+lZA+T8bxeCqGv2c3oEYwFpfryd4lB66f5moTfzcj/9J205pZBsd1ej
         nuJ4zPU8lGeHbJBZziS1HEVKUxFMuGzPPL9GPlD6uoi/tM1SM/Y1VyVMCBMClVuP9n
         pIIC3hDbHamDkLmScZKjMfyseLirmy0CNDUlR7tMFHqhl9NCp/h1CI1JqVhRAmZXId
         8tMyfX4TShhDA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.14 11/24] PCI: aardvark: Fix compilation on s390
Date:   Wed, 24 Nov 2021 23:49:20 +0100
Message-Id: <20211124224933.24275-12-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124224933.24275-1-kabel@kernel.org>
References: <20211124224933.24275-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit b32c012e4b98f0126aa327be2d1f409963057643 upstream.

Include linux/gpio/consumer.h instead of linux/gpio.h, as is said in the
latter file.

This was reported by kernel test bot when compiling for s390.

  drivers/pci/controller/pci-aardvark.c:350:2: error: implicit declaration of function 'gpiod_set_value_cansleep' [-Werror,-Wimplicit-function-declaration]
  drivers/pci/controller/pci-aardvark.c:1074:21: error: implicit declaration of function 'devm_gpiod_get_from_of_node' [-Werror,-Wimplicit-function-declaration]
  drivers/pci/controller/pci-aardvark.c:1076:14: error: use of undeclared identifier 'GPIOD_OUT_LOW'

Link: https://lore.kernel.org/r/202006211118.LxtENQfl%25lkp@intel.com
Link: https://lore.kernel.org/r/20200907111038.5811-2-pali@kernel.org
Fixes: 5169a9851daa ("PCI: aardvark: Issue PERST via GPIO")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Marek Behún <marek.behun@nic.cz>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/host/pci-aardvark.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/host/pci-aardvark.c b/drivers/pci/host/pci-aardvark.c
index acc04c4a37df..b3bce506d995 100644
--- a/drivers/pci/host/pci-aardvark.c
+++ b/drivers/pci/host/pci-aardvark.c
@@ -12,7 +12,7 @@
  */
 
 #include <linux/delay.h>
-#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
-- 
2.32.0

