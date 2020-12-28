Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE092E64F6
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390665AbgL1Nga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:36:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:36744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390523AbgL1Ng3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:36:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97D3620719;
        Mon, 28 Dec 2020 13:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162549;
        bh=2zswwcbAHBiiyXxKUukt8I2higsivO73El+lvUDkKBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uDgRUg7RlnrvK8kswsPPwCzGVhvr0Eewvm2LWAEgpDmURTns4tC7a53ZUo2LhTfDp
         CZ6Igab0FEMyW2JAJjZnqkj8D2A1qxRygHJGbXklyyaNEK8ZVkpIECXSZ1z/fAj61F
         Oc+IGhJ9GF8PbSGyhXiqnk+FY/H8a3Pys2TzEZLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Terry Zhou <bjzhou@marvell.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 4.19 337/346] clk: mvebu: a3700: fix the XTAL MODE pin to MPP1_9
Date:   Mon, 28 Dec 2020 13:50:56 +0100
Message-Id: <20201228124936.050125892@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Terry Zhou <bjzhou@marvell.com>

commit 6f37689cf6b38fff96de52e7f0d3e78f22803ba0 upstream.

There is an error in the current code that the XTAL MODE
pin was set to NB MPP1_31 which should be NB MPP1_9.
The latch register of NB MPP1_9 has different offset of 0x8.

Signed-off-by: Terry Zhou <bjzhou@marvell.com>
[pali: Fix pin name in commit message]
Signed-off-by: Pali Rohár <pali@kernel.org>
Fixes: 7ea8250406a6 ("clk: mvebu: Add the xtal clock for Armada 3700 SoC")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201106100039.11385-1-pali@kernel.org
Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/mvebu/armada-37xx-xtal.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/clk/mvebu/armada-37xx-xtal.c
+++ b/drivers/clk/mvebu/armada-37xx-xtal.c
@@ -15,8 +15,8 @@
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 
-#define NB_GPIO1_LATCH	0xC
-#define XTAL_MODE	    BIT(31)
+#define NB_GPIO1_LATCH	0x8
+#define XTAL_MODE	    BIT(9)
 
 static int armada_3700_xtal_clock_probe(struct platform_device *pdev)
 {


