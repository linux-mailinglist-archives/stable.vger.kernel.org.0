Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52DE59E155
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730884AbfH0IL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:11:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726833AbfH0IBH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:01:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76E6B21872;
        Tue, 27 Aug 2019 08:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892866;
        bh=zq1uNPKinyJYge4bsychB7kvd71bQAuStkyBQJMgH6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eAYO3MiyUfC0QStOQKPHniuRAVXKZXTyDK0Hk0vFbQmZNiNUb7VaN0Hy6TIDSG9pt
         VfDfJ0vZwezffm3LgRJugVkV4VKseyGtyVDCW1gDvzY70WUpxr1KHoXtqmebUzn7C0
         DYghxx9NDfq/NlVfsWVL6ucHfn+TYhm3/3WLi82Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 041/162] ASoC: ti: davinci-mcasp: Fix clk PDIR handling for i2s master mode
Date:   Tue, 27 Aug 2019 09:49:29 +0200
Message-Id: <20190827072739.685598752@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



