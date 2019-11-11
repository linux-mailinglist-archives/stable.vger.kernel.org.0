Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28BE8F7B59
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfKKSfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:35:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:53244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728503AbfKKSfW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:35:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 474592173B;
        Mon, 11 Nov 2019 18:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497321;
        bh=O8JqrFNL5fiRfUfBZHt8d/7Bp/awQ18JHCgSuhlLIGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SuLXTfTSXiffYgm4TxU7JMtisgdfhbi2Pt/gr4XjE7gDSv6hffq07dYeQ2GhBwyR8
         qsxbhR+CI3tBRdNgOYmS625cNkDL+7ILiup8xdZvwi36ptmXaPk8pvcpV5NXi7/VaJ
         q2Oudxu4WW/BoplzXgqG2sQuCAcTwe/Dmuplsz3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 014/105] ALSA: hda/ca0132 - Fix possible workqueue stall
Date:   Mon, 11 Nov 2019 19:27:44 +0100
Message-Id: <20191111181430.867150113@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
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
@@ -4440,7 +4440,7 @@ static void hp_callback(struct hda_codec
 	/* Delay enabling the HP amp, to let the mic-detection
 	 * state machine run.
 	 */
-	cancel_delayed_work_sync(&spec->unsol_hp_work);
+	cancel_delayed_work(&spec->unsol_hp_work);
 	schedule_delayed_work(&spec->unsol_hp_work, msecs_to_jiffies(500));
 	tbl = snd_hda_jack_tbl_get(codec, cb->nid);
 	if (tbl)


