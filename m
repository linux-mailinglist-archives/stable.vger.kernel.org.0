Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3916D417382
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344656AbhIXM5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:57:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:53310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344686AbhIXMzP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:55:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE01261284;
        Fri, 24 Sep 2021 12:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487857;
        bh=0GZFCYYfQx/uxXebFTqgT3chQ9BHTb+Sr/l66d5Bsus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y4keuPpv2la7qbrW15v2e/jXwQNlqAXTimCDYK9BB3sJtNgjL52an0DkSOSerDDMh
         Fi/91vuMoP8+Tqod0+lbHWc5wFzDtoejYtqVbcwjemOjC/t8hhe7UOp9Bh3UDiAn0X
         /r6b5C/QzUMfLgLEIKqzx8Jlh/rwJeeNUplxJlpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, nick black <dankamongmen@gmail.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 07/50] console: consume APC, DM, DCS
Date:   Fri, 24 Sep 2021 14:43:56 +0200
Message-Id: <20210924124332.483866705@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124332.229289734@linuxfoundation.org>
References: <20210924124332.229289734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: nick black <dankamongmen@gmail.com>

commit 3a2b2eb55681158d3e3ef464fbf47574cf0c517c upstream.

The Linux console's VT102 implementation already consumes OSC
("Operating System Command") sequences, probably because that's how
palette changes are transmitted.

In addition to OSC, there are three other major clases of ANSI control
strings: APC ("Application Program Command"), PM ("Privacy Message"),
and DCS ("Device Control String").  They are handled similarly to OSC in
terms of termination.

Source: vt100.net

Add three new enumerated states, one for each of these types.  All three
are handled the same way right now--they simply consume input until
terminated.  I hope to expand upon this firmament in the future.  Add
new predicate ansi_control_string(), returning true for any of these
states.  Replace explicit checks against ESosc with calls to this
function.  Transition to these states appropriately from the escape
initiation (ESesc) state.

This was motivated by the following Notcurses bugs:

 https://github.com/dankamongmen/notcurses/issues/2050
 https://github.com/dankamongmen/notcurses/issues/1828
 https://github.com/dankamongmen/notcurses/issues/2069

where standard VT sequences are not consumed by the Linux console.  It's
not necessary that the Linux console *support* these sequences, but it
ought *consume* these well-specified classes of sequences.

Tested by sending a variety of escape sequences to the console, and
verifying that they still worked, or were now properly consumed.
Verified that the escapes were properly terminated at a generic level.
Verified that the Notcurses tools continued to show expected output on
the Linux console, except now without escape bleedthrough.

Link: https://lore.kernel.org/lkml/YSydL0q8iaUfkphg@schwarzgerat.orthanc/
Signed-off-by: nick black <dankamongmen@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt.c |   31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -2070,7 +2070,7 @@ static void restore_cur(struct vc_data *
 
 enum { ESnormal, ESesc, ESsquare, ESgetpars, ESfunckey,
 	EShash, ESsetG0, ESsetG1, ESpercent, EScsiignore, ESnonstd,
-	ESpalette, ESosc };
+	ESpalette, ESosc, ESapc, ESpm, ESdcs };
 
 /* console_lock is held (except via vc_init()) */
 static void reset_terminal(struct vc_data *vc, int do_clear)
@@ -2124,20 +2124,28 @@ static void reset_terminal(struct vc_dat
 	    csi_J(vc, 2);
 }
 
+/* is this state an ANSI control string? */
+static bool ansi_control_string(unsigned int state)
+{
+	if (state == ESosc || state == ESapc || state == ESpm || state == ESdcs)
+		return true;
+	return false;
+}
+
 /* console_lock is held */
 static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
 {
 	/*
 	 *  Control characters can be used in the _middle_
-	 *  of an escape sequence.
+	 *  of an escape sequence, aside from ANSI control strings.
 	 */
-	if (vc->vc_state == ESosc && c>=8 && c<=13) /* ... except for OSC */
+	if (ansi_control_string(vc->vc_state) && c >= 8 && c <= 13)
 		return;
 	switch (c) {
 	case 0:
 		return;
 	case 7:
-		if (vc->vc_state == ESosc)
+		if (ansi_control_string(vc->vc_state))
 			vc->vc_state = ESnormal;
 		else if (vc->vc_bell_duration)
 			kd_mksound(vc->vc_bell_pitch, vc->vc_bell_duration);
@@ -2196,6 +2204,12 @@ static void do_con_trol(struct tty_struc
 		case ']':
 			vc->vc_state = ESnonstd;
 			return;
+		case '_':
+			vc->vc_state = ESapc;
+			return;
+		case '^':
+			vc->vc_state = ESpm;
+			return;
 		case '%':
 			vc->vc_state = ESpercent;
 			return;
@@ -2212,6 +2226,9 @@ static void do_con_trol(struct tty_struc
 		case 'H':
 			vc->vc_tab_stop[7 & (vc->vc_x >> 5)] |= (1 << (vc->vc_x & 31));
 			return;
+		case 'P':
+			vc->vc_state = ESdcs;
+			return;
 		case 'Z':
 			respond_ID(tty);
 			return;
@@ -2531,8 +2548,14 @@ static void do_con_trol(struct tty_struc
 			vc->vc_translate = set_translate(vc->vc_G1_charset, vc);
 		vc->vc_state = ESnormal;
 		return;
+	case ESapc:
+		return;
 	case ESosc:
 		return;
+	case ESpm:
+		return;
+	case ESdcs:
+		return;
 	default:
 		vc->vc_state = ESnormal;
 	}


