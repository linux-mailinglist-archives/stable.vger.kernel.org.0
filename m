Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F312D38A44D
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234856AbhETKDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:03:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:37146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234646AbhETKBr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:01:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 260DF61626;
        Thu, 20 May 2021 09:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503568;
        bh=iT3Ht0CTmdhn6kws6at0BwpQ5qXOR1B3AYpMYcSZaUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zOLiyKfbmMkSaNb7Xv1lc6JTkHrrAbbwNZuuy5GIDbPjo2u5Aae7Jf96bFIUX++Vy
         YowyEZ5gAKGaFZenBSsns4+vif/l5n/dvickeT1rHRqyjeqCaIqQJDVJvTLVlBFyIw
         U3Gzig4dgVIqUtuV2Cjd7dnrEgloRpPE0dsusnRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 280/425] ALSA: usb: midi: dont return -ENOMEM when usb_urb_ep_type_check fails
Date:   Thu, 20 May 2021 11:20:49 +0200
Message-Id: <20210520092140.643516737@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit cfd577acb769301b19c31361d45ae1f145318b7a ]

Currently when the call to usb_urb_ep_type_check fails (returning -EINVAL)
the error return path returns -ENOMEM via the exit label "error". Other
uses of the same error exit label set the err variable to -ENOMEM but this
is not being used.  I believe the original intent was for the error exit
path to return the value in err rather than the hard coded -ENOMEM, so
return this rather than the hard coded -ENOMEM.

Addresses-Coverity: ("Unused value")
Fixes: 738d9edcfd44 ("ALSA: usb-audio: Add sanity checks for invalid EPs")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/20210420134719.381409-1-colin.king@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/midi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/midi.c b/sound/usb/midi.c
index 26548f760bc1..4553db0ef084 100644
--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -1333,7 +1333,7 @@ static int snd_usbmidi_in_endpoint_create(struct snd_usb_midi *umidi,
 
  error:
 	snd_usbmidi_in_endpoint_delete(ep);
-	return -ENOMEM;
+	return err;
 }
 
 /*
-- 
2.30.2



