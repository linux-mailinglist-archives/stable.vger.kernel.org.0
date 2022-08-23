Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7E1559D3AC
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241980AbiHWINW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241945AbiHWILz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:11:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37386B8DD;
        Tue, 23 Aug 2022 01:08:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E4876122D;
        Tue, 23 Aug 2022 08:08:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E53C433C1;
        Tue, 23 Aug 2022 08:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242137;
        bh=2bDFe3NcKWE6JLIhfhZBlJDKBAWCaKmBFXcKVPADIKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yWLxF9itBtPCBYhRb46g7lNGOpeieH1iGg6n3jnaVqH42xnlqaWBal96XLkjMmlWI
         iTXQ4w0BqkGJ3vf//1EIt6SkMZqadK7WM/Dg3BI/qezWTqM1TAn7A7HcKzlZIivtQz
         H4QrZ4Q/l0nzubKVf4TDrTTsGEW/YcJ1KbqaJ834=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mohan Kumar <mkumard@nvidia.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.19 038/365] ALSA: hda: Fix crash due to jack poll in suspend
Date:   Tue, 23 Aug 2022 09:58:59 +0200
Message-Id: <20220823080119.785095632@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Mohan Kumar <mkumard@nvidia.com>

commit 636aa8807b5780b76609b40cd3d3e1b5a225471c upstream.

With jackpoll_in_suspend flag set, there is a possibility that
jack poll worker thread will run even after system suspend was
completed. Any register access after system pm callback flow
will result in kernel crash as still jack poll worker thread
tries to access registers.

To fix the crash issue during system flow, cancel the jack poll
worker thread during system pm prepare callback and cancel the
worker thread at start of runtime suspend callback and re-schedule
at last to avoid any unwarranted access of register by worker thread
during suspend flow.

Signed-off-by: Mohan Kumar <mkumard@nvidia.com>
Fixes: b33115bd05af ("ALSA: hda: Jack detection poll in suspend state")
Link: https://lore.kernel.org/r/20220811052704.2944-1-mkumard@nvidia.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_codec.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -2935,8 +2935,7 @@ static int hda_codec_runtime_suspend(str
 	if (!codec->card)
 		return 0;
 
-	if (!codec->bus->jackpoll_in_suspend)
-		cancel_delayed_work_sync(&codec->jackpoll_work);
+	cancel_delayed_work_sync(&codec->jackpoll_work);
 
 	state = hda_call_codec_suspend(codec);
 	if (codec->link_down_at_suspend ||
@@ -2944,6 +2943,11 @@ static int hda_codec_runtime_suspend(str
 	     (state & AC_PWRST_CLK_STOP_OK)))
 		snd_hdac_codec_link_down(&codec->core);
 	snd_hda_codec_display_power(codec, false);
+
+	if (codec->bus->jackpoll_in_suspend &&
+		(dev->power.power_state.event != PM_EVENT_SUSPEND))
+		schedule_delayed_work(&codec->jackpoll_work,
+					codec->jackpoll_interval);
 	return 0;
 }
 
@@ -2967,6 +2971,9 @@ static int hda_codec_runtime_resume(stru
 #ifdef CONFIG_PM_SLEEP
 static int hda_codec_pm_prepare(struct device *dev)
 {
+	struct hda_codec *codec = dev_to_hda_codec(dev);
+
+	cancel_delayed_work_sync(&codec->jackpoll_work);
 	dev->power.power_state = PMSG_SUSPEND;
 	return pm_runtime_suspended(dev);
 }
@@ -2986,9 +2993,6 @@ static void hda_codec_pm_complete(struct
 
 static int hda_codec_pm_suspend(struct device *dev)
 {
-	struct hda_codec *codec = dev_to_hda_codec(dev);
-
-	cancel_delayed_work_sync(&codec->jackpoll_work);
 	dev->power.power_state = PMSG_SUSPEND;
 	return pm_runtime_force_suspend(dev);
 }


