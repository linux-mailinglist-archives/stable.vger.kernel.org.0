Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E488EEBF7
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 22:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730771AbfKDVwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:52:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:46152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729730AbfKDVwg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:52:36 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FFB121929;
        Mon,  4 Nov 2019 21:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904355;
        bh=jBRD/+1zElxgqwOGIvSiuWSvuOrjlam6KwlDf5mfZdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0VVrwPP1Dq4ptGGCP8MuiF4fQ7f8ZEeV0AA6N3NW8og+YSixMjQuwZUJn1ENEzTjp
         GbTjW3g3Lb+l04fpwCyxBj6aJ1pqx/ovURjEynnoD/c5sf8QXQOIOOQ9PAbnqU4hyS
         fI2moy56qNiWeim/ug5IH/mIkyVNT+vpnDLPRdHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 19/95] ALSA: hda/realtek - Apply ALC294 hp init also for S4 resume
Date:   Mon,  4 Nov 2019 22:44:17 +0100
Message-Id: <20191104212047.985825786@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212038.056365853@linuxfoundation.org>
References: <20191104212038.056365853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit f6ef4e0e284251ff795c541db1129c84515ed044 ]

The init sequence for ALC294 headphone stuff is needed not only for
the boot up time but also for the resume from hibernation, where the
device is switched from the boot kernel without sound driver to the
suspended image.  Since we record the PM event in the device
power_state field, we can now recognize the call pattern and apply the
sequence conditionally.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 5412952557f7a..8d6c5be387362 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3246,7 +3246,9 @@ static void alc294_init(struct hda_codec *codec)
 {
 	struct alc_spec *spec = codec->spec;
 
-	if (!spec->done_hp_init) {
+	/* required only at boot or S4 resume time */
+	if (!spec->done_hp_init ||
+	    codec->core.dev.power.power_state.event == PM_EVENT_RESTORE) {
 		alc294_hp_init(codec);
 		spec->done_hp_init = true;
 	}
-- 
2.20.1



