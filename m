Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71AF761579D
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiKBCfX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbiKBCfW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:35:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A5BDFB2
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:35:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7029B8206C
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:35:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C226C433D7;
        Wed,  2 Nov 2022 02:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356514;
        bh=41w9ZehxsUJD7T2aDceAR56OFmvf3uzjT+IyH2aXooc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aOcGwqwSXAK0tfG/7D8sDa1J50dBKCA7A+I14vjcimTH6hWYMdKFh/0NumBQbbqV6
         ds4uhVjqTd3IeI+lwTtUd34RARY5/++9O/UzdZK3Pfw/MweZ5dSuqvye3VlLhC8C0I
         I2tZkJx78xq2p7legAj+JAtUYCAOCWV+kZ4uMahI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.0 013/240] ALSA: ac97: Use snd_ctl_rename() to rename a control
Date:   Wed,  2 Nov 2022 03:29:48 +0100
Message-Id: <20221102022111.709183979@linuxfoundation.org>
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

commit 52d256cc71f546f67037100c64eb4fa3ae5e4704 upstream.

With the recent addition of hashed controls lookup it's not enough to just
update the control name field, the hash entries for the modified control
have to be updated too.

snd_ctl_rename() takes care of that, so use it instead of directly
modifying the control name.

While we are at it, check also that the new control name doesn't
accidentally overwrite the available buffer space.

Fixes: c27e1efb61c5 ("ALSA: control: Use xarray for faster lookups")
Cc: stable@vger.kernel.org
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Link: https://lore.kernel.org/r/adb68bfa0885ba4a2583794b828f8e20d23f67c7.1666296963.git.maciej.szmigiero@oracle.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/ac97/ac97_codec.c |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

--- a/sound/pci/ac97/ac97_codec.c
+++ b/sound/pci/ac97/ac97_codec.c
@@ -2655,11 +2655,18 @@ EXPORT_SYMBOL(snd_ac97_resume);
  */
 static void set_ctl_name(char *dst, const char *src, const char *suffix)
 {
-	if (suffix)
-		sprintf(dst, "%s %s", src, suffix);
-	else
-		strcpy(dst, src);
-}	
+	const size_t msize = SNDRV_CTL_ELEM_ID_NAME_MAXLEN;
+
+	if (suffix) {
+		if (snprintf(dst, msize, "%s %s", src, suffix) >= msize)
+			pr_warn("ALSA: AC97 control name '%s %s' truncated to '%s'\n",
+				src, suffix, dst);
+	} else {
+		if (strscpy(dst, src, msize) < 0)
+			pr_warn("ALSA: AC97 control name '%s' truncated to '%s'\n",
+				src, dst);
+	}
+}
 
 /* remove the control with the given name and optional suffix */
 static int snd_ac97_remove_ctl(struct snd_ac97 *ac97, const char *name,
@@ -2686,8 +2693,11 @@ static int snd_ac97_rename_ctl(struct sn
 			       const char *dst, const char *suffix)
 {
 	struct snd_kcontrol *kctl = ctl_find(ac97, src, suffix);
+	char name[SNDRV_CTL_ELEM_ID_NAME_MAXLEN];
+
 	if (kctl) {
-		set_ctl_name(kctl->id.name, dst, suffix);
+		set_ctl_name(name, dst, suffix);
+		snd_ctl_rename(ac97->bus->card, kctl, name);
 		return 0;
 	}
 	return -ENOENT;
@@ -2706,11 +2716,17 @@ static int snd_ac97_swap_ctl(struct snd_
 			     const char *s2, const char *suffix)
 {
 	struct snd_kcontrol *kctl1, *kctl2;
+	char name[SNDRV_CTL_ELEM_ID_NAME_MAXLEN];
+
 	kctl1 = ctl_find(ac97, s1, suffix);
 	kctl2 = ctl_find(ac97, s2, suffix);
 	if (kctl1 && kctl2) {
-		set_ctl_name(kctl1->id.name, s2, suffix);
-		set_ctl_name(kctl2->id.name, s1, suffix);
+		set_ctl_name(name, s2, suffix);
+		snd_ctl_rename(ac97->bus->card, kctl1, name);
+
+		set_ctl_name(name, s1, suffix);
+		snd_ctl_rename(ac97->bus->card, kctl2, name);
+
 		return 0;
 	}
 	return -ENOENT;


