Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96F1986A3B
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404651AbfHHTHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:07:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404647AbfHHTHV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:07:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA10F214C6;
        Thu,  8 Aug 2019 19:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291241;
        bh=sKb2ant9Jf6tIi2b62WRaEOi0Q9/FpMvLtGoIIhoLdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iWetKm5JVrjMrIg/EVVJWFT+UdBg8ueybPQmMqkB0Hz5dmZ7EEZ6iv/hZcX1X4JYW
         sKbTeABst4AUUngkbwOOKDWLtzFTIapfC1pHhjm6gDQ/qm+TarKfHlXOp+4Zqw/ogN
         2IUaWU2aqwUW8XwUR52JmxKelKWHRgmDa+t4YZLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+d59c4387bfb6eced94e2@syzkaller.appspotmail.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Hillf Danton <hdanton@sina.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 05/56] ALSA: usb-audio: Fix gpf in snd_usb_pipe_sanity_check
Date:   Thu,  8 Aug 2019 21:04:31 +0200
Message-Id: <20190808190453.077297569@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190452.867062037@linuxfoundation.org>
References: <20190808190452.867062037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5d78e1c2b7f4be00bbe62141603a631dc7812f35 ]

syzbot found the following crash on:

  general protection fault: 0000 [#1] SMP KASAN
  RIP: 0010:snd_usb_pipe_sanity_check+0x80/0x130 sound/usb/helper.c:75
  Call Trace:
    snd_usb_motu_microbookii_communicate.constprop.0+0xa0/0x2fb  sound/usb/quirks.c:1007
    snd_usb_motu_microbookii_boot_quirk sound/usb/quirks.c:1051 [inline]
    snd_usb_apply_boot_quirk.cold+0x163/0x370 sound/usb/quirks.c:1280
    usb_audio_probe+0x2ec/0x2010 sound/usb/card.c:576
    usb_probe_interface+0x305/0x7a0 drivers/usb/core/driver.c:361
    really_probe+0x281/0x650 drivers/base/dd.c:548
    ....

It was introduced in commit 801ebf1043ae for checking pipe and endpoint
types. It is fixed by adding a check of the ep pointer in question.

BugLink: https://syzkaller.appspot.com/bug?extid=d59c4387bfb6eced94e2
Reported-by: syzbot <syzbot+d59c4387bfb6eced94e2@syzkaller.appspotmail.com>
Fixes: 801ebf1043ae ("ALSA: usb-audio: Sanity checks for each pipe and EP types")
Cc: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/helper.c b/sound/usb/helper.c
index 71d5f540334a2..4c12cc5b53fda 100644
--- a/sound/usb/helper.c
+++ b/sound/usb/helper.c
@@ -72,7 +72,7 @@ int snd_usb_pipe_sanity_check(struct usb_device *dev, unsigned int pipe)
 	struct usb_host_endpoint *ep;
 
 	ep = usb_pipe_endpoint(dev, pipe);
-	if (usb_pipetype(pipe) != pipetypes[usb_endpoint_type(&ep->desc)])
+	if (!ep || usb_pipetype(pipe) != pipetypes[usb_endpoint_type(&ep->desc)])
 		return -EINVAL;
 	return 0;
 }
-- 
2.20.1



