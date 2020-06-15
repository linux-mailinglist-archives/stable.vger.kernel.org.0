Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE51C1F9C18
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 17:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728585AbgFOPlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 11:41:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:36870 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728477AbgFOPlY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 11:41:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2E9ACAD0D;
        Mon, 15 Jun 2020 15:41:27 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH 4.19.y] ALSA: pcm: disallow linking stream to itself
Date:   Mon, 15 Jun 2020 17:41:19 +0200
Message-Id: <20200615154119.1612-1-tiwai@suse.de>
X-Mailer: git-send-email 2.16.4
Mime-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

commit 951e2736f4b11b58dc44d41964fa17c3527d882a upstream.

Prevent SNDRV_PCM_IOCTL_LINK linking stream to itself - the code
can't handle it. Fixed commit is not where bug was introduced, but
changes the context significantly.

Cc: stable@vger.kernel.org
Fixes: 0888c321de70 ("pcm_native: switch to fdget()/fdput()")
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Link: https://lore.kernel.org/r/89c4a2487609a0ed6af3ecf01cc972bdc59a7a2d.1591634956.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Takashi Iwai <tiwai@suse.de>

---

Backported to 4.19.y.  It can be used for older branches, too.

 sound/core/pcm_native.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 14b1ee29509d..071e09c3d855 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -1950,6 +1950,11 @@ static int snd_pcm_link(struct snd_pcm_substream *substream, int fd)
 	}
 	pcm_file = f.file->private_data;
 	substream1 = pcm_file->substream;
+	if (substream == substream1) {
+		res = -EINVAL;
+		goto _badf;
+	}
+
 	group = kmalloc(sizeof(*group), GFP_KERNEL);
 	if (!group) {
 		res = -ENOMEM;
-- 
2.16.4

