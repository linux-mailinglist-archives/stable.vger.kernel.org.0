Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72404431BD7
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbhJRNfb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:35:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:42612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232579AbhJRNeC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:34:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B198F6136F;
        Mon, 18 Oct 2021 13:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563794;
        bh=ioid6dr2i2v5d1SwCGY0/2mkKTGK+5RlY2dtljkNT/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e6tJzO3+1nbaVIvxt56NvEaaO0r9UzfNAvLPtgqxkqUo+mGq694PVSM1c5N0330VY
         lFSwQpZvFBLDNwrajDxpxXS1k9dohe1Jkzf5/c9FZUS98DXzyMEprFEHWGnzXL7SZ0
         q9zltTSxoUVbKFeSob5imiqWTVjMWmS3Zbrfhf90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 06/69] ALSA: hda/realtek - ALC236 headset MIC recording issue
Date:   Mon, 18 Oct 2021 15:24:04 +0200
Message-Id: <20211018132329.667492656@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132329.453964125@linuxfoundation.org>
References: <20211018132329.453964125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit 5aec98913095ed3b4424ed6c5fdeb6964e9734da upstream.

In power save mode, the recording voice from headset mic will 2s more delay.
Add this patch will solve this issue.

[ minor coding style fix by tiwai ]

Signed-off-by: Kailang Yang <kailang@realtek.com>
Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/ccb0cdd5bbd7486eabbd8d987d384cb0@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -517,6 +517,8 @@ static void alc_shutup_pins(struct hda_c
 	struct alc_spec *spec = codec->spec;
 
 	switch (codec->core.vendor_id) {
+	case 0x10ec0236:
+	case 0x10ec0256:
 	case 0x10ec0283:
 	case 0x10ec0286:
 	case 0x10ec0288:
@@ -3522,7 +3524,8 @@ static void alc256_shutup(struct hda_cod
 	/* If disable 3k pulldown control for alc257, the Mic detection will not work correctly
 	 * when booting with headset plugged. So skip setting it for the codec alc257
 	 */
-	if (codec->core.vendor_id != 0x10ec0257)
+	if (spec->codec_variant != ALC269_TYPE_ALC257 &&
+	    spec->codec_variant != ALC269_TYPE_ALC256)
 		alc_update_coef_idx(codec, 0x46, 0, 3 << 12);
 
 	if (!spec->no_shutup_pins)


