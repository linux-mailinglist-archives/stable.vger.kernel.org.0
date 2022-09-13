Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A22565B703B
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbiIMOYX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233506AbiIMOX3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:23:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CEFA6582E;
        Tue, 13 Sep 2022 07:15:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 620F4B80F92;
        Tue, 13 Sep 2022 14:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79B4C433C1;
        Tue, 13 Sep 2022 14:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078428;
        bh=EDmDKHaS1uAB/QJUtVd3usJP3x9nOJphch1EmVJxi+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rhhaNeUIAz+Xvn+96wkkvpDGTGdeOS2ofd/wo4Ww1RkI1a3e2XalBYhZFtUfXeXUf
         hzkllo/skTShBWG5/8jG3hbwLJT/lwz8z9VUHe1XymNh+Xjt79PhwsMeQe29F9zMcR
         ALBbDcpXRHT6JYyne42Rl5AHcxLNIrHrIVkFtw6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 109/192] ALSA: usb-audio: Register card again for iface over delayed_register option
Date:   Tue, 13 Sep 2022 16:03:35 +0200
Message-Id: <20220913140415.405011620@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 2027f114686e0f3f1f39971964dfc618637c88c2 ]

When the delayed registration is specified via either delayed_register
option or the quirk, we delay the invocation of snd_card_register()
until the given interface.  But if a wrong value has been set there
and there are more interfaces over the given interface number,
snd_card_register() call would be missing for those interfaces.

This patch catches up those missing calls by fixing the comparison of
the interface number.  Now the call is skipped only if the processed
interface is less than the given interface, instead of the exact
match.

Fixes: b70038ef4fea ("ALSA: usb-audio: Add delayed_register option")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216082
Link: https://lore.kernel.org/r/20220831125901.4660-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/card.c   | 2 +-
 sound/usb/quirks.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/usb/card.c b/sound/usb/card.c
index d356743de2ff9..706d249a9ad6b 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -699,7 +699,7 @@ static bool check_delayed_register_option(struct snd_usb_audio *chip, int iface)
 		if (delayed_register[i] &&
 		    sscanf(delayed_register[i], "%x:%x", &id, &inum) == 2 &&
 		    id == chip->usb_id)
-			return inum != iface;
+			return iface < inum;
 	}
 
 	return false;
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 9bfead5efc4c1..5b4d8f5eade20 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1764,7 +1764,7 @@ bool snd_usb_registration_quirk(struct snd_usb_audio *chip, int iface)
 
 	for (q = registration_quirks; q->usb_id; q++)
 		if (chip->usb_id == q->usb_id)
-			return iface != q->interface;
+			return iface < q->interface;
 
 	/* Register as normal */
 	return false;
-- 
2.35.1



