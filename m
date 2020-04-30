Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF191BFBA8
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 16:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbgD3Nxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 09:53:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728802AbgD3Nxr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:53:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 740F024957;
        Thu, 30 Apr 2020 13:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254827;
        bh=2aLTZKLe+wSFrXeOLh7dOkpeYDowF5ZnL0QybDV3ROM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b23ajpo9jfZlUFJmtN3CNI5J+G3SFdyaZvnl69X/aIq3e9inTBcyeZjpGqN5ElH7y
         vJJXic4doANdzOyFQFb5BzIJuI5hhNUWY5GqzkK0QZzr21lJvum9AsN6dvKxyRe7fE
         +jb9Dn4Sfl3FrhGs2swj/AuFhrjEVCHb/bVsSV14=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matthias Blankertz <matthias.blankertz@cetitec.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 19/30] ASoC: rsnd: Fix "status check failed" spam for multi-SSI
Date:   Thu, 30 Apr 2020 09:53:14 -0400
Message-Id: <20200430135325.20762-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135325.20762-1-sashal@kernel.org>
References: <20200430135325.20762-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Blankertz <matthias.blankertz@cetitec.com>

[ Upstream commit 54cb6221688660670a2e430892d7f4e6370263b8 ]

Fix the rsnd_ssi_stop function to skip disabling the individual SSIs of
a multi-SSI setup, as the actual stop is performed by rsnd_ssiu_stop_gen2
- the same logic as in rsnd_ssi_start. The attempt to disable these SSIs
was harmless, but caused a "status check failed" message to be printed
for every SSI in the multi-SSI setup.
The disabling of interrupts is still performed, as they are enabled for
all SSIs in rsnd_ssi_init, but care is taken to not accidentally set the
EN bit for an SSI where it was not set by rsnd_ssi_start.

Signed-off-by: Matthias Blankertz <matthias.blankertz@cetitec.com>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/20200417153017.1744454-3-matthias.blankertz@cetitec.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rcar/ssi.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sh/rcar/ssi.c b/sound/soc/sh/rcar/ssi.c
index d5f663bb965f1..a6cf2ac223e42 100644
--- a/sound/soc/sh/rcar/ssi.c
+++ b/sound/soc/sh/rcar/ssi.c
@@ -566,10 +566,16 @@ static int rsnd_ssi_stop(struct rsnd_mod *mod,
 	 * Capture:  It might not receave data. Do nothing
 	 */
 	if (rsnd_io_is_play(io)) {
-		rsnd_mod_write(mod, SSICR, cr | EN);
+		rsnd_mod_write(mod, SSICR, cr | ssi->cr_en);
 		rsnd_ssi_status_check(mod, DIRQ);
 	}
 
+	/* In multi-SSI mode, stop is performed by setting ssi0129 in
+	 * SSI_CONTROL to 0 (in rsnd_ssio_stop_gen2). Do nothing here.
+	 */
+	if (rsnd_ssi_multi_slaves_runtime(io))
+		return 0;
+
 	/*
 	 * disable SSI,
 	 * and, wait idle state
-- 
2.20.1

