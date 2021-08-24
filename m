Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808813F67C6
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241763AbhHXRhP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:37:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242436AbhHXRfQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:35:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 274C661BD4;
        Tue, 24 Aug 2021 17:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824812;
        bh=E2ygH9DV6fEypzWOtd0/Y+SjmyPH3h6NMnirsCCkazU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=br0DbQAOl6CAu304JlAudrlA+uphdL1Pnc9EIpZox3061XZAzTxGnPHTl1rge8uEW
         fSDaksdicIaiICoQvKDQFn3snVc0Y3DZwHrqJ1SFJF1RDaxl2SpKS91qcH4vrPNpem
         PopMJI7CQehCTzj9L8E4Fd0UA5HnoEtcYkqwxyiJgrUMf8lU+y1TMS0lfG1/ewbeUs
         EDMK31jWgwpQe9DgUPIxQVCeYyZkQQrusA85nMd6Ox7P0POdf382fPfCfpI2M5rHJl
         QMn1TZcFCLDUVYLUqVOkRyJ0HPyLVdi9OdxgCIoT//ufMDR10+R2IWZQVH2OA53mW9
         mYvYDOWvDkyjA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaroslav Kysela <perex@perex.cz>, stable@kernel.org,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 37/43] ALSA: hda - fix the 'Capture Switch' value change notifications
Date:   Tue, 24 Aug 2021 13:06:08 -0400
Message-Id: <20210824170614.710813-38-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170614.710813-1-sashal@kernel.org>
References: <20210824170614.710813-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.281-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.281-rc1
X-KernelTest-Deadline: 2021-08-26T17:06+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaroslav Kysela <perex@perex.cz>

[ Upstream commit a2befe9380dd04ee76c871568deca00eedf89134 ]

The original code in the cap_put_caller() function does not
handle correctly the positive values returned from the passed
function for multiple iterations. It means that the change
notifications may be lost.

Fixes: 352f7f914ebb ("ALSA: hda - Merge Realtek parser code to generic parser")
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=213851
Cc: <stable@kernel.org>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20210811161441.1325250-1-perex@perex.cz
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_generic.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/sound/pci/hda/hda_generic.c b/sound/pci/hda/hda_generic.c
index 8d99ac931ff6..c29f7ff5ccd2 100644
--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -3421,7 +3421,7 @@ static int cap_put_caller(struct snd_kcontrol *kcontrol,
 	struct hda_gen_spec *spec = codec->spec;
 	const struct hda_input_mux *imux;
 	struct nid_path *path;
-	int i, adc_idx, err = 0;
+	int i, adc_idx, ret, err = 0;
 
 	imux = &spec->input_mux;
 	adc_idx = kcontrol->id.index;
@@ -3431,9 +3431,13 @@ static int cap_put_caller(struct snd_kcontrol *kcontrol,
 		if (!path || !path->ctls[type])
 			continue;
 		kcontrol->private_value = path->ctls[type];
-		err = func(kcontrol, ucontrol);
-		if (err < 0)
+		ret = func(kcontrol, ucontrol);
+		if (ret < 0) {
+			err = ret;
 			break;
+		}
+		if (ret > 0)
+			err = 1;
 	}
 	mutex_unlock(&codec->control_mutex);
 	if (err >= 0 && spec->cap_sync_hook)
-- 
2.30.2

