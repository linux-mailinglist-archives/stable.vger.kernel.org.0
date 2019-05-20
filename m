Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02A6E233FF
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388391AbfETMWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:22:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:36330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387666AbfETMWV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:22:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33F5B21019;
        Mon, 20 May 2019 12:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354940;
        bh=6ZPD1QSHdzGTzkY0bnB7RTClmvWPiJlvDHS9dNTMtq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YEsK5atORVi2EVcyaZnY4biDAHSlPQTXHHMVPJYd1p76DIdykShCirIPCCqbwpGma
         5cnG5WN/vJz7OjCeULwBzkpMpzZtPt1SVRLOFsWmE+eKvJ13K4WucMVyRtkQha2FzZ
         sM8ChHhbTe3eFFhQ5+73wd3NgVZpOiXJPTHoVn5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 035/105] ALSA: hda/hdmi - Read the pin sense from register when repolling
Date:   Mon, 20 May 2019 14:13:41 +0200
Message-Id: <20190520115249.464956414@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
References: <20190520115247.060821231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit 8c2e6728c2bf95765b724e07d0278ae97cd1ee0d upstream.

The driver will check the monitor presence when resuming from suspend,
starting poll or interrupt triggers. In these 3 situations, the
jack_dirty will be set to 1 first, then the hda_jack.c reads the
pin_sense from register, after reading the register, the jack_dirty
will be set to 0. But hdmi_repoll_work() is enabled in these 3
situations, It will read the pin_sense a couple of times subsequently,
since the jack_dirty is 0 now, It does not read the register anymore,
instead it uses the shadow pin_sense which is read at the first time.

It is meaningless to check the shadow pin_sense a couple of times,
we need to read the register to check the real plugging state, so
we set the jack_dirty to 1 in the hdmi_repoll_work().

Signed-off-by: Hui Wang <hui.wang@canonical.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_hdmi.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1660,6 +1660,11 @@ static void hdmi_repoll_eld(struct work_
 	container_of(to_delayed_work(work), struct hdmi_spec_per_pin, work);
 	struct hda_codec *codec = per_pin->codec;
 	struct hdmi_spec *spec = codec->spec;
+	struct hda_jack_tbl *jack;
+
+	jack = snd_hda_jack_tbl_get(codec, per_pin->pin_nid);
+	if (jack)
+		jack->jack_dirty = 1;
 
 	if (per_pin->repoll_count++ > 6)
 		per_pin->repoll_count = 0;


