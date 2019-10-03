Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0B23CA390
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389030AbfJCQQg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:16:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389025AbfJCQQg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:16:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B39722054F;
        Thu,  3 Oct 2019 16:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119395;
        bh=QxwfXe+/+15AzX8GC/b3QQmGn58a1gt4LpsnXXULnUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pcp5NaCIHx/gkXk3MGe3Wr/R2g3PjGbGb3Rd6FFYnhvSiWzi/HLUiTk94zi7GOsI/
         YC0Gqx+qlYyRowoZluAH5GmiojkXp0AGlCSxkcbIs5VLAg0BQjpDqd464AebMrQwLq
         wfN0+ex8MCQXWZarpVubFrog6TdCurfxI7amOdDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard van Breemen <ard@kwaak.net>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 049/211] ALSA: usb-audio: Skip bSynchAddress endpoint check if it is invalid
Date:   Thu,  3 Oct 2019 17:51:55 +0200
Message-Id: <20191003154459.161036002@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
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
index 35c57a4204a8a..13ea63c959d39 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -464,6 +464,7 @@ static int set_sync_endpoint(struct snd_usb_substream *subs,
 	}
 	ep = get_endpoint(alts, 1)->bEndpointAddress;
 	if (get_endpoint(alts, 0)->bLength >= USB_DT_ENDPOINT_AUDIO_SIZE &&
+	    get_endpoint(alts, 0)->bSynchAddress != 0 &&
 	    ((is_playback && ep != (unsigned int)(get_endpoint(alts, 0)->bSynchAddress | USB_DIR_IN)) ||
 	     (!is_playback && ep != (unsigned int)(get_endpoint(alts, 0)->bSynchAddress & ~USB_DIR_IN)))) {
 		dev_err(&dev->dev,
-- 
2.20.1



