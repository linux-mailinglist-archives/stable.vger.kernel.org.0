Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010F52E67BC
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729811AbgL1NGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:06:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:33828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729749AbgL1NGu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:06:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E704207C9;
        Mon, 28 Dec 2020 13:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160794;
        bh=2zswwcbAHBiiyXxKUukt8I2higsivO73El+lvUDkKBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KG8QW2Rk/St+5fbNoen4YPsC1v5/07R+kmgoKen8ZNqi3uxTUqXW5fS/CDG7GDLS3
         Tu8XEEXX7CeeQNcRg8foVMMSBxBsKLNYi/nplRVDmUG++0IEDm1P6e6M0pe74p/YSo
         MF4ANO1czK2vE6sr5Onmv/hxlE7diJDbT1F3SXK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Terry Zhou <bjzhou@marvell.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 4.9 173/175] clk: mvebu: a3700: fix the XTAL MODE pin to MPP1_9
Date:   Mon, 28 Dec 2020 13:50:26 +0100
Message-Id: <20201228124901.612196612@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
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


