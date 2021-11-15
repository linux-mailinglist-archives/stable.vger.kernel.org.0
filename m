Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9FE44512F9
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347611AbhKOTkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:40:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:44638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245241AbhKOTTy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:19:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2BC463519;
        Mon, 15 Nov 2021 18:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001063;
        bh=b1dG31J2KC1e8NSy3g3NHju2pqTFU2M5DFQ/8+GxeVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0cEsta0nk4LVPw/Dy6QdmaL35ED6x2xBlm9ZtGwPOeq4mC2YOC91OLG61gbndIXR8
         3PS9ew4B7jhgC4cJW4Dh5Rb2s6Sc7ebCJH5TO/GSjHkqA7vbBFn82gPbZyTJ8+1DGu
         5QfbTkypCCoqiY7fSoLkR2luCmBeA2fjt32kaQVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Scott Branden <scott.branden@broadcom.com>
Subject: [PATCH 5.15 046/917] ALSA: hda: Free card instance properly at probe errors
Date:   Mon, 15 Nov 2021 17:52:21 +0100
Message-Id: <20211115165430.323095925@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 39173303c83859723dab32c2abfb97296d6af3bf upstream.

The recent change in hda-intel driver to allow repeated probes
surfaced a problem that has been hidden until; the probe process in
the work calls azx_free() at the error path, and this skips the card
free process that eventually releases codec instances.  As a result,
we get a kernel WARNING like:

  snd_hda_intel 0000:00:1f.3: Cannot probe codecs, giving up
  ------------[ cut here ]------------
  WARNING: CPU: 14 PID: 186 at sound/hda/hdac_bus.c:73
  ....

For fixing this, we need to call snd_card_free() instead of
azx_free().  Additionally, the device drvdata has to be cleared, as
the driver binding itself is still active.  Then the PM and other
driver callbacks will ignore the procedure.

Fixes: c0f1886de7e1 ("ALSA: hda: intel: Allow repeatedly probing on codec configuration errors")
Reported-and-tested-by: Scott Branden <scott.branden@broadcom.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/063e2397-7edb-5f48-7b0d-618b938d9dd8@broadcom.com
Link: https://lore.kernel.org/r/20211110194633.19098-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_intel.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2330,7 +2330,8 @@ static int azx_probe_continue(struct azx
 
 out_free:
 	if (err < 0) {
-		azx_free(chip);
+		pci_set_drvdata(pci, NULL);
+		snd_card_free(chip->card);
 		return err;
 	}
 


