Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEB9B9255
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391205AbfITObg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:31:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36734 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388348AbfITOZO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:14 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqQ-0004y5-5R; Fri, 20 Sep 2019 15:25:10 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqF-0007uq-FP; Fri, 20 Sep 2019 15:24:59 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Hui Wang" <hui.wang@canonical.com>, "Takashi Iwai" <tiwai@suse.de>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.522114580@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 078/132] ALSA: hda/hdmi - Read the pin sense from
 register when repolling
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1632,6 +1632,12 @@ static void hdmi_repoll_eld(struct work_
 {
 	struct hdmi_spec_per_pin *per_pin =
 	container_of(to_delayed_work(work), struct hdmi_spec_per_pin, work);
+	struct hda_codec *codec = per_pin->codec;
+	struct hda_jack_tbl *jack;
+
+	jack = snd_hda_jack_tbl_get(codec, per_pin->pin_nid);
+	if (jack)
+		jack->jack_dirty = 1;
 
 	if (per_pin->repoll_count++ > 6)
 		per_pin->repoll_count = 0;

