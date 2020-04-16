Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788921AC7C0
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408729AbgDPNy7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:54:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409064AbgDPNyy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:54:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A41C82076D;
        Thu, 16 Apr 2020 13:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045293;
        bh=akbKUhbtfBKfRWBbrLrWfpWB85pshxJLlbLzz96tEAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JY8mAemiKLLwSJtZF+RY4VuNcz5xV02o1JJKOosmjJ5vbECZGfb6BrCLILiGBhK6Z
         SNGZaHm5ui1jmmUXKRkIORcCyZd9qMvgKGFGxg8cRh+hvsMkC4L9KoVJGIp7tGBnfm
         3TEk0A2eiZinoIgBURe9z7FXQxS7XfPl0R8cxHCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.6 075/254] ALSA: ice1724: Fix invalid access for enumerated ctl items
Date:   Thu, 16 Apr 2020 15:22:44 +0200
Message-Id: <20200416131335.266828159@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit c47914c00be346bc5b48c48de7b0da5c2d1a296c upstream.

The access to Analog Capture Source control value implemented in
prodigy_hifi.c is wrong, as caught by the recently introduced sanity
check; it should be accessing value.enumerated.item[] instead of
value.integer.value[].  This patch corrects the wrong access pattern.

Fixes: 6b8d6e5518e2 ("[ALSA] ICE1724: Added support for Audiotrak Prodigy 7.1 HiFi & HD2, Hercules Fortissimo IV")
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=207139
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200407084402.25589-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/ice1712/prodigy_hifi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/ice1712/prodigy_hifi.c
+++ b/sound/pci/ice1712/prodigy_hifi.c
@@ -536,7 +536,7 @@ static int wm_adc_mux_enum_get(struct sn
 	struct snd_ice1712 *ice = snd_kcontrol_chip(kcontrol);
 
 	mutex_lock(&ice->gpio_mutex);
-	ucontrol->value.integer.value[0] = wm_get(ice, WM_ADC_MUX) & 0x1f;
+	ucontrol->value.enumerated.item[0] = wm_get(ice, WM_ADC_MUX) & 0x1f;
 	mutex_unlock(&ice->gpio_mutex);
 	return 0;
 }
@@ -550,7 +550,7 @@ static int wm_adc_mux_enum_put(struct sn
 
 	mutex_lock(&ice->gpio_mutex);
 	oval = wm_get(ice, WM_ADC_MUX);
-	nval = (oval & 0xe0) | ucontrol->value.integer.value[0];
+	nval = (oval & 0xe0) | ucontrol->value.enumerated.item[0];
 	if (nval != oval) {
 		wm_put(ice, WM_ADC_MUX, nval);
 		change = 1;


