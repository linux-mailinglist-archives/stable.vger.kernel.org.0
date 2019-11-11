Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA483F7E08
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730209AbfKKSu4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:50:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:44846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730028AbfKKSuz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:50:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C21C521655;
        Mon, 11 Nov 2019 18:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498254;
        bh=rkmLoaAJO0IPfco4Q0wQ7qYtCDweohjA2q8aZ0sOLSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jbXwt5AmtkFPigaBkH47TecOalkpuYJNPJuUIUONnjUy7JDf2pmrepzOKMg0M/8sB
         sCm5tXnQvCSvEdF+9qzm86Y5CQzyfvtWv/wkVydJQULFRqaA1ChdZgOR6lbDOp+/+j
         lxEcXvy+UvkiCoDfuYgI0yh8FTckkkxRH/I+QYms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.3 027/193] ALSA: hda/ca0132 - Fix possible workqueue stall
Date:   Mon, 11 Nov 2019 19:26:49 +0100
Message-Id: <20191111181502.260219355@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 15c2b3cc09a31620914955cb2a89c277c18ee999 upstream.

The unsolicited event handler for the headphone jack on CA0132 codec
driver tries to reschedule the another delayed work with
cancel_delayed_work_sync().  It's no good idea, unfortunately,
especially after we changed the work queue to the standard global
one; this may lead to a stall because both works are using the same
global queue.

Fix it by dropping the _sync but does call cancel_delayed_work()
instead.

Fixes: 993884f6a26c ("ALSA: hda/ca0132 - Delay HP amp turnon.")
BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1155836
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191105134316.19294-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_ca0132.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -7604,7 +7604,7 @@ static void hp_callback(struct hda_codec
 	/* Delay enabling the HP amp, to let the mic-detection
 	 * state machine run.
 	 */
-	cancel_delayed_work_sync(&spec->unsol_hp_work);
+	cancel_delayed_work(&spec->unsol_hp_work);
 	schedule_delayed_work(&spec->unsol_hp_work, msecs_to_jiffies(500));
 	tbl = snd_hda_jack_tbl_get(codec, cb->nid);
 	if (tbl)


