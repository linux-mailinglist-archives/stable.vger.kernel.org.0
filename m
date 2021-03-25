Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 403E8348EFA
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhCYLZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:25:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229888AbhCYLZQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:25:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9D6C61A24;
        Thu, 25 Mar 2021 11:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671515;
        bh=pHeTvtFAzQVeP01Q/JbWzjJs02laMzIVma3Mu53P9+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nKw1Gm2bcK0L1kN6xro8O77dftgCrFFf8g5BRsukw9D/3AO+QvzHiX0XM+GGP0FkR
         cOGHdWvgdJ141JbKUF0tOuFzz4/Q/76imKu+ZbkGVYMCNCqq5bmKYhntdY0pGOGVpO
         iMS6BrMbJR3ZoAhHVsC/7urTYtIV4NJ9yBMEvrwFy5vhguOHdXa6rZC6OibbxIDc6I
         65fCEIbKMjWLOAjJ6C5U2PLPqEMTOGoF6y22XHKtI4DUNLI9LogROJF7cgxJk5fN4P
         QkjgqjHtZx6DXQ+pxxeL3DDdJGM1HI98QRIl+IG48d7Mqispq96TsLhYbdcqPtLXHP
         7FON768egX4rg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benjamin Rood <benjaminjrood@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.11 12/44] ASoC: sgtl5000: set DAP_AVC_CTRL register to correct default value on probe
Date:   Thu, 25 Mar 2021 07:24:27 -0400
Message-Id: <20210325112459.1926846-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112459.1926846-1-sashal@kernel.org>
References: <20210325112459.1926846-1-sashal@kernel.org>
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
index 4d6ff8114622..4c0e87e22b97 100644
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

