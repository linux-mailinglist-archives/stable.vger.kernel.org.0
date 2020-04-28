Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECD11BCB77
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729546AbgD1S5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:57:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728961AbgD1SaU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:30:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F01A620B80;
        Tue, 28 Apr 2020 18:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098619;
        bh=qEjxKOBFnf4u0leOG6IvyiKBbBguatnRg9OSjBm9Lxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gpZ8jO2zf46Y/nsHove99kQ5XmM4OAYaow18qbPBs9P7oSzYHJ9pR1JsazAADeMnr
         6l99/O9FFMF2S7G+JUeK64svan/4YNqdCZjD+Fo/x7lw0oyZ88vVGMp+ZK29ZOe/HQ
         i6uYQIylQ842RpyM4BdS0+rY9IppFz29sa8ljmGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Ingo Molnar <mingo@redhat.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        NeilBrown <neilb@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
        Waiman Long <longman@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 020/131] kernel/gcov/fs.c: gcov_seq_next() should increase position index
Date:   Tue, 28 Apr 2020 20:23:52 +0200
Message-Id: <20200428182227.651335936@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182224.822179290@linuxfoundation.org>
References: <20200428182224.822179290@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit f4d74ef6220c1eda0875da30457bef5c7111ab06 ]

If seq_file .next function does not change position index, read after
some lseek can generate unexpected output.

https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: NeilBrown <neilb@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Waiman Long <longman@redhat.com>
Link: http://lkml.kernel.org/r/f65c6ee7-bd00-f910-2f8a-37cc67e4ff88@virtuozzo.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/gcov/fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/gcov/fs.c b/kernel/gcov/fs.c
index 6e40ff6be083d..291e0797125b6 100644
--- a/kernel/gcov/fs.c
+++ b/kernel/gcov/fs.c
@@ -109,9 +109,9 @@ static void *gcov_seq_next(struct seq_file *seq, void *data, loff_t *pos)
 {
 	struct gcov_iterator *iter = data;
 
+	(*pos)++;
 	if (gcov_iter_next(iter))
 		return NULL;
-	(*pos)++;
 
 	return iter;
 }
-- 
2.20.1



 sizeof(kctl->id.name));
+
+	if (check_mapped_name(map, kctl->id.name, sizeof(kctl->id.name)))
+		strlcat(kctl->id.name, " Jack", sizeof(kctl->id.name));
+	else
+		get_connector_control_name(mixer, term, is_input, kctl->id.name,
+					   sizeof(kctl->id.name));
 	kctl->private_free = snd_usb_mixer_elem_free;
 	snd_usb_mixer_add_control(&cval->head, kctl);
 }
diff --git a/sound/usb/mixer_maps.c b/sound/usb/mixer_maps.c
index b4e77000f441e..fb2c4a992951b 100644
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -369,6 +369,24 @@ static const struct usbmix_name_map asus_rog_map[] = {
 	{}
 };
 
+/* TRX40 mobos with Realtek ALC1220-VB */
+static const struct usbmix_name_map trx40_mobo_map[] = {
+	{ 18, NULL }, /* OT, IEC958 - broken response, disabled */
+	{ 19, NULL, 12 }, /* FU, Input Gain Pad - broken response, disabled */
+	{ 16, "Speaker" },		/* OT */
+	{ 22, "Speaker Playback" },	/* FU */
+	{ 7, "Line" },			/* IT */
+	{ 19, "Line Capture" },		/* FU */
+	{ 17, "Front Headphone" },	/* OT */
+	{ 23, "Front Headphone Playback" },	/* FU */
+	{ 8, "Mic" },			/* IT */
+	{ 20, "Mic Capture" },		/* FU */
+	{ 9, "Front Mic" },		/* IT */
+	{ 21, "Front Mic Capture" },	/* FU */
+	{ 24, "IEC958 Playback" },	/* FU */
+	{}
+};
+
 /*
  * Control map entries
  */
@@ -500,7 +518,7 @@ static const struct usbmix_ctl_map usbmix_ctl_maps[] = {
 	},
 	{	/* Gigabyte TRX40 Aorus Pro WiFi */
 		.id = USB_ID(0x0414, 0xa002),
-		.map = asus_rog_map,
+		.map = trx40_mobo_map,
 	},
 	{	/* ASUS ROG Zenith II */
 		.id = USB_ID(0x0b05, 0x1916),
@@ -512,11 +530,11 @@ static const struct usbmix_ctl_map usbmix_ctl_maps[] = {
 	},
 	{	/* MSI TRX40 Creator */
 		.id = USB_ID(0x0db0, 0x0d64),
-		.map = asus_rog_map,
+		.map = trx40_mobo_map,
 	},
 	{	/* MSI TRX40 */
 		.id = USB_ID(0x0db0, 0x543d),
-		.map = asus_rog_map,
+		.map = trx40_mobo_map,
 	},
 	{ 0 } /* terminator */
 };
diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index dcaf9eed9a415..8c2f5c23e1b43 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3635,4 +3635,18 @@ AU0828_DEVICE(0x2040, 0x7270, "Hauppauge", "HVR-950Q"),
 	}
 },
 
+#define ALC1220_VB_DESKTOP(vend, prod) { \
+	USB_DEVICE(vend, prod),	\
+	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) { \
+		.vendor_name = "Realtek", \
+		.product_name = "ALC1220-VB-DT", \
+		.profile_name = "Realtek-ALC1220-VB-Desktop", \
+		.ifnum = QUIRK_NO_INTERFACE \
+	} \
+}
+ALC1220_VB_DESKTOP(0x0414, 0xa002), /* Gigabyte TRX40 Aorus Pro WiFi */
+ALC1220_VB_DESKTOP(0x0db0, 0x0d64), /* MSI TRX40 Creator */
+ALC1220_VB_DESKTOP(0x0db0, 0x543d), /* MSI TRX40 */
+#undef ALC1220_VB_DESKTOP
+
 #undef USB_DEVICE_VENDOR_SPEC
-- 
2.20.1



