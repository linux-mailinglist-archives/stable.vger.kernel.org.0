Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7420122664D
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731967AbgGTQCI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:02:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:35834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732617AbgGTQCH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:02:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E63220773;
        Mon, 20 Jul 2020 16:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260927;
        bh=sxK6Nty12LeWlh8Gf7SIUuMWgXiwYL21I6Qq+tPZcZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Szl3sdqTGpweqKMlweoxaLpZwrdyFV4w0f92XWLkPkp2oPmI7uknMKzdmYpvup2Nn
         s/HpP09JVkfs9E4CF7OcLZgjT/woVXd1uWzv37eP+nPVjGwUyRhBhb3rU4/k8LqScr
         8PorRQz3jUgi7b0U8g5Y63NrSOlfeLnENILzaeDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+c190f6858a04ea7fbc52@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 147/215] ALSA: line6: Perform sanity check for each URB creation
Date:   Mon, 20 Jul 2020 17:37:09 +0200
Message-Id: <20200720152827.191359726@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
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
@@ -287,6 +287,8 @@ int line6_create_audio_in_urbs(struct sn
 		urb->interval = LINE6_ISO_INTERVAL;
 		urb->error_count = 0;
 		urb->complete = audio_in_callback;
+		if (usb_urb_ep_type_check(urb))
+			return -EINVAL;
 	}
 
 	return 0;
--- a/sound/usb/line6/playback.c
+++ b/sound/usb/line6/playback.c
@@ -432,6 +432,8 @@ int line6_create_audio_out_urbs(struct s
 		urb->interval = LINE6_ISO_INTERVAL;
 		urb->error_count = 0;
 		urb->complete = audio_out_callback;
+		if (usb_urb_ep_type_check(urb))
+			return -EINVAL;
 	}
 
 	return 0;


