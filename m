Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDDBF353E5D
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238675AbhDEJFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:05:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:47924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238079AbhDEJEX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:04:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3230761393;
        Mon,  5 Apr 2021 09:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613456;
        bh=I/nAkjDaD7yeDiDFFpL/akotLAltLpbJ16vuDw93Gi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ox80Jo6sFsfdOmIhcw9YBrkX6QdG/Bn7g+rXtYTR2tIXyBUeY9kKrcDgFmhJX8hUM
         gi172rW08jLTU/M7zMBqfAEVs5FisUgcjUCFjUXy1RUV+ZnTZXgP0kHytelOc+FEbi
         i+BsA+/oHxDykh9CqqTCMU53sw5Xi6bGK/UTT+kc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 42/74] ALSA: hda: Re-add dropped snd_poewr_change_state() calls
Date:   Mon,  5 Apr 2021 10:54:06 +0200
Message-Id: <20210405085026.098032720@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085024.703004126@linuxfoundation.org>
References: <20210405085024.703004126@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit c8f79808cd8eb5bc8d14de129bd6d586d3fce0aa upstream.

The card power state change via snd_power_change_state() at the system
suspend/resume seems dropped mistakenly during the PM code rewrite.
The card power state doesn't play much role nowadays but it's still
referred in a few places such as the HDMI codec driver.

This patch restores them, but in a more appropriate place now in the
prepare and complete callbacks.

Fixes: f5dac54d9d93 ("ALSA: hda: Separate runtime and system suspend")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210329113059.25035-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_intel.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1024,6 +1024,7 @@ static int azx_prepare(struct device *de
 
 	chip = card->private_data;
 	chip->pm_prepared = 1;
+	snd_power_change_state(card, SNDRV_CTL_POWER_D3hot);
 
 	flush_work(&azx_bus(chip)->unsol_work);
 
@@ -1039,6 +1040,7 @@ static void azx_complete(struct device *
 	struct azx *chip;
 
 	chip = card->private_data;
+	snd_power_change_state(card, SNDRV_CTL_POWER_D0);
 	chip->pm_prepared = 0;
 }
 


