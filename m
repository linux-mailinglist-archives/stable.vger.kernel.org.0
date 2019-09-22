Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA4B4BA64B
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392004AbfIVStF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:49:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391982AbfIVStE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:49:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2CBC21479;
        Sun, 22 Sep 2019 18:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178143;
        bh=BO2CMp99KgEKir43vyYmY/h5UcVrkGaXXS/emvzKtOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xorA9iaEn0zgcfLjVhLkGGblXYzSwwaBtiZpx27FwjKa3zjUzHJGPm4HgCCzAMzi3
         y0mC88zQd77GyQVMzIjUwPXiGPi8G9oXbrWC+BPmYuCTrX1GTk/hJh1yLshNXWYd7n
         CJsM9hzCh6gDM9dLYlhQQ15oYmN89GP8W2xvfzz0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 192/203] ALSA: hda - Drop unsol event handler for Intel HDMI codecs
Date:   Sun, 22 Sep 2019 14:43:38 -0400
Message-Id: <20190922184350.30563-192-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit f2dbe87c5ac1f88e6007ba1f1374f4bd8a197fb6 ]

We don't need to deal with the unsol events for Intel chips that are
tied with the graphics via audio component notifier.  Although the
presence of the audio component is checked at the beginning of
hdmi_unsol_event(), better to short cut by dropping unsol_event ops.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=204565
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_hdmi.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index c380596b2e84c..36240def9bf58 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -2616,6 +2616,8 @@ static void i915_pin_cvt_fixup(struct hda_codec *codec,
 /* precondition and allocation for Intel codecs */
 static int alloc_intel_hdmi(struct hda_codec *codec)
 {
+	int err;
+
 	/* requires i915 binding */
 	if (!codec->bus->core.audio_component) {
 		codec_info(codec, "No i915 binding for Intel HDMI/DP codec\n");
@@ -2624,7 +2626,12 @@ static int alloc_intel_hdmi(struct hda_codec *codec)
 		return -ENODEV;
 	}
 
-	return alloc_generic_hdmi(codec);
+	err = alloc_generic_hdmi(codec);
+	if (err < 0)
+		return err;
+	/* no need to handle unsol events */
+	codec->patch_ops.unsol_event = NULL;
+	return 0;
 }
 
 /* parse and post-process for Intel codecs */
-- 
2.20.1

