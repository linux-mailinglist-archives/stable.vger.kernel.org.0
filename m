Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71944116233
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 14:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbfLHN6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 08:58:12 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60048 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726646AbfLHNyl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 08:54:41 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1C-0007ds-DL; Sun, 08 Dec 2019 13:54:38 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1B-0002MU-9B; Sun, 08 Dec 2019 13:54:37 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        "Jiri Kosina" <jkosina@suse.cz>
Date:   Sun, 08 Dec 2019 13:53:10 +0000
Message-ID: <lsq.1575813165.907082376@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 26/72] HID: prodikeys: Fix general protection fault
 during probe
In-Reply-To: <lsq.1575813164.154362148@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.79-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 98375b86c79137416e9fd354177b85e768c16e56 upstream.

The syzbot fuzzer provoked a general protection fault in the
hid-prodikeys driver:

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] SMP KASAN
CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.3.0-rc5+ #28
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
Google 01/01/2011
Workqueue: usb_hub_wq hub_event
RIP: 0010:pcmidi_submit_output_report drivers/hid/hid-prodikeys.c:300  [inline]
RIP: 0010:pcmidi_set_operational drivers/hid/hid-prodikeys.c:558 [inline]
RIP: 0010:pcmidi_snd_initialise drivers/hid/hid-prodikeys.c:686 [inline]
RIP: 0010:pk_probe+0xb51/0xfd0 drivers/hid/hid-prodikeys.c:836
Code: 0f 85 50 04 00 00 48 8b 04 24 4c 89 7d 10 48 8b 58 08 e8 b2 53 e4 fc
48 8b 54 24 20 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f
85 13 04 00 00 48 ba 00 00 00 00 00 fc ff df 49 8b

The problem is caused by the fact that pcmidi_get_output_report() will
return an error if the HID device doesn't provide the right sort of
output report, but pcmidi_set_operational() doesn't bother to check
the return code and assumes the function call always succeeds.

This patch adds the missing check and aborts the probe operation if
necessary.

Reported-and-tested-by: syzbot+1088533649dafa1c9004@syzkaller.appspotmail.com
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hid/hid-prodikeys.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-prodikeys.c
+++ b/drivers/hid/hid-prodikeys.c
@@ -557,10 +557,14 @@ static void pcmidi_setup_extra_keys(
 
 static int pcmidi_set_operational(struct pcmidi_snd *pm)
 {
+	int rc;
+
 	if (pm->ifnum != 1)
 		return 0; /* only set up ONCE for interace 1 */
 
-	pcmidi_get_output_report(pm);
+	rc = pcmidi_get_output_report(pm);
+	if (rc < 0)
+		return rc;
 	pcmidi_submit_output_report(pm, 0xc1);
 	return 0;
 }
@@ -689,7 +693,11 @@ static int pcmidi_snd_initialise(struct
 	spin_lock_init(&pm->rawmidi_in_lock);
 
 	init_sustain_timers(pm);
-	pcmidi_set_operational(pm);
+	err = pcmidi_set_operational(pm);
+	if (err < 0) {
+		pk_error("failed to find output report\n");
+		goto fail_register;
+	}
 
 	/* register it */
 	err = snd_card_register(card);

