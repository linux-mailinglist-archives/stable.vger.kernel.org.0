Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 380365AB08C
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237970AbiIBMyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236398AbiIBMxU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:53:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0581AFAC5E;
        Fri,  2 Sep 2022 05:38:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B130B82A99;
        Fri,  2 Sep 2022 12:37:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7CDFC433C1;
        Fri,  2 Sep 2022 12:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122226;
        bh=dQCyYYdHFTcYP0ibPebQBQKt6XsoJLS/blVx6w2TSvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iifTHv9PuRq/LAmziGZ+CuAmQ8XsN3BdH0DvTfJ+O7p+SEUAjynpkuSE17/u6HWXu
         09RXXx5riEDZ3+QMVrhQ9kRnlmrO8bq4lrFu0a3mh86opLLSj6RAuCinAERGx1Jiyg
         gcfllfhvjwrjMRkG/jLEi+jvOtU863nS1ml4dHEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Daniel J. Ogorchock" <djogorchock@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.19 25/72] HID: nintendo: fix rumble worker null pointer deref
Date:   Fri,  2 Sep 2022 14:19:01 +0200
Message-Id: <20220902121405.623143625@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Daniel J. Ogorchock <djogorchock@gmail.com>

commit 1ff89e06c2e5fab30274e4b02360d4241d6e605e upstream.

We can dereference a null pointer trying to queue work to a destroyed
workqueue.

If the device is disconnected, nintendo_hid_remove is called, in which
the rumble_queue is destroyed. Avoid using that queue to defer rumble
work once the controller state is set to JOYCON_CTLR_STATE_REMOVED.

This eliminates the null pointer dereference.

Signed-off-by: Daniel J. Ogorchock <djogorchock@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-nintendo.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-nintendo.c
+++ b/drivers/hid/hid-nintendo.c
@@ -1222,6 +1222,7 @@ static void joycon_parse_report(struct j
 
 	spin_lock_irqsave(&ctlr->lock, flags);
 	if (IS_ENABLED(CONFIG_NINTENDO_FF) && rep->vibrator_report &&
+	    ctlr->ctlr_state != JOYCON_CTLR_STATE_REMOVED &&
 	    (msecs - ctlr->rumble_msecs) >= JC_RUMBLE_PERIOD_MS &&
 	    (ctlr->rumble_queue_head != ctlr->rumble_queue_tail ||
 	     ctlr->rumble_zero_countdown > 0)) {
@@ -1546,12 +1547,13 @@ static int joycon_set_rumble(struct joyc
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
 


