Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91EE58DA4C
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730801AbfHNRON (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:14:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:38650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731039AbfHNROL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:14:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F319216F4;
        Wed, 14 Aug 2019 17:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802851;
        bh=Fm2JjAuPAaj54hkvlccJ9AYBgwBCVB+M2wApJGz79r0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hf3TOZeLCCMms4cDinV0zsbbQrI5Xdrsy+PHjJcVpgJOpBar3OMBdVMp4Zugh5SpA
         O4zcAaz6lE+SJLiKmqaVz0HCS5ZXaW3NDHzau4ytOLf52zDJdmqhJgZiAnC0tSmrhV
         E3s32jP/Pr+HJud5QAUoix/9IhGgm2slMG55S470=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Roderick Colenbrander <roderick.colenbrander@sony.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.14 51/69] HID: sony: Fix race condition between rumble and device remove.
Date:   Wed, 14 Aug 2019 19:01:49 +0200
Message-Id: <20190814165748.981740468@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165744.822314328@linuxfoundation.org>
References: <20190814165744.822314328@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roderick Colenbrander <roderick@gaikai.com>

commit e0f6974a54d3f7f1b5fdf5a593bd43ce9206ec04 upstream.

Valve reported a kernel crash on Ubuntu 18.04 when disconnecting a DS4
gamepad while rumble is enabled. This issue is reproducible with a
frequency of 1 in 3 times in the game Borderlands 2 when using an
automatic weapon, which triggers many rumble operations.

We found the issue to be a race condition between sony_remove and the
final device destruction by the HID / input system. The problem was
that sony_remove didn't clean some of its work_item state in
"struct sony_sc". After sony_remove work, the corresponding evdev
node was around for sufficient time for applications to still queue
rumble work after "sony_remove".

On pre-4.19 kernels the race condition caused a kernel crash due to a
NULL-pointer dereference as "sc->output_report_dmabuf" got freed during
sony_remove. On newer kernels this crash doesn't happen due the buffer
now being allocated using devm_kzalloc. However we can still queue work,
while the driver is an undefined state.

This patch fixes the described problem, by guarding the work_item
"state_worker" with an initialized variable, which we are setting back
to 0 on cleanup.

Signed-off-by: Roderick Colenbrander <roderick.colenbrander@sony.com>
CC: stable@vger.kernel.org
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-sony.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -578,10 +578,14 @@ static void sony_set_leds(struct sony_sc
 static inline void sony_schedule_work(struct sony_sc *sc,
 				      enum sony_worker which)
 {
+	unsigned long flags;
+
 	switch (which) {
 	case SONY_WORKER_STATE:
-		if (!sc->defer_initialization)
+		spin_lock_irqsave(&sc->lock, flags);
+		if (!sc->defer_initialization && sc->state_worker_initialized)
 			schedule_work(&sc->state_worker);
+		spin_unlock_irqrestore(&sc->lock, flags);
 		break;
 	case SONY_WORKER_HOTPLUG:
 		if (sc->hotplug_worker_initialized)
@@ -2488,13 +2492,18 @@ static inline void sony_init_output_repo
 
 static inline void sony_cancel_work_sync(struct sony_sc *sc)
 {
+	unsigned long flags;
+
 	if (sc->hotplug_worker_initialized)
 		cancel_work_sync(&sc->hotplug_worker);
-	if (sc->state_worker_initialized)
+	if (sc->state_worker_initialized) {
+		spin_lock_irqsave(&sc->lock, flags);
+		sc->state_worker_initialized = 0;
+		spin_unlock_irqrestore(&sc->lock, flags);
 		cancel_work_sync(&sc->state_worker);
+	}
 }
 
-
 static int sony_input_configured(struct hid_device *hdev,
 					struct hid_input *hidinput)
 {


