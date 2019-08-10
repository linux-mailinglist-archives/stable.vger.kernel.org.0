Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8D5D88E5F
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbfHJUyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:54:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53756 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726424AbfHJUns (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:48 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDJ-000539-5l; Sat, 10 Aug 2019 21:43:45 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDI-0003YS-Ni; Sat, 10 Aug 2019 21:43:44 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Samuel Thibault" <samuel.thibault@ens-lyon.org>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.762117024@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 013/157] staging: speakup_soft: Fix alternate speech
 with other synths
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

commit 45ac7b31bc6c4af885cc5b5d6c534c15bcbe7643 upstream.

When switching from speakup_soft to another synth, speakup_soft would
keep calling synth_buffer_getc() from softsynthx_read.

Let's thus make synth.c export the knowledge of the current synth, so
that speakup_soft can determine whether it should be running.

speakup_soft also needs to set itself alive, otherwise the switch would
let it remain silent.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16:
 - There's no Unicode support
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/staging/speakup/speakup_soft.c
+++ b/drivers/staging/speakup/speakup_soft.c
@@ -213,10 +213,13 @@ static ssize_t softsynth_read(struct fil
 	DEFINE_WAIT(wait);
 
 	spin_lock_irqsave(&speakup_info.spinlock, flags);
+	synth_soft.alive = 1;
 	while (1) {
 		prepare_to_wait(&speakup_event, &wait, TASK_INTERRUPTIBLE);
-		if (!synth_buffer_empty() || speakup_info.flushing)
-			break;
+		if (synth_current() == &synth_soft) {
+			if (!synth_buffer_empty() || speakup_info.flushing)
+				break;
+		}
 		spin_unlock_irqrestore(&speakup_info.spinlock, flags);
 		if (fp->f_flags & O_NONBLOCK) {
 			finish_wait(&speakup_event, &wait);
@@ -234,6 +237,8 @@ static ssize_t softsynth_read(struct fil
 	cp = buf;
 	init = get_initstring();
 	while (chars_sent < count) {
+		if (synth_current() != &synth_soft)
+			break;
 		if (speakup_info.flushing) {
 			speakup_info.flushing = 0;
 			ch = '\x18';
@@ -286,7 +291,8 @@ static unsigned int softsynth_poll(struc
 	poll_wait(fp, &speakup_event, wait);
 
 	spin_lock_irqsave(&speakup_info.spinlock, flags);
-	if (!synth_buffer_empty() || speakup_info.flushing)
+	if (synth_current() == &synth_soft &&
+	    (!synth_buffer_empty() || speakup_info.flushing))
 		ret = POLLIN | POLLRDNORM;
 	spin_unlock_irqrestore(&speakup_info.spinlock, flags);
 	return ret;
--- a/drivers/staging/speakup/spk_priv.h
+++ b/drivers/staging/speakup/spk_priv.h
@@ -72,6 +72,7 @@ extern int synth_request_region(u_long,
 extern int synth_release_region(u_long, u_long);
 extern int synth_add(struct spk_synth *in_synth);
 extern void synth_remove(struct spk_synth *in_synth);
+struct spk_synth *synth_current(void);
 
 extern struct speakup_info_t speakup_info;
 
--- a/drivers/staging/speakup/synth.c
+++ b/drivers/staging/speakup/synth.c
@@ -475,4 +475,10 @@ void synth_remove(struct spk_synth *in_s
 }
 EXPORT_SYMBOL_GPL(synth_remove);
 
+struct spk_synth *synth_current(void)
+{
+	return synth;
+}
+EXPORT_SYMBOL_GPL(synth_current);
+
 short spk_punc_masks[] = { 0, SOME, MOST, PUNC, PUNC|B_SYM };

