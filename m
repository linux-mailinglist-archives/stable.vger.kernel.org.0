Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D79F837CA6F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238423AbhELQaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:30:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:59032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236716AbhELQWw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:22:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1126E61960;
        Wed, 12 May 2021 15:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834422;
        bh=4SQ8Du/Ac4InSMYqvQIXgTAKsN7vFN1M6B4BRbLkn+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oxI4msww/QqyZxVYWhG+CjD8Ltq+l2NPFq5H35/DjQ0XAKGxGnVYrb4wDFUd8JKgM
         XkDRTXxv09lUSd/qYXcq3gg+sCEwmBp58Kz6Ou4nd4aVBj0kMMpKiCdKCFLWZhFfrt
         2U1snBPlKs+uORRz/u2FzjHTzuG8IhCv+8mVnZZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 537/601] ALSA: usb: midi: dont return -ENOMEM when usb_urb_ep_type_check fails
Date:   Wed, 12 May 2021 16:50:14 +0200
Message-Id: <20210512144845.546840001@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
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
index 0c23fa6d8525..cd46ca7cd28d 100644
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



