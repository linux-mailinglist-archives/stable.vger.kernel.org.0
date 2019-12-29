Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42AA512C760
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728598AbfL2R23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:28:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:51946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728140AbfL2R22 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:28:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F27A20409;
        Sun, 29 Dec 2019 17:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640507;
        bh=5kETJTHjj8fr1I/3STdeFFVpzxjlXXfYVesPgu98lA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iwn25XbH0y4nzrYCInOTZCGmxMw3/ZedkOhZTVjCy7SgyKhbWUvFQspTIYXICVTgO
         C0Io/avgLkjYeGWTSzNKxLG4GelALuYkCf9uKMkf3Rz8bQjUPRrVbdAOS1dW/8FydC
         +kg/bVihJi2W0fgAvsJm7ZfzrEbFN0Qu9VugEpj4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 024/219] ALSA: hda/ca0132 - Keep power on during processing DSP response
Date:   Sun, 29 Dec 2019 18:17:06 +0100
Message-Id: <20191229162512.550619397@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 377bc0cfabce0244632dada19060839ced4e6949 upstream.

We need to keep power on while processing the DSP response via unsol
event.  Each snd_hda_codec_read() call does the power management, so
it should work normally, but still it's safer to keep the power up for
the whole function.

Fixes: a73d511c4867 ("ALSA: hda/ca0132: Add unsol handler for DSP and jack detection")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191213085111.22855-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_ca0132.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -6754,12 +6754,14 @@ static void ca0132_process_dsp_response(
 	struct ca0132_spec *spec = codec->spec;
 
 	codec_dbg(codec, "ca0132_process_dsp_response\n");
+	snd_hda_power_up_pm(codec);
 	if (spec->wait_scp) {
 		if (dspio_get_response_data(codec) >= 0)
 			spec->wait_scp = 0;
 	}
 
 	dspio_clear_response_queue(codec);
+	snd_hda_power_down_pm(codec);
 }
 
 static void hp_callback(struct hda_codec *codec, struct hda_jack_callback *cb)


