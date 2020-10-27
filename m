Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD9829C357
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1759991AbgJ0Oas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:30:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901914AbgJ0O3Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:29:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B89522202;
        Tue, 27 Oct 2020 14:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808955;
        bh=N43g5Xg3aUQ3r4fFE2YtN+qTDzKFjQapdCqxzU9YBms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XRdXD1ESjnBXX4apLeGViZja66BgxzDREquk6Vj9fKgTeZdYiZjmpKbDSIqBcHgVv
         S7zAyizOhyjuM3VIyL2N7tC2VX065skYFSIhb9e5xQiHIin1vF9yKDHnYiNKhLbbx+
         +LyQJunOk8rzfDcQWEKy/oDnbAxlXlGySv5meFRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 023/408] ALSA: hda/hdmi: fix incorrect locking in hdmi_pcm_close
Date:   Tue, 27 Oct 2020 14:49:21 +0100
Message-Id: <20201027135456.135261109@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

commit ce1558c285f9ad04c03b46833a028230771cc0a7 upstream.

A race exists between closing a PCM and update of ELD data. In
hdmi_pcm_close(), hinfo->nid value is modified without taking
spec->pcm_lock. If this happens concurrently while processing an ELD
update in hdmi_pcm_setup_pin(), converter assignment may be done
incorrectly.

This bug was found by hitting a WARN_ON in snd_hda_spdif_ctls_assign()
in a HDMI receiver connection stress test:

[2739.684569] WARNING: CPU: 5 PID: 2090 at sound/pci/hda/patch_hdmi.c:1898 check_non_pcm_per_cvt+0x41/0x50 [snd_hda_codec_hdmi]
...
[2739.684707] Call Trace:
[2739.684720]  update_eld+0x121/0x5a0 [snd_hda_codec_hdmi]
[2739.684736]  hdmi_present_sense+0x21e/0x3b0 [snd_hda_codec_hdmi]
[2739.684750]  check_presence_and_report+0x81/0xd0 [snd_hda_codec_hdmi]
[2739.684842]  intel_audio_codec_enable+0x122/0x190 [i915]

Fixes: 42b2987079ec ("ALSA: hda - hdmi playback without monitor in dynamic pcm bind mode")
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201013152628.920764-1-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_hdmi.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -2001,22 +2001,25 @@ static int hdmi_pcm_close(struct hda_pcm
 	int pinctl;
 	int err = 0;
 
+	mutex_lock(&spec->pcm_lock);
 	if (hinfo->nid) {
 		pcm_idx = hinfo_to_pcm_index(codec, hinfo);
-		if (snd_BUG_ON(pcm_idx < 0))
-			return -EINVAL;
+		if (snd_BUG_ON(pcm_idx < 0)) {
+			err = -EINVAL;
+			goto unlock;
+		}
 		cvt_idx = cvt_nid_to_cvt_index(codec, hinfo->nid);
-		if (snd_BUG_ON(cvt_idx < 0))
-			return -EINVAL;
+		if (snd_BUG_ON(cvt_idx < 0)) {
+			err = -EINVAL;
+			goto unlock;
+		}
 		per_cvt = get_cvt(spec, cvt_idx);
-
 		snd_BUG_ON(!per_cvt->assigned);
 		per_cvt->assigned = 0;
 		hinfo->nid = 0;
 
 		azx_stream(get_azx_dev(substream))->stripe = 0;
 
-		mutex_lock(&spec->pcm_lock);
 		snd_hda_spdif_ctls_unassign(codec, pcm_idx);
 		clear_bit(pcm_idx, &spec->pcm_in_use);
 		pin_idx = hinfo_to_pin_index(codec, hinfo);
@@ -2044,10 +2047,11 @@ static int hdmi_pcm_close(struct hda_pcm
 		per_pin->setup = false;
 		per_pin->channels = 0;
 		mutex_unlock(&per_pin->lock);
-	unlock:
-		mutex_unlock(&spec->pcm_lock);
 	}
 
+unlock:
+	mutex_unlock(&spec->pcm_lock);
+
 	return err;
 }
 


