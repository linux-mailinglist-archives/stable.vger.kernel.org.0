Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED303B6A4F
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 23:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238383AbhF1V0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 17:26:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:36076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237973AbhF1VXf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 17:23:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB61561CFC;
        Mon, 28 Jun 2021 21:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624915269;
        bh=JU91PN3HQaOuFJBqe/B9cryRUcTzYLhF6BbHDvNyEhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R9+vt3ik2yYdoKn1xbY4jSbrgDwopw8QNLcI0vPYoXZiZog2RAS66jc89S7vdgBvE
         rIpFeR/bP9Qf5UMrYnHd+xCPVpPo7r88XnTtfcYhxKuPAc+XTJ3wAFyYOPuEQ3AqpV
         uGdNlxRPBL4npZm6ojw+xVaupoA1JjQtoCrTmgosNeEmZAfP/KsuyeSr9FqH115Du3
         6pW4z5eHKO2SNyFRfkyOzo1/VGEpKD5GAoMw9RJ8A5nkg/ajqprSpOAYiv2giK5c42
         zk3ja5SPxAwMkY65prHO86hsb1+pTB/X6V3/zLpK/kiF2JHt0Uiz3HXu6SpsMY7T9O
         16z6li2r8o0mw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        kernel test robot <lkp@intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 3/3] gpio: AMD8111 and TQMX86 require HAS_IOPORT_MAP
Date:   Mon, 28 Jun 2021 17:21:05 -0400
Message-Id: <20210628212105.43449-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628212105.43449-1-sashal@kernel.org>
References: <20210628212105.43449-1-sashal@kernel.org>
MIME-Version: 1.0
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

