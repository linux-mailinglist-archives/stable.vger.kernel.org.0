Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD6D06AEA6D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbjCGRdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:33:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbjCGRdV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:33:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7519C96614
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:29:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E10861501
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:29:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92843C433EF;
        Tue,  7 Mar 2023 17:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210140;
        bh=6/OwhqZEoCnWMvzWTG606iTH0y7ZrDpAltPe5w4+44o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GHbEbc3274JqQhhZK5E8uGQydRDvidTmeCNj2VHyZr4QyxHfh35G79jI8U7KS9592
         O+ZZ13t4X/ABg0hoXN4Aa5L8D2801z5RAdlUFyFS0fmRc7KsnjKmmDvJF/wizjAJwA
         7Xu2VQ3H6kZOYeDabqZ6B1qkAcqiZ2x4LajMkHts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Pietro Borrello <borrello@diag.uniroma1.it>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0445/1001] HID: bigben: use spinlock to safely schedule workers
Date:   Tue,  7 Mar 2023 17:53:37 +0100
Message-Id: <20230307170040.665533798@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pietro Borrello <borrello@diag.uniroma1.it>

[ Upstream commit 76ca8da989c7d97a7f76c75d475fe95a584439d7 ]

Use spinlocks to deal with workers introducing a wrapper
bigben_schedule_work(), and several spinlock checks.
Otherwise, bigben_set_led() may schedule bigben->worker after the
structure has been freed, causing a use-after-free.

Fixes: 4eb1b01de5b9 ("HID: hid-bigbenff: fix race condition for scheduled work during removal")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
Link: https://lore.kernel.org/r/20230125-hid-unregister-leds-v4-3-7860c5763c38@diag.uniroma1.it
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-bigbenff.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-bigbenff.c b/drivers/hid/hid-bigbenff.c
index b98c5f31c184b..9d6560db762b1 100644
--- a/drivers/hid/hid-bigbenff.c
+++ b/drivers/hid/hid-bigbenff.c
@@ -185,6 +185,15 @@ struct bigben_device {
 	struct work_struct worker;
 };
 
+static inline void bigben_schedule_work(struct bigben_device *bigben)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&bigben->lock, flags);
+	if (!bigben->removed)
+		schedule_work(&bigben->worker);
+	spin_unlock_irqrestore(&bigben->lock, flags);
+}
 
 static void bigben_worker(struct work_struct *work)
 {
@@ -197,9 +206,6 @@ static void bigben_worker(struct work_struct *work)
 	u32 len;
 	unsigned long flags;
 
-	if (bigben->removed)
-		return;
-
 	buf = hid_alloc_report_buf(bigben->report, GFP_KERNEL);
 	if (!buf)
 		return;
@@ -285,7 +291,7 @@ static int hid_bigben_play_effect(struct input_dev *dev, void *data,
 		bigben->work_ff = true;
 		spin_unlock_irqrestore(&bigben->lock, flags);
 
-		schedule_work(&bigben->worker);
+		bigben_schedule_work(bigben);
 	}
 
 	return 0;
@@ -320,7 +326,7 @@ static void bigben_set_led(struct led_classdev *led,
 
 			if (work) {
 				bigben->work_led = true;
-				schedule_work(&bigben->worker);
+				bigben_schedule_work(bigben);
 			}
 			return;
 		}
@@ -450,7 +456,7 @@ static int bigben_probe(struct hid_device *hid,
 	bigben->left_motor_force = 0;
 	bigben->work_led = true;
 	bigben->work_ff = true;
-	schedule_work(&bigben->worker);
+	bigben_schedule_work(bigben);
 
 	hid_info(hid, "LED and force feedback support for BigBen gamepad\n");
 
-- 
2.39.2



