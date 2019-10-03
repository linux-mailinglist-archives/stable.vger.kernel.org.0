Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9D42CA17F
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 17:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730605AbfJCP42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 11:56:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730580AbfJCP4X (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 11:56:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C257621A4C;
        Thu,  3 Oct 2019 15:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118182;
        bh=1OUUghvMNit7ATWMhWdyUNvrax21oyc5yD7XumTD/D4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i4I8+pAaDJ813rbnqAq1/oIdfOKnUKf/MFoQ/pnf7WWXLeqKS/IjPIiVULP5tD1g3
         ZnlxsKIjnFg/8R79qPURmBXTEhizQSLNbrwuKkQs97H9wNhhF30UtKQJVBg+3DRQQY
         87YWjBwDOWVhT+WfvgwtKE4+HrqPqMoWHIQxDk3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Jiri Kosina <jkosina@suse.cz>,
        syzbot+1088533649dafa1c9004@syzkaller.appspotmail.com
Subject: [PATCH 4.4 02/99] HID: prodikeys: Fix general protection fault during probe
Date:   Thu,  3 Oct 2019 17:52:25 +0200
Message-Id: <20191003154253.491273763@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154252.297991283@linuxfoundation.org>
References: <20191003154252.297991283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
CC: <stable@vger.kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-prodikeys.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-prodikeys.c
+++ b/drivers/hid/hid-prodikeys.c
@@ -556,10 +556,14 @@ static void pcmidi_setup_extra_keys(
 
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
@@ -688,7 +692,11 @@ static int pcmidi_snd_initialise(struct
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


