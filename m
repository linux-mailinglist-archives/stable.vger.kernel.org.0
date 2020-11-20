Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F0A2BA87F
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgKTLIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:08:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:55794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727160AbgKTLH6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:07:58 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE1E62222F;
        Fri, 20 Nov 2020 11:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870476;
        bh=DJS4WfM+dre9YyUbSNAmJkskNFk84dzyRK0Eh8YC6hE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jvfYdvYw8awQRdGGnDyo+DONFY/dlfkCiVFcF+IbuwBu2dpKE7L2rIdAPRk3A9cRR
         YRSndFq6hghLIDzwaM58+Px3ucM9gnvkK8A6M040KzJX3t+VpJ3f0yZxVAxkYsAic0
         9KjUC0FDSp0rF6yDU3Pab6gyPOKZWrGIKxu94KO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bodong Zhao <nopitydays@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.9 07/14] Input: sunkbd - avoid use-after-free in teardown paths
Date:   Fri, 20 Nov 2020 12:03:45 +0100
Message-Id: <20201120104541.532175373@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104541.168007611@linuxfoundation.org>
References: <20201120104541.168007611@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 77e70d351db7de07a46ac49b87a6c3c7a60fca7e upstream.

We need to make sure we cancel the reinit work before we tear down the
driver structures.

Reported-by: Bodong Zhao <nopitydays@gmail.com>
Tested-by: Bodong Zhao <nopitydays@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/keyboard/sunkbd.c |   41 ++++++++++++++++++++++++++++++++--------
 1 file changed, 33 insertions(+), 8 deletions(-)

--- a/drivers/input/keyboard/sunkbd.c
+++ b/drivers/input/keyboard/sunkbd.c
@@ -99,7 +99,8 @@ static irqreturn_t sunkbd_interrupt(stru
 	switch (data) {
 
 	case SUNKBD_RET_RESET:
-		schedule_work(&sunkbd->tq);
+		if (sunkbd->enabled)
+			schedule_work(&sunkbd->tq);
 		sunkbd->reset = -1;
 		break;
 
@@ -200,16 +201,12 @@ static int sunkbd_initialize(struct sunk
 }
 
 /*
- * sunkbd_reinit() sets leds and beeps to a state the computer remembers they
- * were in.
+ * sunkbd_set_leds_beeps() sets leds and beeps to a state the computer remembers
+ * they were in.
  */
 
-static void sunkbd_reinit(struct work_struct *work)
+static void sunkbd_set_leds_beeps(struct sunkbd *sunkbd)
 {
-	struct sunkbd *sunkbd = container_of(work, struct sunkbd, tq);
-
-	wait_event_interruptible_timeout(sunkbd->wait, sunkbd->reset >= 0, HZ);
-
 	serio_write(sunkbd->serio, SUNKBD_CMD_SETLED);
 	serio_write(sunkbd->serio,
 		(!!test_bit(LED_CAPSL,   sunkbd->dev->led) << 3) |
@@ -222,11 +219,39 @@ static void sunkbd_reinit(struct work_st
 		SUNKBD_CMD_BELLOFF - !!test_bit(SND_BELL, sunkbd->dev->snd));
 }
 
+
+/*
+ * sunkbd_reinit() wait for the keyboard reset to complete and restores state
+ * of leds and beeps.
+ */
+
+static void sunkbd_reinit(struct work_struct *work)
+{
+	struct sunkbd *sunkbd = container_of(work, struct sunkbd, tq);
+
+	/*
+	 * It is OK that we check sunkbd->enabled without pausing serio,
+	 * as we only want to catch true->false transition that will
+	 * happen once and we will be woken up for it.
+	 */
+	wait_event_interruptible_timeout(sunkbd->wait,
+					 sunkbd->reset >= 0 || !sunkbd->enabled,
+					 HZ);
+
+	if (sunkbd->reset >= 0 && sunkbd->enabled)
+		sunkbd_set_leds_beeps(sunkbd);
+}
+
 static void sunkbd_enable(struct sunkbd *sunkbd, bool enable)
 {
 	serio_pause_rx(sunkbd->serio);
 	sunkbd->enabled = enable;
 	serio_continue_rx(sunkbd->serio);
+
+	if (!enable) {
+		wake_up_interruptible(&sunkbd->wait);
+		cancel_work_sync(&sunkbd->tq);
+	}
 }
 
 /*


