Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6BC16AC0
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 20:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbfEGSxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 14:53:30 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42529 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbfEGSxa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 14:53:30 -0400
Received: by mail-pf1-f196.google.com with SMTP id 13so8808314pfw.9;
        Tue, 07 May 2019 11:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KRHKxRuysYGgXbbpO6rIqlLn4waiOgs8Pmx2aAZVU0c=;
        b=pc75Btdxymf408ZedJHdUp37dGFrkRgw8TkbRkyyn8UoVtXDi2pdzijYyJPK+3ziLc
         6ogOXccq+keIL6YyTb1Alk8hM6wc0uaaZ7ujkP3Rw7F58GLRcZRR7Vka/pACebpLITLb
         ZcjDfdQJiH7LgRsrLE4jplchGTnfHZhQwIbT7prYY3UB03V3803fBwnfXkk5WzET6T//
         JkuPdriYToR1dHzP7QBAA3sYFj4UX4QXhsxYKrlLyzO3/OyXoXm+ZMsEVpurTyJkfmnD
         YCkUeRzDSomTfmR3S59CBksA6+ujDSYdYWh5qG2sccugYlWwHnFVCwW8PBWl0m9K3sxG
         WTqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KRHKxRuysYGgXbbpO6rIqlLn4waiOgs8Pmx2aAZVU0c=;
        b=rlau2MRBvII87q7wum+dsCsjFYy+fpTFwwfbyswZ23xBoDyqQsvFxfMVl5S/RqQ93F
         Z+sThyA2YKtYgod8j9HsJV/Dq0oFNdCpuVuJ7Zox9PhC/WZzP2mMasOd1TDQnSTEPFGa
         hscryhTQFdyeWMrv34l8hE3WSo2AhmlFC4fFSWChMIUuJugZN/q0LL3lcpnxYfPDqHO0
         Pdlph8oC+8zVKijvd1pVYsUPa1VG0KfPi/4BwcfzAqJMwq1uxT92qnzgENm8ZzpiLU8W
         61pjFpyVh39D75oZSArjGtO4dM/9czf6sC1ZwQmttK82fOOHw3rs0TR35HOdvHQtut54
         ELbw==
X-Gm-Message-State: APjAAAUlIYFs660Te47Jh3oaga3zvq9b4GZFBKKIsJ9VDk1VNd/7ueUv
        /UXE2iJTNCe6j+XzcDV/IrZwvFpV
X-Google-Smtp-Source: APXvYqyi+fWAto7XDdqYbv7JImcBdCxW466JgklIplZkE8iDrqLTtzFV/ZwsdudpHkP0SMa10pYk4Q==
X-Received: by 2002:a62:164f:: with SMTP id 76mr43451592pfw.172.1557255209363;
        Tue, 07 May 2019 11:53:29 -0700 (PDT)
Received: from US-191-ENG0002.corp.onewacom.com ([50.225.60.4])
        by smtp.gmail.com with ESMTPSA id w189sm20085506pfw.147.2019.05.07.11.53.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 11:53:28 -0700 (PDT)
From:   "Gerecke, Jason" <killertofu@gmail.com>
X-Google-Original-From: "Gerecke, Jason" <jason.gerecke@wacom.com>
To:     linux-input@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Jason Gerecke <jason.gerecke@wacom.com>, stable@vger.kernel.org
Subject: [PATCH 3/3] HID: wacom: Sync INTUOSP2_BT touch state after each frame if necessary
Date:   Tue,  7 May 2019 11:53:22 -0700
Message-Id: <20190507185322.7168-3-jason.gerecke@wacom.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190507185322.7168-1-jason.gerecke@wacom.com>
References: <20190507185322.7168-1-jason.gerecke@wacom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gerecke <jason.gerecke@wacom.com>

The Bluetooth interface of the 2nd-gen Intuos Pro batches together four
independent "frames" of finger data into a single report. Each frame
is essentially equivalent to a single USB report, with the up-to-10
fingers worth of information being spread across two frames. At the
moment the driver only calls `input_sync` after processing all four
frames have been processed, which can result in the driver sending
multiple updates for a single slot within the same SYN_REPORT. This
can confuse userspace, so modify the driver to sync more often if
necessary (i.e., after reporting the state of all fingers).

Fixes: 4922cd26f0 ("HID: wacom: Support 2nd-gen Intuos Pro's Bluetooth classic interface")
Cc: <stable@vger.kernel.org> # 4.11+
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
---
 drivers/hid/wacom_wac.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index e848445236d8..09b8e4aac82f 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1371,11 +1371,17 @@ static void wacom_intuos_pro2_bt_touch(struct wacom_wac *wacom)
 		if (wacom->num_contacts_left <= 0) {
 			wacom->num_contacts_left = 0;
 			wacom->shared->touch_down = wacom_wac_finger_count_touches(wacom);
+			input_sync(touch_input);
 		}
 	}
 
-	input_report_switch(touch_input, SW_MUTE_DEVICE, !(data[281] >> 7));
-	input_sync(touch_input);
+	if (wacom->num_contacts_left == 0) {
+		// Be careful that we don't accidentally call input_sync with
+		// only a partial set of fingers of processed
+		input_report_switch(touch_input, SW_MUTE_DEVICE, !(data[281] >> 7));
+		input_sync(touch_input);
+	}
+
 }
 
 static void wacom_intuos_pro2_bt_pad(struct wacom_wac *wacom)
-- 
2.21.0

