Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63E5CBAAA2
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbfIVT2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:28:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729132AbfIVSub (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:50:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25A2F21479;
        Sun, 22 Sep 2019 18:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178230;
        bh=ufCxlYih7f2BTY3citJyH0LrsP6e39X6bAtXZZ5e8TA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WwC+UEad0FdkP0N+Ho1ng/A4EE61rpr71PBTUqeY+dHyrXBRD3jpIzMSBo6tPX0Wo
         omfRGx3ionQauPwM6V0Z1Fjr5LyKsmLLpgEM8qe/quZRFY/BfDPIRLPcu+BtGzr9xy
         q8NlXkru2dEZFg1PTjR+/N6owGfVBfYn3Kpk9Oeg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 029/185] ALSA: hda - Show the fatal CORB/RIRB error more clearly
Date:   Sun, 22 Sep 2019 14:46:47 -0400
Message-Id: <20190922184924.32534-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit dd65f7e19c6961ba6a69f7c925021b7a270cb950 ]

The last fallback of CORB/RIRB communication error recovery is to turn
on the single command mode, and this last resort usually means that
something is really screwed up.  Instead of a normal dev_err(), show
the error more clearly with dev_WARN() with the caller stack trace.

Also, show the bus-reset fallback also as an error, too.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_controller.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_controller.c b/sound/pci/hda/hda_controller.c
index dd96def48a3a1..1158bcf551488 100644
--- a/sound/pci/hda/hda_controller.c
+++ b/sound/pci/hda/hda_controller.c
@@ -869,10 +869,13 @@ static int azx_rirb_get_response(struct hdac_bus *bus, unsigned int addr,
 	 */
 	if (hbus->allow_bus_reset && !hbus->response_reset && !hbus->in_reset) {
 		hbus->response_reset = 1;
+		dev_err(chip->card->dev,
+			"No response from codec, resetting bus: last cmd=0x%08x\n",
+			bus->last_cmd[addr]);
 		return -EAGAIN; /* give a chance to retry */
 	}
 
-	dev_err(chip->card->dev,
+	dev_WARN(chip->card->dev,
 		"azx_get_response timeout, switching to single_cmd mode: last cmd=0x%08x\n",
 		bus->last_cmd[addr]);
 	chip->single_cmd = 1;
-- 
2.20.1

