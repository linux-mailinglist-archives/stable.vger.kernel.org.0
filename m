Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9495C65D81E
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239689AbjADQLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:11:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239859AbjADQKa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:10:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133593AAB2
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:10:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0C6FB8172E
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:10:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21036C433F0;
        Wed,  4 Jan 2023 16:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848626;
        bh=fNErMzxMKX19kt/Pb5Knw5FCuKABVhkbDw5UzVqLp3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qiUcvQTE5mw+31VumaA7yy4RjPFTkmmywnsH1JBmv55NvXe/6bR9XkZSMKJLN9pbh
         iV7JkyVXfDeByROuG/lvxgU4uD6D/ERS9JKfcTTVWOaT5bPkL4g4jwpW+lWUsy680f
         S1FnXvh+NMVX+GG1drFNJmM0BpVurDiEEmbnSEbs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Eray=20Or=C3=A7unus?= <erayorcunus@gmail.com>,
        Ike Panhc <ike.pan@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/207] platform/x86: ideapad-laptop: Revert "check for touchpad support in _CFG"
Date:   Wed,  4 Jan 2023 17:05:01 +0100
Message-Id: <20230104160513.278672340@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eray Orçunus <erayorcunus@gmail.com>

[ Upstream commit 5831882880e9a1749553e78f9d8369fe33116aaf ]

Last 8 bit of _CFG started being used in later IdeaPads, thus 30th bit
doesn't always show whether device supports touchpad or touchpad switch.
Remove checking bit 30 of _CFG, so older IdeaPads like S10-3 can switch
touchpad again via touchpad attribute.

This reverts commit b3ed1b7fe378 ("platform/x86: ideapad-laptop: check for
touchpad support in _CFG").

Signed-off-by: Eray Orçunus <erayorcunus@gmail.com>
Acked-by: Ike Panhc <ike.pan@canonical.com>
Link: https://lore.kernel.org/r/20221029120311.11152-2-erayorcunus@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/ideapad-laptop.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 3ea8fc6a9ca3..7192e0d2a14f 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -46,11 +46,10 @@ static const char *const ideapad_wmi_fnesc_events[] = {
 #endif
 
 enum {
-	CFG_CAP_BT_BIT       = 16,
-	CFG_CAP_3G_BIT       = 17,
-	CFG_CAP_WIFI_BIT     = 18,
-	CFG_CAP_CAM_BIT      = 19,
-	CFG_CAP_TOUCHPAD_BIT = 30,
+	CFG_CAP_BT_BIT   = 16,
+	CFG_CAP_3G_BIT   = 17,
+	CFG_CAP_WIFI_BIT = 18,
+	CFG_CAP_CAM_BIT  = 19,
 };
 
 enum {
@@ -386,8 +385,6 @@ static int debugfs_cfg_show(struct seq_file *s, void *data)
 		seq_puts(s, " wifi");
 	if (test_bit(CFG_CAP_CAM_BIT, &priv->cfg))
 		seq_puts(s, " camera");
-	if (test_bit(CFG_CAP_TOUCHPAD_BIT, &priv->cfg))
-		seq_puts(s, " touchpad");
 	seq_puts(s, "\n");
 
 	seq_puts(s, "Graphics: ");
@@ -680,8 +677,7 @@ static umode_t ideapad_is_visible(struct kobject *kobj,
 	else if (attr == &dev_attr_fn_lock.attr)
 		supported = priv->features.fn_lock;
 	else if (attr == &dev_attr_touchpad.attr)
-		supported = priv->features.touchpad_ctrl_via_ec &&
-			    test_bit(CFG_CAP_TOUCHPAD_BIT, &priv->cfg);
+		supported = priv->features.touchpad_ctrl_via_ec;
 	else if (attr == &dev_attr_usb_charging.attr)
 		supported = priv->features.usb_charging;
 
-- 
2.35.1



