Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D129345D0C7
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 00:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352469AbhKXXIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 18:08:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:51340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352455AbhKXXIc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 18:08:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E5096108F;
        Wed, 24 Nov 2021 23:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637795121;
        bh=FjEMQBF/YVLYxtX1PaSkmfvyKh6vcd89AH9QqHa68Kc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QPT3DSMr4a2/QY9jb7bDuFzzKk0HBx5h8d9aciqRbn6cttjcPVzx6C9KdXPDz+ixu
         5CI72Ub7pAehdtyf2vSJxE1nNZPNgrOtKOfUKnVvUydQwqvw4b0XioMzBIg+ICcpSJ
         F/wZpShiU8TlpE1BI3zaRVPNER8s5tnhIH1OBFfyYxWRqEgbpQyMYMvufgH8WC9XJZ
         RmzB39BXtSTl/tIyM7EQJrdtY8cCYjAb1FO/DYQB+LQ1MJP5MYKpYCPmECZCe0XFG6
         dEkqTT9dDvPaYMVqGFC5D0gClrnyXcNjvuNrPAOg8Vf0VXtyr/6nGHT36zah4+B4Wk
         QqF2Sr6p2BKqg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.19 09/20] PCI: aardvark: Fix compilation on s390
Date:   Thu, 25 Nov 2021 00:04:49 +0100
Message-Id: <20211124230500.27109-10-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124230500.27109-1-kabel@kernel.org>
References: <20211124230500.27109-1-kabel@kernel.org>
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
 drivers/pci/controller/pci-aardvark.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index d1bdd40d18fb..e79c2fd86f4e 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -9,7 +9,7 @@
  */
 
 #include <linux/delay.h>
-#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
-- 
2.32.0

