Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC00913F54F
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390946AbgAPSza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:55:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:39780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389195AbgAPRHg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:07:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6D42205F4;
        Thu, 16 Jan 2020 17:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194455;
        bh=qvLxjJ+7RTcPVWEj5B8DKfhGrxf4MZTY7DMCPPaYJJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dHs/GFf0B7v90zh6Q1KzycrdrvIkQaAPnMWRa44V49qKRp6QHahPXsUdU8iTXZrEQ
         GHkWS8rUk9NqLTR3EhT4J+wG7sFMd/bQL5XFIsOPX2tNJM6Y/TIN1z6DfUX0dqDVoK
         l+qrQl3mSXpr6laMgkw5TXOqBhyS+VBXOrten8vE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jerome Brunet <jbrunet@baylibre.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-amlogic@lists.infradead.org, linux-clk@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 365/671] clk: meson: gxbb: no spread spectrum on mpll0
Date:   Thu, 16 Jan 2020 12:00:03 -0500
Message-Id: <20200116170509.12787-102-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 8925dbd03bb29b1b0de30ac4e02c18faf8ddc9db ]

The documentation says there is an SSEN bit on mpll0 but, after testing
it, no spread spectrum function appears to be enabled by this bit on any
of the MPLLs.

Let's remove it until we know more

Fixes: 1f737ffa13ef ("clk: meson: mpll: fix mpll0 fractional part ignored")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/meson/gxbb.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/clk/meson/gxbb.c b/drivers/clk/meson/gxbb.c
index b039909e03cf..38ffa51a5bad 100644
--- a/drivers/clk/meson/gxbb.c
+++ b/drivers/clk/meson/gxbb.c
@@ -650,11 +650,6 @@ static struct clk_regmap gxbb_mpll0_div = {
 			.shift   = 16,
 			.width   = 9,
 		},
-		.ssen = {
-			.reg_off = HHI_MPLL_CNTL,
-			.shift   = 25,
-			.width	 = 1,
-		},
 		.lock = &meson_clk_lock,
 	},
 	.hw.init = &(struct clk_init_data){
-- 
2.20.1

