Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1957F37C24D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbhELPIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:08:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:59262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232905AbhELPGm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:06:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 209EA61444;
        Wed, 12 May 2021 15:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831683;
        bh=0R9efrNUh3BbrwxwdDk0iL10D1k9ywrVJUgu94nMF6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WrHWRvRwMUu9+BKLJBR7ehWI4VCcv9bywpOWObGuYZyYKXTkfOvmXsX+bp3hniBIe
         KT//d5ZHkrfUvX8YQ8iVWEBYJURqgFJP64euFSZNY64tDiYzLN1JTzehVbfPyAt6dM
         /n5VXVgAnTFor2JGCTEnGRHtYr3via9wfdhxhG4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 218/244] ALSA: usb: midi: dont return -ENOMEM when usb_urb_ep_type_check fails
Date:   Wed, 12 May 2021 16:49:49 +0200
Message-Id: <20210512144749.976108194@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
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
index 1cc17c449407..c205a26ef509 100644
--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -1332,7 +1332,7 @@ static int snd_usbmidi_in_endpoint_create(struct snd_usb_midi *umidi,
 
  error:
 	snd_usbmidi_in_endpoint_delete(ep);
-	return -ENOMEM;
+	return err;
 }
 
 /*
-- 
2.30.2



