Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFF3D615798
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiKBCfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiKBCfA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:35:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE87864FD
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:34:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C1D3617C6
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CDE6C433C1;
        Wed,  2 Nov 2022 02:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356497;
        bh=4z+kAOHLkIbJgYFTVq7szGwdgLK6tjTQB2aO+4msHxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yJ6SiDxSgsSysLS1qgBEL6Mhv8R3lH1lIRohdlUxumnmLwApWsd40ZH8IAqidRj01
         XtztgCkQvO8z2krLTe81TX0S+JQXuKll5LFEXh91RKXrzGiZT2xRwRQZF4GseeJmfP
         0lHraBTWduK+gFUcPo5ry4JunuT2Nqx31UTcM0Ig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.0 010/240] ALSA: control: add snd_ctl_rename()
Date:   Wed,  2 Nov 2022 03:29:45 +0100
Message-Id: <20221102022111.641991946@linuxfoundation.org>
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

commit 966f015fe4329199cc49084ee2886cfb626b34d3 upstream.

Add a snd_ctl_rename() function that takes care of updating the control
hash entries for callers that already have the relevant struct snd_kcontrol
at hand and hold the control write lock (or simply haven't registered the
card yet).

Fixes: c27e1efb61c5 ("ALSA: control: Use xarray for faster lookups")
Cc: stable@vger.kernel.org
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Link: https://lore.kernel.org/r/4170b71117ea81357a4f7eb8410f7cde20836c70.1666296963.git.maciej.szmigiero@oracle.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/sound/control.h |  1 +
 sound/core/control.c    | 23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/sound/control.h b/include/sound/control.h
index eae443ba79ba..cc3dcc6cfb0f 100644
--- a/include/sound/control.h
+++ b/include/sound/control.h
@@ -138,6 +138,7 @@ int snd_ctl_remove(struct snd_card * card, struct snd_kcontrol * kcontrol);
 int snd_ctl_replace(struct snd_card *card, struct snd_kcontrol *kcontrol, bool add_on_replace);
 int snd_ctl_remove_id(struct snd_card * card, struct snd_ctl_elem_id *id);
 int snd_ctl_rename_id(struct snd_card * card, struct snd_ctl_elem_id *src_id, struct snd_ctl_elem_id *dst_id);
+void snd_ctl_rename(struct snd_card *card, struct snd_kcontrol *kctl, const char *name);
 int snd_ctl_activate_id(struct snd_card *card, struct snd_ctl_elem_id *id, int active);
 struct snd_kcontrol *snd_ctl_find_numid(struct snd_card * card, unsigned int numid);
 struct snd_kcontrol *snd_ctl_find_id(struct snd_card * card, struct snd_ctl_elem_id *id);
diff --git a/sound/core/control.c b/sound/core/control.c
index a7271927d875..50e7ba66f187 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -753,6 +753,29 @@ int snd_ctl_rename_id(struct snd_card *card, struct snd_ctl_elem_id *src_id,
 }
 EXPORT_SYMBOL(snd_ctl_rename_id);
 
+/**
+ * snd_ctl_rename - rename the control on the card
+ * @card: the card instance
+ * @kctl: the control to rename
+ * @name: the new name
+ *
+ * Renames the specified control on the card to the new name.
+ *
+ * Make sure to take the control write lock - down_write(&card->controls_rwsem).
+ */
+void snd_ctl_rename(struct snd_card *card, struct snd_kcontrol *kctl,
+		    const char *name)
+{
+	remove_hash_entries(card, kctl);
+
+	if (strscpy(kctl->id.name, name, sizeof(kctl->id.name)) < 0)
+		pr_warn("ALSA: Renamed control new name '%s' truncated to '%s'\n",
+			name, kctl->id.name);
+
+	add_hash_entries(card, kctl);
+}
+EXPORT_SYMBOL(snd_ctl_rename);
+
 #ifndef CONFIG_SND_CTL_FAST_LOOKUP
 static struct snd_kcontrol *
 snd_ctl_find_numid_slow(struct snd_card *card, unsigned int numid)
-- 
2.38.1



