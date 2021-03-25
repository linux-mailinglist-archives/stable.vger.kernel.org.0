Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAC4348FFA
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbhCYLbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:31:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231384AbhCYL3W (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:29:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B367861A42;
        Thu, 25 Mar 2021 11:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671651;
        bh=5K42GOL0CTGzkR5Zq2OyJCjPN5ux3s+opHFWr23aX4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NxaNLRXLYo0pUcK0AcRdkU7wPAaGWZr7iM4u2xAxvHXpwMKjuBtkrbJ5UL3YO5Kdh
         bFJ41XUbkRtXICourSNH3bCYnMEC6OvLdlCce1SPwb/G9U8dgbUp6HaCd4ixcQU9Jq
         LGZNeXlEax+Ie0GZMONVvTJLAAF3n7VcFB86fzgR33HoaHo6cfl0i4GYDPlXU+1Fh3
         bWpcLJryujukzOlwo5cj323VAua37FBi8wf2SYhruW+qyOM45Q8g02lqRBPxuFsJr1
         Prv7tp/8c4Il16027VtDu/H+46FTqsutqPFj4svtMN6MiCR8rNYGpnsD7jSU12e0dT
         y3yjHz2RK9tXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benjamin Rood <benjaminjrood@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 05/20] ASoC: sgtl5000: set DAP_AVC_CTRL register to correct default value on probe
Date:   Thu, 25 Mar 2021 07:27:09 -0400
Message-Id: <20210325112724.1928174-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112724.1928174-1-sashal@kernel.org>
References: <20210325112724.1928174-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Rood <benjaminjrood@gmail.com>

[ Upstream commit f86f58e3594fb0ab1993d833d3b9a2496f3c928c ]

According to the SGTL5000 datasheet [1], the DAP_AVC_CTRL register has
the following bit field definitions:

| BITS  | FIELD       | RW | RESET | DEFINITION                        |
| 15    | RSVD        | RO | 0x0   | Reserved                          |
| 14    | RSVD        | RW | 0x1   | Reserved                          |
| 13:12 | MAX_GAIN    | RW | 0x1   | Max Gain of AVC in expander mode  |
| 11:10 | RSVD        | RO | 0x0   | Reserved                          |
| 9:8   | LBI_RESP    | RW | 0x1   | Integrator Response               |
| 7:6   | RSVD        | RO | 0x0   | Reserved                          |
| 5     | HARD_LMT_EN | RW | 0x0   | Enable hard limiter mode          |
| 4:1   | RSVD        | RO | 0x0   | Reserved                          |
| 0     | EN          | RW | 0x0   | Enable/Disable AVC                |

The original default value written to the DAP_AVC_CTRL register during
sgtl5000_i2c_probe() was 0x0510.  This would incorrectly write values to
bits 4 and 10, which are defined as RESERVED.  It would also not set
bits 12 and 14 to their correct RESET values of 0x1, and instead set
them to 0x0.  While the DAP_AVC module is effectively disabled because
the EN bit is 0, this default value is still writing invalid values to
registers that are marked as read-only and RESERVED as well as not
setting bits 12 and 14 to their correct default values as defined by the
datasheet.

The correct value that should be written to the DAP_AVC_CTRL register is
0x5100, which configures the register bits to the default values defined
by the datasheet, and prevents any writes to bits defined as
'read-only'.  Generally speaking, it is best practice to NOT attempt to
write values to registers/bits defined as RESERVED, as it generally
produces unwanted/undefined behavior, or errors.

Also, all credit for this patch should go to my colleague Dan MacDonald
<dmacdonald@curbellmedical.com> for finding this error in the first
place.

[1] https://www.nxp.com/docs/en/data-sheet/SGTL5000.pdf

Signed-off-by: Benjamin Rood <benjaminjrood@gmail.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Link: https://lore.kernel.org/r/20210219183308.GA2117@ubuntu-dev
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/sgtl5000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index 7c0a06b487f7..17255e9683f5 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -71,7 +71,7 @@ static const struct reg_default sgtl5000_reg_defaults[] = {
 	{ SGTL5000_DAP_EQ_BASS_BAND4,		0x002f },
 	{ SGTL5000_DAP_MAIN_CHAN,		0x8000 },
 	{ SGTL5000_DAP_MIX_CHAN,		0x0000 },
-	{ SGTL5000_DAP_AVC_CTRL,		0x0510 },
+	{ SGTL5000_DAP_AVC_CTRL,		0x5100 },
 	{ SGTL5000_DAP_AVC_THRESHOLD,		0x1473 },
 	{ SGTL5000_DAP_AVC_ATTACK,		0x0028 },
 	{ SGTL5000_DAP_AVC_DECAY,		0x0050 },
-- 
2.30.1

