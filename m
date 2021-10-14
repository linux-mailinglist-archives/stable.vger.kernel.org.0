Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57E5542DD6B
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 17:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232576AbhJNPHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:07:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:52934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232616AbhJNPFf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:05:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B92AB61205;
        Thu, 14 Oct 2021 15:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223678;
        bh=AXytzKMUE1DPWebMn1FnjSeiu0njVB7PhvTjMrtxGB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YuXiIUPFIzCC2f6Ulx32DD0wwYOOshc4F7hq/btc8krv1qlqBOcpiOc4sSa1Oz1Hg
         Tk2DrZyGD2jvVsG6FWbbVi+n7IorZxPe2kvQmTYNnYoxveyPbuPmZH9myr52rcm/iD
         JMi+eYYx2hLL0bEUSk8ol+OXw+KX0oQUJfqbnau8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 04/30] ALSA: oxfw: fix transmission method for Loud models based on OXFW971
Date:   Thu, 14 Oct 2021 16:54:09 +0200
Message-Id: <20211014145209.665921684@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145209.520017940@linuxfoundation.org>
References: <20211014145209.520017940@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



