Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 303BCDD212
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387705AbfJRWIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:08:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387691AbfJRWIV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:08:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAE02222C2;
        Fri, 18 Oct 2019 22:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436501;
        bh=XmiV9shyhIDIa3OFpD1U1MBqHaPljeOFs1xJ8axEo0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cG6WNgc4YoaXQ8iIKDOgwMGbEBQc97xzbU/SppNqEs1l+/6TUIsPIrEQ0S1RlYxEB
         oPzTG7tx1Pu9AdyzNylgah6hpI1vJ5rvkc0o8fLErb5CoPXm9ZmZC9E3oxyBaX6IVm
         tM2bA+X7giJhYQiyOwgkbr2OQd4a10cj5YXv//tc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 14/56] ALSA: hda/realtek - Apply ALC294 hp init also for S4 resume
Date:   Fri, 18 Oct 2019 18:07:11 -0400
Message-Id: <20191018220753.10002-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220753.10002-1-sashal@kernel.org>
References: <20191018220753.10002-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index ab7bc7ebb7215..fc935794d432d 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3245,7 +3245,9 @@ static void alc294_init(struct hda_codec *codec)
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

