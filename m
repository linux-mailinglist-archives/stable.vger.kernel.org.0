Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E934EBA941
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395536AbfIVTNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:13:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:60450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438664AbfIVS5t (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:57:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 583A32190F;
        Sun, 22 Sep 2019 18:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178669;
        bh=9JOBPaZ+2nE+YIpe80AMMSCTFSc0lfy/HUHq8QQ0QnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M5psmnjGWaWP2zQiue31loMRohqw9pR2z7nqhofvcCnHCxyCdZM+YcK3ceJ4cMMlo
         BXwjJMIx7imhcMXG1uZavIhrFpc+nnv7WFXxiuYjZdogE9FNCxoMlln6kKpGt2WsAm
         N3ZQjnt9PiG0cLlwWxbde3ILVu2HFdnTHdHwcDA4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard van Breemen <ard@kwaak.net>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 20/89] ALSA: usb-audio: Skip bSynchAddress endpoint check if it is invalid
Date:   Sun, 22 Sep 2019 14:56:08 -0400
Message-Id: <20190922185717.3412-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185717.3412-1-sashal@kernel.org>
References: <20190922185717.3412-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard van Breemen <ard@kwaak.net>

[ Upstream commit 1b34121d9f26d272b0b2334209af6b6fc82d4bf1 ]

The Linux kernel assumes that get_endpoint(alts,0) and
get_endpoint(alts,1) are eachothers feedback endpoints.
To reassure that validity it will test bsynchaddress to comply with that
assumption. But if the bsyncaddress is 0 (invalid), it will flag that as
a wrong assumption and return an error.
Fix: Skip the test if bSynchAddress is 0.
Note: those with a valid bSynchAddress should have a code quirck added.

Signed-off-by: Ard van Breemen <ard@kwaak.net>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/pcm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index b1a1eb1f65aa3..ff38fca1781b6 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -470,6 +470,7 @@ static int set_sync_endpoint(struct snd_usb_substream *subs,
 	}
 	ep = get_endpoint(alts, 1)->bEndpointAddress;
 	if (get_endpoint(alts, 0)->bLength >= USB_DT_ENDPOINT_AUDIO_SIZE &&
+	    get_endpoint(alts, 0)->bSynchAddress != 0 &&
 	    ((is_playback && ep != (unsigned int)(get_endpoint(alts, 0)->bSynchAddress | USB_DIR_IN)) ||
 	     (!is_playback && ep != (unsigned int)(get_endpoint(alts, 0)->bSynchAddress & ~USB_DIR_IN)))) {
 		dev_err(&dev->dev,
-- 
2.20.1

