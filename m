Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFA5171F01
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733273AbgB0ODJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:03:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:38222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733267AbgB0ODI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:03:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AB2721556;
        Thu, 27 Feb 2020 14:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812187;
        bh=KXtC7QIz7VdVKvGcBpEOfewAjLosERO3C/DVcjoig1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TbzQvTQuBbYLbG/qSmh96/r+NLXy+1SnXEEGHiX+WFav3PP0LAzh76JkTcVGjLIsQ
         RuaoL1D4Z3MdwQUQlBG1FV++fJ7Pi4/6Jm/581W2HiRrkxnf53USGHsLQkPFm3+dSv
         pgifOosBTjfNN7WAg1ezRDs9aQ+CXHNHtP2v2qsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 02/97] ALSA: hda: Use scnprintf() for printing texts for sysfs/procfs
Date:   Thu, 27 Feb 2020 14:36:10 +0100
Message-Id: <20200227132214.961074193@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132214.553656188@linuxfoundation.org>
References: <20200227132214.553656188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 44eeb081b8630bb3ad3cd381d1ae1831463e48bb upstream.

Some code in HD-audio driver calls snprintf() in a loop and still
expects that the return value were actually written size, while
snprintf() returns the expected would-be length instead.  When the
given buffer limit were small, this leads to a buffer overflow.

Use scnprintf() for addressing those issues.  It returns the actually
written size unlike snprintf().

Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200218091409.27162-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/hda/hdmi_chmap.c    |    2 +-
 sound/pci/hda/hda_codec.c |    2 +-
 sound/pci/hda/hda_eld.c   |    2 +-
 sound/pci/hda/hda_sysfs.c |    4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/sound/hda/hdmi_chmap.c
+++ b/sound/hda/hdmi_chmap.c
@@ -249,7 +249,7 @@ void snd_hdac_print_channel_allocation(i
 
 	for (i = 0, j = 0; i < ARRAY_SIZE(cea_speaker_allocation_names); i++) {
 		if (spk_alloc & (1 << i))
-			j += snprintf(buf + j, buflen - j,  " %s",
+			j += scnprintf(buf + j, buflen - j,  " %s",
 					cea_speaker_allocation_names[i]);
 	}
 	buf[j] = '\0';	/* necessary when j == 0 */
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -4019,7 +4019,7 @@ void snd_print_pcm_bits(int pcm, char *b
 
 	for (i = 0, j = 0; i < ARRAY_SIZE(bits); i++)
 		if (pcm & (AC_SUPPCM_BITS_8 << i))
-			j += snprintf(buf + j, buflen - j,  " %d", bits[i]);
+			j += scnprintf(buf + j, buflen - j,  " %d", bits[i]);
 
 	buf[j] = '\0'; /* necessary when j == 0 */
 }
--- a/sound/pci/hda/hda_eld.c
+++ b/sound/pci/hda/hda_eld.c
@@ -373,7 +373,7 @@ static void hdmi_print_pcm_rates(int pcm
 
 	for (i = 0, j = 0; i < ARRAY_SIZE(alsa_rates); i++)
 		if (pcm & (1 << i))
-			j += snprintf(buf + j, buflen - j,  " %d",
+			j += scnprintf(buf + j, buflen - j,  " %d",
 				alsa_rates[i]);
 
 	buf[j] = '\0'; /* necessary when j == 0 */
--- a/sound/pci/hda/hda_sysfs.c
+++ b/sound/pci/hda/hda_sysfs.c
@@ -221,7 +221,7 @@ static ssize_t init_verbs_show(struct de
 	int i, len = 0;
 	mutex_lock(&codec->user_mutex);
 	snd_array_for_each(&codec->init_verbs, i, v) {
-		len += snprintf(buf + len, PAGE_SIZE - len,
+		len += scnprintf(buf + len, PAGE_SIZE - len,
 				"0x%02x 0x%03x 0x%04x\n",
 				v->nid, v->verb, v->param);
 	}
@@ -271,7 +271,7 @@ static ssize_t hints_show(struct device
 	int i, len = 0;
 	mutex_lock(&codec->user_mutex);
 	snd_array_for_each(&codec->hints, i, hint) {
-		len += snprintf(buf + len, PAGE_SIZE - len,
+		len += scnprintf(buf + len, PAGE_SIZE - len,
 				"%s = %s\n", hint->key, hint->val);
 	}
 	mutex_unlock(&codec->user_mutex);


