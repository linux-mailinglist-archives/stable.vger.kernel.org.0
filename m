Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D6933B7AF
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbhCOOBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232728AbhCON7h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62E5664F00;
        Mon, 15 Mar 2021 13:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816758;
        bh=IhRo2aG6u3S+g0gy0hObN/Dzc3l7rDISghhTeGSH9tQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ELbJ7OzMFvnqKlJULWOQpouZ85h94a5A1sSc3RBsjBDZWyQaypn1KlckBiLyw44DK
         BRxE4J8ktzsbG1CKqKEpogwcTBSk8e0GB3oci8MTe7uEuN6JEjnfwLeYdG1zTaDxSk
         DCCBiItBt1a44wQW5ki83EcExcY9ZTdL7tdGpk/o=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Abhishek Sahu <abhsahu@nvidia.com>
Subject: [PATCH 5.4 089/168] ALSA: hda/hdmi: Cancel pending works before suspend
Date:   Mon, 15 Mar 2021 14:55:21 +0100
Message-Id: <20210315135553.303747535@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Takashi Iwai <tiwai@suse.de>

commit eea46a0879bcca23e15071f9968c0f6e6596e470 upstream.

The per_pin->work might be still floating at the suspend, and this may
hit the access to the hardware at an unexpected timing.  Cancel the
work properly at the suspend callback for avoiding the buggy access.

Note that the bug doesn't trigger easily in the recent kernels since
the work is queued only when the repoll count is set, and usually it's
only at the resume callback, but it's still possible to hit in
theory.

BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1182377
Reported-and-tested-by: Abhishek Sahu <abhsahu@nvidia.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210310112809.9215-4-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_hdmi.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -2382,6 +2382,18 @@ static void generic_hdmi_free(struct hda
 }
 
 #ifdef CONFIG_PM
+static int generic_hdmi_suspend(struct hda_codec *codec)
+{
+	struct hdmi_spec *spec = codec->spec;
+	int pin_idx;
+
+	for (pin_idx = 0; pin_idx < spec->num_pins; pin_idx++) {
+		struct hdmi_spec_per_pin *per_pin = get_pin(spec, pin_idx);
+		cancel_delayed_work_sync(&per_pin->work);
+	}
+	return 0;
+}
+
 static int generic_hdmi_resume(struct hda_codec *codec)
 {
 	struct hdmi_spec *spec = codec->spec;
@@ -2405,6 +2417,7 @@ static const struct hda_codec_ops generi
 	.build_controls		= generic_hdmi_build_controls,
 	.unsol_event		= hdmi_unsol_event,
 #ifdef CONFIG_PM
+	.suspend		= generic_hdmi_suspend,
 	.resume			= generic_hdmi_resume,
 #endif
 };


