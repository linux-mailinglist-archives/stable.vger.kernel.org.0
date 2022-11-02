Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D8A61579E
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiKBCf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiKBCfX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:35:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3298DF77
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:35:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A191B8206C
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50587C433C1;
        Wed,  2 Nov 2022 02:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356520;
        bh=cUFMIvZDVnqLC8W5AuvcbapmUapFJuqDzQqK3tiXo1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VKv9PqO1alcYDkBQ4w/RAA36cQKHQjJ0g8setMmhuQ8Uqq4bLs4rBr8OArOYYtKpy
         YzuKT59/AE23ebJjgq9SvXSeJZo0Hcqy9QmfQb1NBsjUAXeoQnbuiBSyksK4FfrubE
         v6yauHnW7FCEzHwK9F8hMan6Ha0GhbcTJ1q14dms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.0 014/240] ALSA: usb-audio: Use snd_ctl_rename() to rename a control
Date:   Wed,  2 Nov 2022 03:29:49 +0100
Message-Id: <20221102022111.730789532@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

commit 0b4f0debb34754002cee295441c9ca89ba8cdfcc upstream.

With the recent addition of hashed controls lookup it's not enough to just
update the control name field, the hash entries for the modified control
have to be updated too.

snd_ctl_rename() takes care of that, so use it instead of directly
modifying the control name.

Fixes: c27e1efb61c5 ("ALSA: control: Use xarray for faster lookups")
Cc: stable@vger.kernel.org
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Link: https://lore.kernel.org/r/723877882e3a56bb42a2a2214cfc85f347d36e19.1666296963.git.maciej.szmigiero@oracle.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index a5641956ef10..9105ec623120 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1631,7 +1631,7 @@ static void check_no_speaker_on_headset(struct snd_kcontrol *kctl,
 	if (!found)
 		return;
 
-	strscpy(kctl->id.name, "Headphone", sizeof(kctl->id.name));
+	snd_ctl_rename(card, kctl, "Headphone");
 }
 
 static const struct usb_feature_control_info *get_feature_control_info(int control)
-- 
2.38.1



