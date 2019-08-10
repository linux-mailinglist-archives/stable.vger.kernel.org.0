Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25CC488E56
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbfHJUyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:54:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53848 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726498AbfHJUnt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:49 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDK-00053t-AE; Sat, 10 Aug 2019 21:43:46 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDJ-0003aP-HK; Sat, 10 Aug 2019 21:43:45 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "Takashi Iwai" <tiwai@suse.de>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.608627100@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 037/157] ALSA: seq: oss: Fix Spectre v1 vulnerability
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

commit c709f14f0616482b67f9fbcb965e1493a03ff30b upstream.

dev is indirectly controlled by user-space, hence leading to
a potential exploitation of the Spectre variant 1 vulnerability.

This issue was detected with the help of Smatch:

sound/core/seq/oss/seq_oss_synth.c:626 snd_seq_oss_synth_make_info() warn: potential spectre issue 'dp->synths' [w] (local cap)

Fix this by sanitizing dev before using it to index dp->synths.

Notice that given that speculation windows are large, the policy is
to kill the speculation on the first load and not worry if it can be
completed with a dependent load/store [1].

[1] https://lore.kernel.org/lkml/20180423164740.GY17484@dhcp22.suse.cz/

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/core/seq/oss/seq_oss_synth.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/sound/core/seq/oss/seq_oss_synth.c
+++ b/sound/core/seq/oss/seq_oss_synth.c
@@ -617,13 +617,14 @@ int
 snd_seq_oss_synth_make_info(struct seq_oss_devinfo *dp, int dev, struct synth_info *inf)
 {
 	struct seq_oss_synth *rec;
+	struct seq_oss_synthinfo *info = get_synthinfo_nospec(dp, dev);
 
-	if (dev < 0 || dev >= dp->max_synthdev)
+	if (!info)
 		return -ENXIO;
 
-	if (dp->synths[dev].is_midi) {
+	if (info->is_midi) {
 		struct midi_info minf;
-		snd_seq_oss_midi_make_info(dp, dp->synths[dev].midi_mapped, &minf);
+		snd_seq_oss_midi_make_info(dp, info->midi_mapped, &minf);
 		inf->synth_type = SYNTH_TYPE_MIDI;
 		inf->synth_subtype = 0;
 		inf->nr_voices = 16;

