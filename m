Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 665495B711E
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233100AbiIMOjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234211AbiIMOhM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:37:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A715C6B65D;
        Tue, 13 Sep 2022 07:20:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08010B80D87;
        Tue, 13 Sep 2022 14:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704C2C433C1;
        Tue, 13 Sep 2022 14:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078829;
        bh=sJERrPUAwCBI0ASN54+KpYx7+Q3ky4neYCJzCXJ+fOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u1q6r0pNEyuWWVFay3/TtAsdS7lR/+FpUCPURjltvWYm2jvn7HjuBRKS71xvldu2W
         ccyMGEtQFonDnczIHzXyLWFINYGF5gC8SC16var7Yv+dEWOV5EOFx0ZHZ7qPU2jvVH
         FhkTDwtigG3p5ZtvqbyGyKTPuCmVkBDSZNX2CksE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/121] ALSA: usb-audio: Register card again for iface over delayed_register option
Date:   Tue, 13 Sep 2022 16:04:23 +0200
Message-Id: <20220913140400.465277446@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
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
index ff5f8de1bc540..713b84d8d42f1 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -698,7 +698,7 @@ static bool check_delayed_register_option(struct snd_usb_audio *chip, int iface)
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



