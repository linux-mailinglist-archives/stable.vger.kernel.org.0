Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 900AF5B4933
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbiIJVSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbiIJVRc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:17:32 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B34F4C600;
        Sat, 10 Sep 2022 14:17:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A35E0CE0AE8;
        Sat, 10 Sep 2022 21:16:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A874C43140;
        Sat, 10 Sep 2022 21:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844616;
        bh=+9DHORVupybjs9vxMMqRyoCkvWMizkXZU0o2NK9uums=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iqsl1AitIr0Jj8qFrhEMnE6hLJh2YiQo3VIGFifNQODtBzwetIVB3gfF9BxSxcJzO
         kg0uyl4OXhwqdAFez+ZBDMcYOLapfBcg5K8KD3y/IYZc87DjjTMcsv+osOx0CDGnU9
         pX0K3oYes+Bweqemcyx3dQAFJ1S0k0hx0Mi/2T9wc7PBoeB0qmbl3V6GIjNvN/Edr5
         fXGI3FPBZkZnMsGOYZDYLC3i2Cmeatj+1APNz6MB+z9EG/7duI4c32bTRIsqO2yq+w
         du1SPDBic2m2ybURh1xE4fdvAp4rL2arQCxdDxIYRfBCA1i8JG8hdvjVI3Fmn/+LL5
         suXfEewC8Eo4A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Daniel J. Ogorchock" <djogorchock@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 17/38] HID: nintendo: fix rumble worker null pointer deref
Date:   Sat, 10 Sep 2022 17:16:02 -0400
Message-Id: <20220910211623.69825-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211623.69825-1-sashal@kernel.org>
References: <20220910211623.69825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Daniel J. Ogorchock" <djogorchock@gmail.com>

[ Upstream commit 1ff89e06c2e5fab30274e4b02360d4241d6e605e ]

We can dereference a null pointer trying to queue work to a destroyed
workqueue.

If the device is disconnected, nintendo_hid_remove is called, in which
the rumble_queue is destroyed. Avoid using that queue to defer rumble
work once the controller state is set to JOYCON_CTLR_STATE_REMOVED.

This eliminates the null pointer dereference.

Signed-off-by: Daniel J. Ogorchock <djogorchock@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-nintendo.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-nintendo.c b/drivers/hid/hid-nintendo.c
index 4b1173957c17c..f33a03c96ba68 100644
--- a/drivers/hid/hid-nintendo.c
+++ b/drivers/hid/hid-nintendo.c
@@ -1222,6 +1222,7 @@ static void joycon_parse_report(struct joycon_ctlr *ctlr,
 
 	spin_lock_irqsave(&ctlr->lock, flags);
 	if (IS_ENABLED(CONFIG_NINTENDO_FF) && rep->vibrator_report &&
+	    ctlr->ctlr_state != JOYCON_CTLR_STATE_REMOVED &&
 	    (msecs - ctlr->rumble_msecs) >= JC_RUMBLE_PERIOD_MS &&
 	    (ctlr->rumble_queue_head != ctlr->rumble_queue_tail ||
 	     ctlr->rumble_zero_countdown > 0)) {
@@ -1546,12 +1547,13 @@ static int joycon_set_rumble(struct joycon_ctlr *ctlr, u16 amp_r, u16 amp_l,
 		ctlr->rumble_queue_head = 0;
 	memcpy(ctlr->rumble_data[ctlr->rumble_queue_head], data,
 	       JC_RUMBLE_DATA_SIZE);
-	spin_unlock_irqrestore(&ctlr->lock, flags);
 
 	/* don't wait for the periodic send (reduces latency) */
-	if (schedule_now)
+	if (schedule_now && ctlr->ctlr_state != JOYCON_CTLR_STATE_REMOVED)
 		queue_work(ctlr->rumble_queue, &ctlr->rumble_worker);
 
+	spin_unlock_irqrestore(&ctlr->lock, flags);
+
 	return 0;
 }
 
-- 
2.35.1

