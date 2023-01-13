Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7667F669A49
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 15:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjAMOdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 09:33:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjAMOcj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 09:32:39 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8416AEE20;
        Fri, 13 Jan 2023 06:26:47 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id AEE356077A;
        Fri, 13 Jan 2023 14:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1673620005; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=ZlT0bW1RT1S/RjUud1OHBkBdTWci8dCpwsYwHEA60CU=;
        b=Jtmx8qSh10mse1aghzGf5O2OJpk2ANrzQQJ5UjROd+nkGRzzkpW181UYRfbFuNUdiZx/AR
        mP9smr3XuGiJPpkaCClRrUHpB5OLjkNkOmrbVeOKK3dxAkgSQRja2ayHRV2XxI7ks2di8b
        3SXt2oNX2EI1jeRd4c+CBnjsuRMGNGg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1673620005;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=ZlT0bW1RT1S/RjUud1OHBkBdTWci8dCpwsYwHEA60CU=;
        b=1XFKdmKo9XRjBZi/aLaSro2SdtveCWAwmQm5jYelTynOhKUoWeko+Nsx4AREXPY9iHKZt0
        LaJJafmXd/Vr/FDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 84F701358A;
        Fri, 13 Jan 2023 14:26:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id DeG5HyVqwWOTGAAAMHmgww
        (envelope-from <tiwai@suse.de>); Fri, 13 Jan 2023 14:26:45 +0000
From:   Takashi Iwai <tiwai@suse.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, Clement Lecigne <clecigne@google.com>
Subject: [PATCH 5.10.y] ALSA: pcm: Properly take rwsem lock in ctl_elem_read_user/ctl_elem_write_user to prevent UAF
Date:   Fri, 13 Jan 2023 15:26:39 +0100
Message-Id: <20230113142639.4420-1-tiwai@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Clement Lecigne <clecigne@google.com>

[ Note: this is a fix that works around the bug equivalently as the
  two upstream commits:
   1fa4445f9adf ("ALSA: control - introduce snd_ctl_notify_one() helper")
   56b88b50565c ("ALSA: pcm: Move rwsem lock inside snd_ctl_elem_read to prevent UAF")
  but in a simpler way to fit with older stable trees -- tiwai ]

Add missing locking in ctl_elem_read_user/ctl_elem_write_user which can be
easily triggered and turned into an use-after-free.

Example code paths with SNDRV_CTL_IOCTL_ELEM_READ:

64-bits:
snd_ctl_ioctl
  snd_ctl_elem_read_user
    [takes controls_rwsem]
    snd_ctl_elem_read [lock properly held, all good]
    [drops controls_rwsem]

32-bits (compat):
snd_ctl_ioctl_compat
  snd_ctl_elem_write_read_compat
    ctl_elem_write_read
      snd_ctl_elem_read [missing lock, not good]

CVE-2023-0266 was assigned for this issue.

Signed-off-by: Clement Lecigne <clecigne@google.com>
Cc: stable@kernel.org # 5.12 and older
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---

Greg, this is a patch for the last ALSA PCM UCM fix for the older
stable trees.  Please take this to 5.10.y and older stable trees.
Thanks!

 sound/core/control_compat.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/core/control_compat.c b/sound/core/control_compat.c
index 97467f6a32a1..980ab3580f1b 100644
--- a/sound/core/control_compat.c
+++ b/sound/core/control_compat.c
@@ -304,7 +304,9 @@ static int ctl_elem_read_user(struct snd_card *card,
 	err = snd_power_wait(card, SNDRV_CTL_POWER_D0);
 	if (err < 0)
 		goto error;
+	down_read(&card->controls_rwsem);
 	err = snd_ctl_elem_read(card, data);
+	up_read(&card->controls_rwsem);
 	if (err < 0)
 		goto error;
 	err = copy_ctl_value_to_user(userdata, valuep, data, type, count);
@@ -332,7 +334,9 @@ static int ctl_elem_write_user(struct snd_ctl_file *file,
 	err = snd_power_wait(card, SNDRV_CTL_POWER_D0);
 	if (err < 0)
 		goto error;
+	down_write(&card->controls_rwsem);
 	err = snd_ctl_elem_write(card, file, data);
+	up_write(&card->controls_rwsem);
 	if (err < 0)
 		goto error;
 	err = copy_ctl_value_to_user(userdata, valuep, data, type, count);
-- 
2.35.3

