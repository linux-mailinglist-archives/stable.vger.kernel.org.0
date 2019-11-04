Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBAF5EEF5B
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730803AbfKDV6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:58:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:55900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730782AbfKDV6u (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:58:50 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63ABD217F4;
        Mon,  4 Nov 2019 21:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904730;
        bh=AKGm0nPhIlqGk5+Y7MJ/YsmIrdeaeAkVQKPf85OVNhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C6th9/jIubeij5c5QxaJOWeyeCcO0fwqcONj+n2aP7NZ4HKTmj9MRilUvU1cXoIwm
         hBPNDEMyCmLjD6bgGAb4u7twWKZYXYD3apbY54AdT7lf5yE4Vn8k6iC5RlDrLBS1Xn
         oBhV0KlmdxKCjVog4kvybkJfk09OX0Ru01ymJcS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 050/149] ALSA: hda/realtek - Apply ALC294 hp init also for S4 resume
Date:   Mon,  4 Nov 2019 22:44:03 +0100
Message-Id: <20191104212139.627500139@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
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
index dd46354270d0d..7480218f32ba7 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3458,7 +3458,9 @@ static void alc294_init(struct hda_codec *codec)
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



