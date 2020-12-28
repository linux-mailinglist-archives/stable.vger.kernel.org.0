Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F162E3EB9
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504212AbgL1Ob6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:31:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:39562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504567AbgL1Obi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:31:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24F9720731;
        Mon, 28 Dec 2020 14:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165882;
        bh=wWdwbggOAEpP2APycyx8kFOaofaTw6L3Q2Oc8VRWULA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uGWmlnqdfXG6TFEA77ZXelXwognAftcwG55PvcveIt9/mdWoNX3J5iqs98B16cBJa
         p7Nxu3Fn0Fsqjlc3h2zg+FNdljWaISkSIpruy1lW3jFAvPLLP4GbLSNypR/ZwBEkYb
         8e/qQWovvnvKPXxYfSQHUCFDQV0f35OBTBaohzp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Terry Zhou <bjzhou@marvell.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.10 689/717] clk: mvebu: a3700: fix the XTAL MODE pin to MPP1_9
Date:   Mon, 28 Dec 2020 13:51:27 +0100
Message-Id: <20201228125053.983903049@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
@@ -13,8 +13,8 @@
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 
-#define NB_GPIO1_LATCH	0xC
-#define XTAL_MODE	    BIT(31)
+#define NB_GPIO1_LATCH	0x8
+#define XTAL_MODE	    BIT(9)
 
 static int armada_3700_xtal_clock_probe(struct platform_device *pdev)
 {


