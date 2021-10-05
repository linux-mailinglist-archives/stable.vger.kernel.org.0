Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D5B422867
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235250AbhJENw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:52:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235302AbhJENwV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:52:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 789D961244;
        Tue,  5 Oct 2021 13:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633441831;
        bh=AXytzKMUE1DPWebMn1FnjSeiu0njVB7PhvTjMrtxGB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kvjebn3YjDBkTmesrYqZCOSECepzM9mq0f0/Dtjnf4nNC1jmgP+GQ+TJJO9x9T81A
         RVnwU9LZpSaOFbVJHplFZJNe7/QArvEifGFlh0+FsSdGvCtu06Kyy31vwKEAeuij8W
         POeVw8Yn20/06TNcbRGixiN7iI0RWkkwCVK7AptmanaeGI0SdHZpzOTjUXiUf0q1/f
         l8VStXrkoXlHuUzYuwPvvndudYWunPyOxvMgMH42tKtsoapf/BE0C2kqg7w9OTvkab
         91W4oFKJg63XYm2r2VMb6r0HOxtLNazvm1bIpLxOhC2/5NmMjQn+GEdN/cXgKtV7Jj
         yvPWUKHhGFvug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        clemens@ladisch.de, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.14 05/40] ALSA: oxfw: fix transmission method for Loud models based on OXFW971
Date:   Tue,  5 Oct 2021 09:49:44 -0400
Message-Id: <20211005135020.214291-5-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135020.214291-1-sashal@kernel.org>
References: <20211005135020.214291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit 64794d6db49730d22f440aef0cf4da98a56a4ea3 ]

Loud Technologies Mackie Onyx 1640i (former model) is identified as
the model which uses OXFW971. The analysis of packet dump shows that
it transfers events in blocking method of IEC 61883-6, however the
default behaviour of ALSA oxfw driver is for non-blocking method.

This commit adds code to detect it assuming that all of loud models
based on OXFW971 have such quirk. It brings no functional change
except for alignment rule of PCM buffer.

Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20210913021042.10085-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/firewire/oxfw/oxfw.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/sound/firewire/oxfw/oxfw.c b/sound/firewire/oxfw/oxfw.c
index cb5b5e3a481b..daf731364695 100644
--- a/sound/firewire/oxfw/oxfw.c
+++ b/sound/firewire/oxfw/oxfw.c
@@ -184,13 +184,16 @@ static int detect_quirks(struct snd_oxfw *oxfw, const struct ieee1394_device_id
 			model = val;
 	}
 
-	/*
-	 * Mackie Onyx Satellite with base station has a quirk to report a wrong
-	 * value in 'dbs' field of CIP header against its format information.
-	 */
-	if (vendor == VENDOR_LOUD && model == MODEL_SATELLITE)
+	if (vendor == VENDOR_LOUD) {
+		// Mackie Onyx Satellite with base station has a quirk to report a wrong
+		// value in 'dbs' field of CIP header against its format information.
 		oxfw->quirks |= SND_OXFW_QUIRK_WRONG_DBS;
 
+		// OXFW971-based models may transfer events by blocking method.
+		if (!(oxfw->quirks & SND_OXFW_QUIRK_JUMBO_PAYLOAD))
+			oxfw->quirks |= SND_OXFW_QUIRK_BLOCKING_TRANSMISSION;
+	}
+
 	return 0;
 }
 
-- 
2.33.0

