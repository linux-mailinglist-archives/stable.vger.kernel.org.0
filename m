Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA57C22683A
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387499AbgGTQMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:12:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387924AbgGTQMO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:12:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C6E220684;
        Mon, 20 Jul 2020 16:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261533;
        bh=tRcWTGEvoCkG7qVu7iz7j3Heu/lnCqZe1Tuh5KAvBcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dAAy/jRdGoIYV+43sct9UBQX9BSvahAeKMEvFBbZN9QwDSwuzkX9asNjpXi4JiF4x
         TMAujO6NbbCHqAL7Z2ZcJRzVMnqNPCskwvb87SpskGbP23rByHgU7wh9uNsipKfFpz
         7JH0oJeOkM8ZsdtibyYgWm+byivMgRb8vyPBxlV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+c190f6858a04ea7fbc52@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.7 151/244] ALSA: line6: Perform sanity check for each URB creation
Date:   Mon, 20 Jul 2020 17:37:02 +0200
Message-Id: <20200720152833.034137499@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
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
@@ -286,6 +286,8 @@ int line6_create_audio_in_urbs(struct sn
 		urb->interval = LINE6_ISO_INTERVAL;
 		urb->error_count = 0;
 		urb->complete = audio_in_callback;
+		if (usb_urb_ep_type_check(urb))
+			return -EINVAL;
 	}
 
 	return 0;
--- a/sound/usb/line6/playback.c
+++ b/sound/usb/line6/playback.c
@@ -431,6 +431,8 @@ int line6_create_audio_out_urbs(struct s
 		urb->interval = LINE6_ISO_INTERVAL;
 		urb->error_count = 0;
 		urb->complete = audio_out_callback;
+		if (usb_urb_ep_type_check(urb))
+			return -EINVAL;
 	}
 
 	return 0;


