Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C889A6E6143
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbjDRMYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbjDRMYm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:24:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440D5449E
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:24:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94CB363108
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:24:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A462FC433EF;
        Tue, 18 Apr 2023 12:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820654;
        bh=TfKQsbHvsJVN/EJTm8/vLJSLbZiXxdnZY47olDoJwUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mpzDU8Z6To5s/rYfq/bnb/l74qKNMeh2e0K2LpJ+s98XQRFN5f3vblCceXKWlcCkC
         vv4Zsik7FZ6IAiaFMTojVnxju2z1+2/7ZdRnaKURMPfx+z1SoJONBvGoDGmblCzBPC
         QfGaeF0xaVsfJYeR33Dxiv0X3Ch5isocFSvoDjFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 19/37] ALSA: i2c/cs8427: fix iec958 mixer control deactivation
Date:   Tue, 18 Apr 2023 14:21:29 +0200
Message-Id: <20230418120255.343603558@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120254.687480980@linuxfoundation.org>
References: <20230418120254.687480980@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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


