Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30354144F41
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731617AbgAVJgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:36:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:51440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731615AbgAVJgD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:36:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 666D220704;
        Wed, 22 Jan 2020 09:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685762;
        bh=S2v/Klpj2hI2AgKj+OlwUrCMOKk0vPEvO5fPVW23H/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SPONDFfaq5hRvu0dGMZuJGILE8gGHJhOZS6oQRLeTOY9rw0zaq5EGLS0+Mdm1k1oM
         RYsLI/lhFrSyZmS+JO+7bp3q4yJ1kcyyn47+4Qs1sgNAb3brBrR6gcJMsiZOM8VOfQ
         YmQf3y9ckeirn0siBf8vxNMbdS8cNKWac85yEkpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerome Brunet <jbrunet@baylibre.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 4.9 52/97] clk: Dont try to enable critical clocks if prepare failed
Date:   Wed, 22 Jan 2020 10:28:56 +0100
Message-Id: <20200122092804.859188251@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092755.678349497@linuxfoundation.org>
References: <20200122092755.678349497@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

commit 12ead77432f2ce32dea797742316d15c5800cb32 upstream.

The following traceback is seen if a critical clock fails to prepare.

bcm2835-clk 3f101000.cprman: plld: couldn't lock PLL
------------[ cut here ]------------
Enabling unprepared plld_per
WARNING: CPU: 1 PID: 1 at drivers/clk/clk.c:1014 clk_core_enable+0xcc/0x2c0
...
Call trace:
 clk_core_enable+0xcc/0x2c0
 __clk_register+0x5c4/0x788
 devm_clk_hw_register+0x4c/0xb0
 bcm2835_register_pll_divider+0xc0/0x150
 bcm2835_clk_probe+0x134/0x1e8
 platform_drv_probe+0x50/0xa0
 really_probe+0xd4/0x308
 driver_probe_device+0x54/0xe8
 device_driver_attach+0x6c/0x78
 __driver_attach+0x54/0xd8
...

Check return values from clk_core_prepare() and clk_core_enable() and
bail out if any of those functions returns an error.

Cc: Jerome Brunet <jbrunet@baylibre.com>
Fixes: 99652a469df1 ("clk: migrate the count of orphaned clocks at init")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lkml.kernel.org/r/20191225163429.29694-1-linux@roeck-us.net
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/clk.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -2448,11 +2448,17 @@ static int __clk_core_init(struct clk_co
 	if (core->flags & CLK_IS_CRITICAL) {
 		unsigned long flags;
 
-		clk_core_prepare(core);
+		ret = clk_core_prepare(core);
+		if (ret)
+			goto out;
 
 		flags = clk_enable_lock();
-		clk_core_enable(core);
+		ret = clk_core_enable(core);
 		clk_enable_unlock(flags);
+		if (ret) {
+			clk_core_unprepare(core);
+			goto out;
+		}
 	}
 
 	/*


