Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B022ED297
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbhAGOee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:34:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:48324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729782AbhAGOeR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:34:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0B24233EE;
        Thu,  7 Jan 2021 14:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610030017;
        bh=kEo5Fq0QfC85PyRsvf0VHTTuVUROCRtd+Cp7lXZofsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PW36XcSkdT8x2eSxB6WCOu0x0JFv1B6XfqGbhL/diVCAKllcZeDozR160AQTSc+TV
         V3eVyoe+ctDdVvtKC+rhhPXmIVt+e/dv6EkDr3j4X91U7mi/mrlBRW6phPFb4e4U9S
         3LH0/0wfmEQSNVnJS58oKTJcWR71Hxt99oi4Bk1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Jan Alexander Steffens (heftig)" <heftig@archlinux.org>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 09/20] ALSA: hda/hdmi: Fix incorrect mutex unlock in silent_stream_disable()
Date:   Thu,  7 Jan 2021 15:34:04 +0100
Message-Id: <20210107143053.692413931@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107143052.392839477@linuxfoundation.org>
References: <20210107143052.392839477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 3d5c5fdcee0f9a94deb0472e594706018b00aa31 upstream.

The silent_stream_disable() function introduced by the commit
b1a5039759cb ("ALSA: hda/hdmi: fix silent stream for first playback to
DP") takes the per_pin->lock mutex, but it unlocks the wrong one,
spec->pcm_lock, which causes a deadlock.  This patch corrects it.

Fixes: b1a5039759cb ("ALSA: hda/hdmi: fix silent stream for first playback to DP")
Reported-by: Jan Alexander Steffens (heftig) <heftig@archlinux.org>
Cc: <stable@vger.kernel.org>
Acked-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20210101083852.12094-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_hdmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1736,7 +1736,7 @@ static void silent_stream_disable(struct
 	per_pin->silent_stream = false;
 
  unlock_out:
-	mutex_unlock(&spec->pcm_lock);
+	mutex_unlock(&per_pin->lock);
 }
 
 /* update ELD and jack state via audio component */


