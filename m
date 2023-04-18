Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E13566E61C6
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjDRM1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbjDRM1k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:27:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CC849EF
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:27:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 600D963149
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:26:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7527AC433D2;
        Tue, 18 Apr 2023 12:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820788;
        bh=TfKQsbHvsJVN/EJTm8/vLJSLbZiXxdnZY47olDoJwUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=osq6Yww5JatmhdWeNeIagRsPF6jDtB0dcEEyncbZyFYNbr3YJAespY3v0an+wFi6f
         dfG0joOr2D2ahdXNaW7EQvkNNCtl7Q10q/3FZX6mW18OOGBkI3tNAEvpe3epgWYio6
         EMn7CZDBUIur2hhsX8QYo2Tzhom7uWSNQ8wGwwrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 31/57] ALSA: i2c/cs8427: fix iec958 mixer control deactivation
Date:   Tue, 18 Apr 2023 14:21:31 +0200
Message-Id: <20230418120259.841522022@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120258.713853188@linuxfoundation.org>
References: <20230418120258.713853188@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>

commit e98e7a82bca2b6dce3e03719cff800ec913f9af7 upstream.

snd_cs8427_iec958_active() would always delete
SNDRV_CTL_ELEM_ACCESS_INACTIVE, even though the function has an
argument `active`.

Signed-off-by: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230405201219.2197811-1-oswald.buddenhagen@gmx.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/i2c/cs8427.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/sound/i2c/cs8427.c
+++ b/sound/i2c/cs8427.c
@@ -568,10 +568,13 @@ int snd_cs8427_iec958_active(struct snd_
 	if (snd_BUG_ON(!cs8427))
 		return -ENXIO;
 	chip = cs8427->private_data;
-	if (active)
+	if (active) {
 		memcpy(chip->playback.pcm_status,
 		       chip->playback.def_status, 24);
-	chip->playback.pcm_ctl->vd[0].access &= ~SNDRV_CTL_ELEM_ACCESS_INACTIVE;
+		chip->playback.pcm_ctl->vd[0].access &= ~SNDRV_CTL_ELEM_ACCESS_INACTIVE;
+	} else {
+		chip->playback.pcm_ctl->vd[0].access |= SNDRV_CTL_ELEM_ACCESS_INACTIVE;
+	}
 	snd_ctl_notify(cs8427->bus->card,
 		       SNDRV_CTL_EVENT_MASK_VALUE | SNDRV_CTL_EVENT_MASK_INFO,
 		       &chip->playback.pcm_ctl->id);


