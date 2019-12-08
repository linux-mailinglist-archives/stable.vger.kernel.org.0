Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00E501161BD
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 14:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfLHNyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 08:54:38 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59910 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725939AbfLHNyi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 08:54:38 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1A-0007d0-K0; Sun, 08 Dec 2019 13:54:36 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1A-0002KY-86; Sun, 08 Dec 2019 13:54:36 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Mark Brown" <broonie@kernel.org>,
        "Jean-Michel Hautbois" <jhautbois@gmail.com>,
        "Jean-Michel Hautbois" <jean-michel.hautbois@veo-labs.com>
Date:   Sun, 08 Dec 2019 13:52:46 +0000
Message-ID: <lsq.1575813165.808531661@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 02/72] ASoC: sgtl5000: fix VAG power up timing
In-Reply-To: <lsq.1575813164.154362148@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.79-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Michel Hautbois <jhautbois@gmail.com>

commit c803cc2dcd722e08020c1ba63bb5ceece4a19fdb upstream.

When power up, a "pop" is heard on line-in and mic-in.
An analysis of the PCM shows it lasts ~400ms
and looks like a filter response.
VAG power up should be delayed by 400ms as VAG power down is.

Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/soc/codecs/sgtl5000.c | 1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -175,6 +175,7 @@ static int power_vag_event(struct snd_so
 	case SND_SOC_DAPM_POST_PMU:
 		snd_soc_update_bits(w->codec, SGTL5000_CHIP_ANA_POWER,
 			SGTL5000_VAG_POWERUP, SGTL5000_VAG_POWERUP);
+		msleep(400);
 		break;
 
 	case SND_SOC_DAPM_PRE_PMD:

