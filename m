Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E31752FF27A
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 18:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389176AbhAURwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 12:52:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389139AbhAURwh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jan 2021 12:52:37 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BAC6C06174A
        for <stable@vger.kernel.org>; Thu, 21 Jan 2021 09:51:54 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id w1so3820512ejf.11
        for <stable@vger.kernel.org>; Thu, 21 Jan 2021 09:51:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=51VcyZ0wcuGuW2m213F8YE94gBtxdpp+DVm+1XUV/kc=;
        b=H5RbvKJzOAZSzZttqk+4D6J5otSROP5TEODNUwb21iPJKfP+Ab3VInvWrEmmIXc51D
         kT4vXcIGucGm/xDXGd5766NQhpstAG53Q8NLEmg4cvuF7NJn7NI2aqKPPNarNCatpphL
         n04UttoRPSTulyYrFLysFiGhqiFnUg2Vsf0CI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=51VcyZ0wcuGuW2m213F8YE94gBtxdpp+DVm+1XUV/kc=;
        b=lReJemOQbmPLos30Q7YsybZwVDtqX+h1AaP58o0kj0hdkkDT1ZPWiOppRfRVtT8E+Q
         dzuq6qyiPUUSopYMEuFLc4xuXEQnPhQlxkAwyQBQ+HxYxfdV6KN2VTXlhH2oEhrMub9d
         Ypo086MqqLj1rjg5MZcE+sLkmc9U9dXcZGdAaOZEfqARTtrGcitvHNYhjHgD8VW4ir0O
         s914zAJomYyU9R1KiKHrgjtpGs2/6YEnHLC7IcAlhO5+J2RncLNFfK1rMUxazB8j+Pms
         G+DtUMuK3234or1umbTcILY1H9WSsMoA70QQMFs6c9cyJCdT+HEuaBy68aCAPLt82Uec
         LOiQ==
X-Gm-Message-State: AOAM531yFHKAmWcQpYFi0f7QIldcRDWA66j2VEDdNL0MJNfSZ+kOd/yT
        JogvzS58Kos+nS4O2/9RVlYoIQ==
X-Google-Smtp-Source: ABdhPJx+D8/Miw7niFfErjOQWn8sH7EaMNhkJL7TJSDo4zIFgNNDjogLT0p7KxD+/CzpFUu1z+e5Lw==
X-Received: by 2002:a17:906:4893:: with SMTP id v19mr421764ejq.454.1611251513363;
        Thu, 21 Jan 2021 09:51:53 -0800 (PST)
Received: from alco.lan ([80.71.134.83])
        by smtp.gmail.com with ESMTPSA id w16sm3232349edv.4.2021.01.21.09.51.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 09:51:52 -0800 (PST)
From:   Ricardo Ribalda <ribalda@chromium.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Jie Yang <yang.jie@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Mateusz Gorski <mateusz.gorski@linux.intel.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Lukasz Majczak <lma@semihalf.com>
Cc:     Ricardo Ribalda <ribalda@chromium.org>, stable@vger.kernel.org
Subject: [PATCH v3 1/2] ASoC: Intel: Skylake: skl-topology: Fix OOPs ib skl_tplg_complete
Date:   Thu, 21 Jan 2021 18:51:50 +0100
Message-Id: <20210121175151.139111-1-ribalda@chromium.org>
X-Mailer: git-send-email 2.30.0.296.g2bfb1c46d8-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If dobj->control is not initialized we end up in an OOPs during
skl_tplg_complete:

[   26.553358] BUG: kernel NULL pointer dereference, address:
0000000000000078
[   26.561151] #PF: supervisor read access in kernel mode
[   26.566897] #PF: error_code(0x0000) - not-present page
[   26.572642] PGD 0 P4D 0
[   26.575479] Oops: 0000 [#1] PREEMPT SMP PTI
[   26.580158] CPU: 2 PID: 2082 Comm: udevd Tainted: G         C
5.4.81 #4
[   26.588232] Hardware name: HP Soraka/Soraka, BIOS
Google_Soraka.10431.106.0 12/03/2019
[   26.597082] RIP: 0010:skl_tplg_complete+0x70/0x144 [snd_soc_skl]

Cc: <stable@vger.kernel.org>
Fixes: 2d744ecf2b98 ("ASoC: Intel: Skylake: Automatic DMIC format configuration according to information from NHL")
Tested-by: Lukasz Majczak <lma@semihalf.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
---
v3: order local variables by length

 sound/soc/intel/skylake/skl-topology.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/sound/soc/intel/skylake/skl-topology.c b/sound/soc/intel/skylake/skl-topology.c
index ae466cd59292..ffd37aaecdf1 100644
--- a/sound/soc/intel/skylake/skl-topology.c
+++ b/sound/soc/intel/skylake/skl-topology.c
@@ -3619,15 +3619,16 @@ static void skl_tplg_complete(struct snd_soc_component *component)
 
 	list_for_each_entry(dobj, &component->dobj_list, list) {
 		struct snd_kcontrol *kcontrol = dobj->control.kcontrol;
-		struct soc_enum *se =
-			(struct soc_enum *)kcontrol->private_value;
-		char **texts = dobj->control.dtexts;
+		struct soc_enum *se;
 		char chan_text[4];
+		char **texts;
 
-		if (dobj->type != SND_SOC_DOBJ_ENUM ||
-		    dobj->control.kcontrol->put !=
-		    skl_tplg_multi_config_set_dmic)
+		if (dobj->type != SND_SOC_DOBJ_ENUM || !kcontrol ||
+		    kcontrol->put != skl_tplg_multi_config_set_dmic)
 			continue;
+
+		se = (struct soc_enum *)kcontrol->private_value;
+		texts = dobj->control.dtexts;
 		sprintf(chan_text, "c%d", mach->mach_params.dmic_num);
 
 		for (i = 0; i < se->items; i++) {
-- 
2.30.0.296.g2bfb1c46d8-goog

