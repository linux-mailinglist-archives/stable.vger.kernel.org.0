Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E261DCA2CD
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731694AbfJCQJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:09:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731985AbfJCQJT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:09:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7D70207FF;
        Thu,  3 Oct 2019 16:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118959;
        bh=9JOBPaZ+2nE+YIpe80AMMSCTFSc0lfy/HUHq8QQ0QnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XYinhMOIWnnRAC4hjochtYGautR2wpHtEmbHw/SYD54sW1i46IFE1FWHvBO3kIIby
         YZlZ9azBvn5t93U8SxBYeAUDUSL3qz42I+p1tHjH2AUP8afPIbrofqg97sXOeLC3Dm
         Abdb1GoikhMvC2MgXjPwFzLqI2Lwa36mtysvWVco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard van Breemen <ard@kwaak.net>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 072/185] ALSA: usb-audio: Skip bSynchAddress endpoint check if it is invalid
Date:   Thu,  3 Oct 2019 17:52:30 +0200
Message-Id: <20191003154453.846968339@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



