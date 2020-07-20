Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59031226A99
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730505AbgGTPxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:53:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730407AbgGTPxL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:53:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B29F62065E;
        Mon, 20 Jul 2020 15:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260391;
        bh=FvbEbj9zDmGUluItPBrqCuYmOC1pzcSCb26Tocy+TK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ydTvQTuH4DIMTer6QVWh+GrY8+ckhs+oOMGiiv1BazAjr1foyxLwKbO4+xKqwU9/m
         sT3airLsC/8p7ZFmwbSrYoVsMwh07HomiTZLJCiIiMCdWU1uzlA1E1J2YZuLR3Er4r
         u1kYT7hD+JEhBJlKfCiiWSLzyCDTo8Apc6vbXdQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+c190f6858a04ea7fbc52@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 085/133] ALSA: line6: Perform sanity check for each URB creation
Date:   Mon, 20 Jul 2020 17:37:12 +0200
Message-Id: <20200720152807.819235827@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 6e8a914ad619042c5f25a4feb663357c4170fd8d upstream.

LINE6 drivers create stream URBs with a fixed pipe without checking
its validity, and this may lead to a kernel WARNING at the submission
when a malformed USB descriptor is passed.

For avoiding the kernel warning, perform the similar sanity checks for
each pipe type at creating a URB.

Reported-by: syzbot+c190f6858a04ea7fbc52@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/s5hv9iv4hq8.wl-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/line6/capture.c  |    2 ++
 sound/usb/line6/playback.c |    2 ++
 2 files changed, 4 insertions(+)

--- a/sound/usb/line6/capture.c
+++ b/sound/usb/line6/capture.c
@@ -291,6 +291,8 @@ int line6_create_audio_in_urbs(struct sn
 		urb->interval = LINE6_ISO_INTERVAL;
 		urb->error_count = 0;
 		urb->complete = audio_in_callback;
+		if (usb_urb_ep_type_check(urb))
+			return -EINVAL;
 	}
 
 	return 0;
--- a/sound/usb/line6/playback.c
+++ b/sound/usb/line6/playback.c
@@ -436,6 +436,8 @@ int line6_create_audio_out_urbs(struct s
 		urb->interval = LINE6_ISO_INTERVAL;
 		urb->error_count = 0;
 		urb->complete = audio_out_callback;
+		if (usb_urb_ep_type_check(urb))
+			return -EINVAL;
 	}
 
 	return 0;


