Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3AF28C94A
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727727AbfHNCiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:38:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727049AbfHNCMc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:12:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E040120842;
        Wed, 14 Aug 2019 02:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748751;
        bh=NlHU82DlmLqWkVkS9Vy2WOY0Hhh5fRJvgAZNlvSeoc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GVcpub19K1s54t7S22C5DakVQ1Dwn5jGanko+7x7EEsTNwRT6OsDjrtTe90+MxT3D
         y6aIDskb+oprYrkodBNVYEJR0rNjSOXo9Y7uJ6G1+GGYOnrbujCHywIUfhDTTqBQFj
         NK7VII8JJvY10duFUL7iDQlGHtrQsMd0e5ryrWz4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 046/123] ASoC: ti: davinci-mcasp: Fix clk PDIR handling for i2s master mode
Date:   Tue, 13 Aug 2019 22:09:30 -0400
Message-Id: <20190814021047.14828-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

[ Upstream commit 34a2a80ff30b5d2330abfa8980c7f0cc15a8158a ]

When running McASP as master capture alone will not record any audio unless
a parallel playback stream is running. As soon as the playback stops the
captured data is going to be silent again.

In McASP master mode we need to set the PDIR for the clock pins and fix
the mcasp_set_axr_pdir() to skip the bits in the PDIR registers above
AMUTE.

This went unnoticed as most of the boards uses McASP as slave and neither
of these issues are visible (audible) in those setups.

Fixes: ca3d9433349e ("ASoC: davinci-mcasp: Update PDIR (pin direction) register handling")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Link: https://lore.kernel.org/r/20190725083423.7321-1-peter.ujfalusi@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ti/davinci-mcasp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/ti/davinci-mcasp.c b/sound/soc/ti/davinci-mcasp.c
index 5e8e31743a28d..dc01bbca0ff69 100644
--- a/sound/soc/ti/davinci-mcasp.c
+++ b/sound/soc/ti/davinci-mcasp.c
@@ -194,7 +194,7 @@ static inline void mcasp_set_axr_pdir(struct davinci_mcasp *mcasp, bool enable)
 {
 	u32 bit;
 
-	for_each_set_bit(bit, &mcasp->pdir, PIN_BIT_AFSR) {
+	for_each_set_bit(bit, &mcasp->pdir, PIN_BIT_AMUTE) {
 		if (enable)
 			mcasp_set_bits(mcasp, DAVINCI_MCASP_PDIR_REG, BIT(bit));
 		else
@@ -222,6 +222,7 @@ static void mcasp_start_rx(struct davinci_mcasp *mcasp)
 	if (mcasp_is_synchronous(mcasp)) {
 		mcasp_set_ctl_reg(mcasp, DAVINCI_MCASP_GBLCTLX_REG, TXHCLKRST);
 		mcasp_set_ctl_reg(mcasp, DAVINCI_MCASP_GBLCTLX_REG, TXCLKRST);
+		mcasp_set_clk_pdir(mcasp, true);
 	}
 
 	/* Activate serializer(s) */
-- 
2.20.1

