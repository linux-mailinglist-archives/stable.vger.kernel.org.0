Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEF13033A9
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 06:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbhAZFCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:02:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:38958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731164AbhAYSvo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:51:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07FFF20665;
        Mon, 25 Jan 2021 18:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600662;
        bh=6M1+X/O+rb9PG7g8fHUffNHEDfkKlAkXvrGxIqgZfPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rAWnNry1juv07Zq8Bvd4j7Zp2zIInJ6O7Xg+2BPfzhQtBGEvpjbGMnNz8z6vtRnRW
         Ocjko9nnYVNp9UhkmxIIpnvvsLKI4+QGWmmyHAGgaQMC2QD2/+GJ20CRWb9biLHZBo
         zZs6CTjEHjKG4KNWz/UJUpOYIRFHg2mh2WLL8sKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Kenneth R. Crudup" <kenny@panix.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/199] ALSA: hda: Balance runtime/system PM if direct-complete is disabled
Date:   Mon, 25 Jan 2021 19:38:45 +0100
Message-Id: <20210125183220.617523783@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 2b73649cee65b8e33c75c66348cb1bfe0ff9d766 ]

After hibernation, HDA controller can't be runtime-suspended after
commit 215a22ed31a1 ("ALSA: hda: Refactor codjc PM to use
direct-complete optimization"), which enables direct-complete for HDA
codec.

The HDA codec driver didn't expect direct-complete will be disabled
after it returns a positive value from prepare() callback. However,
there are some places that PM core can disable direct-complete. For
instance, system hibernation or when codec has subordinates like LEDs.

So if the codec is prepared for direct-complete but PM core still calls
codec's suspend or freeze callback, partially revert the commit and take
the original approach, which uses pm_runtime_force_*() helpers to
ensure PM refcount are balanced. Meanwhile, still keep prepare() and
complete() callbacks to enable direct-complete and request a resume for
jack detection, respectively.

Reported-by: Kenneth R. Crudup <kenny@panix.com>
Fixes: 215a22ed31a1 ("ALSA: hda: Refactor codec PM to use direct-complete optimization")
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Link: https://lore.kernel.org/r/20210119152145.346558-1-kai.heng.feng@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_codec.c | 24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 687216e745267..eec1775dfffe9 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -2934,7 +2934,7 @@ static void hda_call_codec_resume(struct hda_codec *codec)
 	snd_hdac_leave_pm(&codec->core);
 }
 
-static int hda_codec_suspend(struct device *dev)
+static int hda_codec_runtime_suspend(struct device *dev)
 {
 	struct hda_codec *codec = dev_to_hda_codec(dev);
 	unsigned int state;
@@ -2953,7 +2953,7 @@ static int hda_codec_suspend(struct device *dev)
 	return 0;
 }
 
-static int hda_codec_resume(struct device *dev)
+static int hda_codec_runtime_resume(struct device *dev)
 {
 	struct hda_codec *codec = dev_to_hda_codec(dev);
 
@@ -2968,16 +2968,6 @@ static int hda_codec_resume(struct device *dev)
 	return 0;
 }
 
-static int hda_codec_runtime_suspend(struct device *dev)
-{
-	return hda_codec_suspend(dev);
-}
-
-static int hda_codec_runtime_resume(struct device *dev)
-{
-	return hda_codec_resume(dev);
-}
-
 #endif /* CONFIG_PM */
 
 #ifdef CONFIG_PM_SLEEP
@@ -2998,31 +2988,31 @@ static void hda_codec_pm_complete(struct device *dev)
 static int hda_codec_pm_suspend(struct device *dev)
 {
 	dev->power.power_state = PMSG_SUSPEND;
-	return hda_codec_suspend(dev);
+	return pm_runtime_force_suspend(dev);
 }
 
 static int hda_codec_pm_resume(struct device *dev)
 {
 	dev->power.power_state = PMSG_RESUME;
-	return hda_codec_resume(dev);
+	return pm_runtime_force_resume(dev);
 }
 
 static int hda_codec_pm_freeze(struct device *dev)
 {
 	dev->power.power_state = PMSG_FREEZE;
-	return hda_codec_suspend(dev);
+	return pm_runtime_force_suspend(dev);
 }
 
 static int hda_codec_pm_thaw(struct device *dev)
 {
 	dev->power.power_state = PMSG_THAW;
-	return hda_codec_resume(dev);
+	return pm_runtime_force_resume(dev);
 }
 
 static int hda_codec_pm_restore(struct device *dev)
 {
 	dev->power.power_state = PMSG_RESTORE;
-	return hda_codec_resume(dev);
+	return pm_runtime_force_resume(dev);
 }
 #endif /* CONFIG_PM_SLEEP */
 
-- 
2.27.0



