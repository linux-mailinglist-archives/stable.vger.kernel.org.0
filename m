Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 910A719B0D0
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732337AbgDAQ3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:29:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388201AbgDAQ3j (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:29:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88DB72063A;
        Wed,  1 Apr 2020 16:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758579;
        bh=DohTVQXblbOwvsyl0RT+rMMpmpa3x4b197VJ4A9xvic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ORO7jml0y+EFOqhfPHr8FFKiXHgWSa3eipV0dn1ptpFaCQxTRE4zp1QSy2ws4CzXl
         fIuj1K2PIiq2xIOdFd9AX29A3eDkhEsn96bqPShft6ggkMUxhi8o0VvHZfJ4jia3Qp
         0kb3lL1mvXwcFI+bCM27wPHvdVBB0F+kwvSR0Kjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+cce32521ee0a824c21f7@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 13/91] ALSA: line6: Fix endless MIDI read loop
Date:   Wed,  1 Apr 2020 18:17:09 +0200
Message-Id: <20200401161517.763952939@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161512.917494101@linuxfoundation.org>
References: <20200401161512.917494101@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit d683469b3c93d7e2afd39e6e1970f24700eb7a68 upstream.

The MIDI input event parser of the LINE6 driver may enter into an
endless loop when the unexpected data sequence is given, as it tries
to continue the secondary bytes without termination.  Also, when the
input data is too short, the parser returns a negative error, while
the caller doesn't handle it properly.  This would lead to the
unexpected behavior as well.

This patch addresses those issues by checking the return value
correctly and handling the one-byte event in the parser properly.

The bug was reported by syzkaller.

Reported-by: syzbot+cce32521ee0a824c21f7@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/000000000000033087059f8f8fa3@google.com
Link: https://lore.kernel.org/r/20200309095922.30269-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/line6/driver.c  |    2 +-
 sound/usb/line6/midibuf.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/sound/usb/line6/driver.c
+++ b/sound/usb/line6/driver.c
@@ -283,7 +283,7 @@ static void line6_data_received(struct u
 		    line6_midibuf_read(mb, line6->buffer_message,
 				       LINE6_MESSAGE_MAXLEN);
 
-		if (done == 0)
+		if (done <= 0)
 			break;
 
 		line6->message_length = done;
--- a/sound/usb/line6/midibuf.c
+++ b/sound/usb/line6/midibuf.c
@@ -163,7 +163,7 @@ int line6_midibuf_read(struct midi_buffe
 			int midi_length_prev =
 			    midibuf_message_length(this->command_prev);
 
-			if (midi_length_prev > 0) {
+			if (midi_length_prev > 1) {
 				midi_length = midi_length_prev - 1;
 				repeat = 1;
 			} else


