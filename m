Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F228226490
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730609AbgGTPqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:46:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730624AbgGTPqH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:46:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F22822CAF;
        Mon, 20 Jul 2020 15:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259966;
        bh=McmbKFlbqMpo8IxRkVL1jd3r9+7XGe4Z3H7+HxfRZRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fyCU0mURPgI3DQU0o4MbzNFCMshAOMwgCKw5pFj9qZv/3MiRSQ4L/KCu/SThOjX03
         eISQC9XY9Lv8+Bu39aPeV6SaV21ZKl6FpVxZM90Ve+mfhuFKh1U3DCnHGuKlvkJRnl
         M4CxlsFcqjuOqhkXzUlGuPnc3vK5FUTVj5OteXag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 027/125] ALSA: hda - let hs_mic be picked ahead of hp_mic
Date:   Mon, 20 Jul 2020 17:36:06 +0200
Message-Id: <20200720152804.296663793@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152802.929969555@linuxfoundation.org>
References: <20200720152802.929969555@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit 6a6ca7881b1ab1c13fe0d70bae29211a65dd90de upstream.

We have a Dell AIO, there is neither internal speaker nor internal
mic, only a multi-function audio jack on it.

Users reported that after freshly installing the OS and plug
a headset to the audio jack, the headset can't output sound. I
reproduced this bug, at that moment, the Input Source is as below:
Simple mixer control 'Input Source',0
  Capabilities: cenum
  Items: 'Headphone Mic' 'Headset Mic'
  Item0: 'Headphone Mic'

That is because the patch_realtek will set this audio jack as mic_in
mode if Input Source's value is hp_mic.

If it is not fresh installing, this issue will not happen since the
systemd will run alsactl restore -f /var/lib/alsa/asound.state, this
will set the 'Input Source' according to history value.

If there is internal speaker or internal mic, this issue will not
happen since there is valid sink/source in the pulseaudio, the PA will
set the 'Input Source' according to active_port.

To fix this issue, change the parser function to let the hs_mic be
stored ahead of hp_mic.

Cc: stable@vger.kernel.org
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://lore.kernel.org/r/20200625083833.11264-1-hui.wang@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_auto_parser.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/pci/hda/hda_auto_parser.c
+++ b/sound/pci/hda/hda_auto_parser.c
@@ -76,6 +76,12 @@ static int compare_input_type(const void
 	if (a->type != b->type)
 		return (int)(a->type - b->type);
 
+	/* If has both hs_mic and hp_mic, pick the hs_mic ahead of hp_mic. */
+	if (a->is_headset_mic && b->is_headphone_mic)
+		return -1; /* don't swap */
+	else if (a->is_headphone_mic && b->is_headset_mic)
+		return 1; /* swap */
+
 	/* In case one has boost and the other one has not,
 	   pick the one with boost first. */
 	return (int)(b->has_boost_on_pin - a->has_boost_on_pin);


