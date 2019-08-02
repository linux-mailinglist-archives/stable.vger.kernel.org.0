Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90545802FA
	for <lists+stable@lfdr.de>; Sat,  3 Aug 2019 00:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392510AbfHBWuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 18:50:39 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:43522 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728242AbfHBWuj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 18:50:39 -0400
Received: by mail-qk1-f193.google.com with SMTP id m14so30364135qka.10
        for <stable@vger.kernel.org>; Fri, 02 Aug 2019 15:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gaikai-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Tja/rnzyaAh8gsKSK1OOyf54h/AbzBbU3B6v85SaNi0=;
        b=X7d3mXzXHUe57gBnrolOs41evy2vsrnhtyhp4CcljHPKqmJ3nPDqu3ZYut6mmkwx1h
         C+omLV004sCHlUP6r6/YCKjD/Fs2oRAuGGqMFCYXHkbEz0Vp0dsI8e8kBz8UuYF/D4gT
         OVZnf5CUHEEM3SnO2CNYYrgZ/H7uhC+eyBzDmfc3BEmDUvhGSS6iT0OuJVqB4YzHo1WK
         qBYek2jJ8O+midgVFW5kbulUy5OZL1n4TOC8sjEcslPge/wMvVAAt3MwnSmebinWUoGS
         F6GahsRx+nRZ5qnJpmNISDersO2ZOHMHCDGW8jpDVprVz7wRsLHA1SHAtHSzLgLYmsrf
         /I/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Tja/rnzyaAh8gsKSK1OOyf54h/AbzBbU3B6v85SaNi0=;
        b=VFieGq1CS8kAVRZJ9qzModUg2V0opR8/v08QpKgl7CkMdIbcuUtC0Hbcl6LMRbzRFx
         lqhibETarOPm41Ey5uZApF9S22AWq70olS0EjuSdKpTNQYQ48kFH5fQ0RujM5xMkVxs3
         1LJSPy0vrhLnRgEeWgq/PCKGG7gdAGOf2ch5T+y1mjVJW0fqWogqnCvYqNseenqP/1tV
         qE/q7HvBCTSZTjG2Ea5P6e3C7PH0wjDCqTpHzGYOmT+Iqx8Xjn3ncHaJCO4jfchwgaqv
         p/lWvSqZ8N9YxPcql0ajVnPQazksT2Waylto7e9hpb65Q06UUiisGbre5Hvbi1+Hzopd
         reGg==
X-Gm-Message-State: APjAAAUeuMCl1dugfzJDX+2/ZbtI7CJp1QESWOzf1hMwQMUe5taZZg8S
        qMRNMY3ab9yzxhkH4e6oa2RtKg==
X-Google-Smtp-Source: APXvYqw08XievE2j+tzs+ukHUHUGRWwwncwi4TSbAs+j2f1TGZX2BZJbxd9ku+ttp11klIyBrgqdzg==
X-Received: by 2002:a37:5204:: with SMTP id g4mr87976070qkb.35.1564786238584;
        Fri, 02 Aug 2019 15:50:38 -0700 (PDT)
Received: from roderick.ad.gaikai.biz ([100.42.98.196])
        by smtp.gmail.com with ESMTPSA id t6sm33374168qkh.129.2019.08.02.15.50.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 15:50:36 -0700 (PDT)
From:   Roderick Colenbrander <roderick@gaikai.com>
To:     linux-input@vger.kernel.org, jikos@kernel.org,
        benjamin.tissoires@redhat.com
Cc:     svv@google.com, pgriffais@valvesoftware.com,
        Roderick Colenbrander <roderick@gaikai.com>,
        Roderick Colenbrander <roderick.colenbrander@sony.com>,
        stable@vger.kernel.org
Subject: [PATCH] HID: sony: Fix race condition between rumble and device remove.
Date:   Fri,  2 Aug 2019 15:50:19 -0700
Message-Id: <20190802225019.2418-1-roderick@gaikai.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/hid/hid-sony.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index 9671a4bad643..31f1023214d3 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -587,10 +587,14 @@ static void sony_set_leds(struct sony_sc *sc);
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
@@ -2553,13 +2557,18 @@ static inline void sony_init_output_report(struct sony_sc *sc,
 
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
-- 
2.21.0

