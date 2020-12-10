Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A1A2D64E2
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 19:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390884AbgLJOfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:35:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:42710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390875AbgLJOfE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:35:04 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 17/54] ALSA: hda/generic: Add option to enforce preferred_dacs pairs
Date:   Thu, 10 Dec 2020 15:26:54 +0100
Message-Id: <20201210142602.888457075@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142602.037095225@linuxfoundation.org>
References: <20201210142602.037095225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 242d990c158d5b1dabd166516e21992baef5f26a upstream.

The generic parser accepts the preferred_dacs[] pairs as a hint for
assigning a DAC to each pin, but this hint doesn't work always
effectively.  Currently it's merely a secondary choice after the trial
with the path index failed.  This made sometimes it difficult to
assign DACs without mimicking the connection list and/or the badness
table.

This patch adds a new flag, obey_preferred_dacs, that changes the
behavior of the parser.  As its name stands, the parser obeys the
given preferred_dacs[] pairs by skipping the path index matching and
giving a high penalty if no DAC is assigned by the pairs.  This mode
will help for assigning the fixed DACs forcibly from the codec
driver.

Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201127141104.11041-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_generic.c |   12 ++++++++----
 sound/pci/hda/hda_generic.h |    1 +
 2 files changed, 9 insertions(+), 4 deletions(-)

--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -1364,16 +1364,20 @@ static int try_assign_dacs(struct hda_co
 		struct nid_path *path;
 		hda_nid_t pin = pins[i];
 
-		path = snd_hda_get_path_from_idx(codec, path_idx[i]);
-		if (path) {
-			badness += assign_out_path_ctls(codec, path);
-			continue;
+		if (!spec->obey_preferred_dacs) {
+			path = snd_hda_get_path_from_idx(codec, path_idx[i]);
+			if (path) {
+				badness += assign_out_path_ctls(codec, path);
+				continue;
+			}
 		}
 
 		dacs[i] = get_preferred_dac(codec, pin);
 		if (dacs[i]) {
 			if (is_dac_already_used(codec, dacs[i]))
 				badness += bad->shared_primary;
+		} else if (spec->obey_preferred_dacs) {
+			badness += BAD_NO_PRIMARY_DAC;
 		}
 
 		if (!dacs[i])
--- a/sound/pci/hda/hda_generic.h
+++ b/sound/pci/hda/hda_generic.h
@@ -236,6 +236,7 @@ struct hda_gen_spec {
 	unsigned int power_down_unused:1; /* power down unused widgets */
 	unsigned int dac_min_mute:1; /* minimal = mute for DACs */
 	unsigned int suppress_vmaster:1; /* don't create vmaster kctls */
+	unsigned int obey_preferred_dacs:1; /* obey preferred_dacs assignment */
 
 	/* other internal flags */
 	unsigned int no_analog:1; /* digital I/O only */


