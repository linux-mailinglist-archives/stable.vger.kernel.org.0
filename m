Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8746C12993E
	for <lists+stable@lfdr.de>; Mon, 23 Dec 2019 18:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfLWRSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Dec 2019 12:18:44 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:32987 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726718AbfLWRSo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Dec 2019 12:18:44 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id ED1DC21F82;
        Mon, 23 Dec 2019 12:18:43 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 23 Dec 2019 12:18:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=mFwyse
        O4MbpFutRdZWooEufUraKGQDrHiOM9GuaZvrs=; b=U6xE1W95J+GwDoZR3JJGQx
        EkCxKo/uXuTJ8jllDooa4+gQ2pxAKsvfB2WSOH9Z37gv05PiQPI+ShA7wfwFSJZo
        Wwqhpr+ApiSGHYspnbhYkxFDWXsJYIZN/KK7i+Yh26J286CPrcAVYnnKSWCuA9Iq
        CgX+jJoVW3IRZHCwrLMwYH+5uL+O+IOqt81FIiW4Nw6VusNwHdzpRgjMjFe9Gckn
        XejJ1fGo9RCKMH30RfJlZqN+y+YFru8/C/WTax6C+0eaDr6ZHcuqtm/n1F5VwOfw
        tqwbzDqD2fWFU5QK2DROKIIKs90ubPrvB9VdLTMoblUt33e5cpp4S1gS7r/rbk8w
        ==
X-ME-Sender: <xms:8_YAXkY_n82wyOOCVFFDK6XsHvkZZXNtpWK8DrQdhj7paJnGONxeAA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvtddgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepudelkedrkeelrdeige
    drvdegleenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:8_YAXskJ33tWylz65PCT435ehKrMqaV055nWGNwbWsTurAcZKFhw_w>
    <xmx:8_YAXngOEQkkn493us0DPmpHtn7wH0pkWrIi5fsWbdHpZS_yMbdwWQ>
    <xmx:8_YAXuSWHlCCtSActVi_xc23L_9cnRPWWBDrIfA1pDRYNT03dk5dNQ>
    <xmx:8_YAXr_n0Kck3rMWOojRBJBJ0hbImROYHF80gWsdbeTEnEt8LmkRsQ>
Received: from localhost (unknown [198.89.64.249])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7E71B8005B;
        Mon, 23 Dec 2019 12:18:43 -0500 (EST)
Subject: FAILED: patch "[PATCH] ALSA: hda/ca0132 - Fix work handling in delayed HP detection" failed to apply to 4.4-stable tree
To:     tiwai@suse.de, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Dec 2019 12:18:29 -0500
Message-ID: <157712150919273@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 42fb6b1d41eb5905d77c06cad2e87b70289bdb76 Mon Sep 17 00:00:00 2001
From: Takashi Iwai <tiwai@suse.de>
Date: Fri, 13 Dec 2019 09:51:11 +0100
Subject: [PATCH] ALSA: hda/ca0132 - Fix work handling in delayed HP detection

CA0132 has the delayed HP jack detection code that is invoked from the
unsol handler, but it does a few weird things: it contains the cancel
of a work inside the work handler, and yet it misses the cancel-sync
call at (runtime-)suspend.  This patch addresses those issues.

Fixes: 15c2b3cc09a3 ("ALSA: hda/ca0132 - Fix possible workqueue stall")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191213085111.22855-4-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
index 8d0209fff8f5..32ed46464af7 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -7607,11 +7607,10 @@ static void hp_callback(struct hda_codec *codec, struct hda_jack_callback *cb)
 	/* Delay enabling the HP amp, to let the mic-detection
 	 * state machine run.
 	 */
-	cancel_delayed_work(&spec->unsol_hp_work);
-	schedule_delayed_work(&spec->unsol_hp_work, msecs_to_jiffies(500));
 	tbl = snd_hda_jack_tbl_get(codec, cb->nid);
 	if (tbl)
 		tbl->block_report = 1;
+	schedule_delayed_work(&spec->unsol_hp_work, msecs_to_jiffies(500));
 }
 
 static void amic_callback(struct hda_codec *codec, struct hda_jack_callback *cb)
@@ -8457,12 +8456,25 @@ static void ca0132_reboot_notify(struct hda_codec *codec)
 	codec->patch_ops.free(codec);
 }
 
+#ifdef CONFIG_PM
+static int ca0132_suspend(struct hda_codec *codec)
+{
+	struct ca0132_spec *spec = codec->spec;
+
+	cancel_delayed_work_sync(&spec->unsol_hp_work);
+	return 0;
+}
+#endif
+
 static const struct hda_codec_ops ca0132_patch_ops = {
 	.build_controls = ca0132_build_controls,
 	.build_pcms = ca0132_build_pcms,
 	.init = ca0132_init,
 	.free = ca0132_free,
 	.unsol_event = snd_hda_jack_unsol_event,
+#ifdef CONFIG_PM
+	.suspend = ca0132_suspend,
+#endif
 	.reboot_notify = ca0132_reboot_notify,
 };
 

