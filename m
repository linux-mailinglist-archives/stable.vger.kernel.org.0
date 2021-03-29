Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 708E334CAD3
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbhC2IkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:40:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234575AbhC2IjS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:39:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62AA561990;
        Mon, 29 Mar 2021 08:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007146;
        bh=eB0f3E9CYhRZX991dzExvF66ssWPY14C7K+Ls8IDR2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TUb/A3oS6CPsgsRYAPxSxqaraayCqif3/07bsfKwpK+fXc47Mnre3SKmx1DwUvG98
         wapgY4Hf8L9VMLEZkvEn7S2+felv6IRnC2o8FwGgKfvpgO6ZMZDqUa980WbuCHvmJO
         ioKVm3nnJoiLjfUeYOHP4mpcuzW4PBLKRPKmhRL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Tong Zhang <ztong0001@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 203/254] mfd: intel_quark_i2c_gpio: Revert "Constify static struct resources"
Date:   Mon, 29 Mar 2021 09:58:39 +0200
Message-Id: <20210329075639.772545376@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit a61f4661fba404418a7c77e86586dc52a58a93c6 ]

The structures are used as place holders, so they are modified at run-time.
Obviously they may not be constants.

  BUG: unable to handle page fault for address: d0643220
  ...
  CPU: 0 PID: 110 Comm: modprobe Not tainted 5.11.0+ #1
  Hardware name: Intel Corp. QUARK/GalileoGen2, BIOS 0x01000200 01/01/2014
  EIP: intel_quark_mfd_probe+0x93/0x1c0 [intel_quark_i2c_gpio]

This partially reverts the commit c4a164f41554d2899bed94bdcc499263f41787b4.

While at it, add a comment to avoid similar changes in the future.

Fixes: c4a164f41554 ("mfd: Constify static struct resources")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Tested-by: Tong Zhang <ztong0001@gmail.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/intel_quark_i2c_gpio.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/intel_quark_i2c_gpio.c b/drivers/mfd/intel_quark_i2c_gpio.c
index fe8ca945f367..b67cb0a3ab05 100644
--- a/drivers/mfd/intel_quark_i2c_gpio.c
+++ b/drivers/mfd/intel_quark_i2c_gpio.c
@@ -72,7 +72,8 @@ static const struct dmi_system_id dmi_platform_info[] = {
 	{}
 };
 
-static const struct resource intel_quark_i2c_res[] = {
+/* This is used as a place holder and will be modified at run-time */
+static struct resource intel_quark_i2c_res[] = {
 	[INTEL_QUARK_IORES_MEM] = {
 		.flags = IORESOURCE_MEM,
 	},
@@ -85,7 +86,8 @@ static struct mfd_cell_acpi_match intel_quark_acpi_match_i2c = {
 	.adr = MFD_ACPI_MATCH_I2C,
 };
 
-static const struct resource intel_quark_gpio_res[] = {
+/* This is used as a place holder and will be modified at run-time */
+static struct resource intel_quark_gpio_res[] = {
 	[INTEL_QUARK_IORES_MEM] = {
 		.flags = IORESOURCE_MEM,
 	},
-- 
2.30.1



