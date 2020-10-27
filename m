Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFB229BF8F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1815564AbgJ0RDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:03:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1793636AbgJ0PHd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:07:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 805BD206E5;
        Tue, 27 Oct 2020 15:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811252;
        bh=9Ovlrj4OM/pomLA8ydzfg50H+uVhWjVsQ7tnqcprzn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jiOxBsDYV+tL6s39Mrtyeb8TU5833mKflz/rH1kHvNuZaU6Ocn8xA/MWWckm1KLDJ
         xQKAEsSZvXivJ6hc4qDOmHkmEJggPOA4Ixph89s39GVSNwsHXAZ/qOngMnhU+TE/Y2
         pjUSKIENRwDJo7tHEMuSWyRtLFxbdSB1OJu1sAno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Agner <stefan@agner.ch>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Anand Moon <linux.amoon@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 428/633] clk: meson: g12a: mark fclk_div2 as critical
Date:   Tue, 27 Oct 2020 14:52:51 +0100
Message-Id: <20201027135542.799434842@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Agner <stefan@agner.ch>

[ Upstream commit 2c4e80e06790cb49ad2603855d30c5aac2209c47 ]

On Amlogic Meson G12b platform, similar to fclk_div3, the fclk_div2
seems to be necessary for the system to operate correctly as well.

Typically, the clock also gets chosen by the eMMC peripheral. This
probably masked the problem so far. However, when booting from a SD
card the clock seems to get disabled which leads to a system freeze.

Let's mark this clock as critical, fixing boot from SD card on G12b
platforms.

Fixes: 085a4ea93d54 ("clk: meson: g12a: add peripheral clock controller")
Signed-off-by: Stefan Agner <stefan@agner.ch>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Tested-by: Anand Moon <linux.amoon@gmail.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/577e0129e8ee93972d92f13187ff4e4286182f67.1598629915.git.stefan@agner.ch
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/meson/g12a.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/clk/meson/g12a.c b/drivers/clk/meson/g12a.c
index 30c15766ebb16..05d032be15c8f 100644
--- a/drivers/clk/meson/g12a.c
+++ b/drivers/clk/meson/g12a.c
@@ -298,6 +298,17 @@ static struct clk_regmap g12a_fclk_div2 = {
 			&g12a_fclk_div2_div.hw
 		},
 		.num_parents = 1,
+		/*
+		 * Similar to fclk_div3, it seems that this clock is used by
+		 * the resident firmware and is required by the platform to
+		 * operate correctly.
+		 * Until the following condition are met, we need this clock to
+		 * be marked as critical:
+		 * a) Mark the clock used by a firmware resource, if possible
+		 * b) CCF has a clock hand-off mechanism to make the sure the
+		 *    clock stays on until the proper driver comes along
+		 */
+		.flags = CLK_IS_CRITICAL,
 	},
 };
 
-- 
2.25.1



