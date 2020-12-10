Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69FD32D5A47
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 13:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgLJMSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 07:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732601AbgLJMQy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 07:16:54 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA15C0613D6
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 04:16:08 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id m12so7880341lfo.7
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 04:16:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0ar8hH53wYzV5EGYe8r+sxUlCl+f/5B2F1ztEQKsN1o=;
        b=AUwfO51u4n2ZNY/p+jCIV9C7+WWCw2x3IN5oJuSbapM89leKpyPW1crbkTLx47kXPF
         6Db/SCJlFb57eoPrDDv275hIkOUEhb7BQLSKEQGQpxeXSGSzb5D0EsgfnAuCM8MHApKt
         i996WZRjVjbBXlo3XnusoTtrKAHb7I1OWadr/chmVHDUQXzjFDe3rj6OMvSH7l1AMPbf
         lasBL0YaS9nRJoEW6MhRLsi+3v7CR0X0eg1n9BRxPMuTeooK2Nbf//WB/zrw43/VpgvW
         3R9j0VkVKNWduT0aSW9Mz3DOqfIJY8eWmbrBcX/VZBVnAmNS0iVnbDn1rK01B5tnvLGG
         qOcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0ar8hH53wYzV5EGYe8r+sxUlCl+f/5B2F1ztEQKsN1o=;
        b=W+wpiVaWZkuF9hv1uD9AyAUbYn76Fds3NeD1Ye1f4kCMX8S9FbRQW1ERXqVTJZUbsO
         eA5lhUSVYJzrwSQLijPR5rHEs/sYWQ2ScNCvKMyGs+/+S/Y6o2fq/2zsorhg6D/8WogX
         BoXyC7nJnr7CBn19g7w845fEVg6foioXO2tCAxb5UJyvZPxhzTEsr5PQ5HUB+YHtEQuq
         cPGNN41CD8k4svN4+F2/WDIGKPWkEm4Cgk1D/A1U3TsN9esyTW8UN6m5PW9/WcJRMBY3
         VZNC9sqI4oqOXaoVRgcEMiaeRCL83bFhG8wblxq6OeZPFoo3QPYw5O4YtIhqjMf0kslY
         8xIA==
X-Gm-Message-State: AOAM532NCXKKvI6yWgsbzIgl0VpzkwH72LoLU7VSQ4YxoEPAd3gWakCZ
        qwIlQ436v1DVXf/ffFAl0lCNmw==
X-Google-Smtp-Source: ABdhPJxCHO95LPtqlAbB8kQDflAuKBEY7aL5wIPw3NQVdS0JmGyuMshrJuOweO/KpUjPPqsTVKM+7g==
X-Received: by 2002:a05:6512:32ac:: with SMTP id q12mr2669530lfe.298.1607602567114;
        Thu, 10 Dec 2020 04:16:07 -0800 (PST)
Received: from localhost.localdomain (89-70-221-122.dynamic.chello.pl. [89.70.221.122])
        by smtp.gmail.com with ESMTPSA id j25sm496090lfh.71.2020.12.10.04.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 04:16:06 -0800 (PST)
From:   Lukasz Majczak <lma@semihalf.com>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Mateusz Gorski <mateusz.gorski@linux.intel.com>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        Radoslaw Biernacki <rad@semihalf.com>,
        Alex Levin <levinale@google.com>,
        Guenter Roeck <groeck@google.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Lukasz Majczak <lma@semihalf.com>,
        stable@vger.kernel.org
Subject: [PATCH] ASoC: Intel: Skylake: Check the kcontrol against NULL
Date:   Thu, 10 Dec 2020 13:14:38 +0100
Message-Id: <20201210121438.7718-1-lma@semihalf.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There is no check for the kcontrol against NULL and in some cases
it causes kernel to crash.

Fixes: 2d744ecf2b984 ("ASoC: Intel: Skylake: Automatic DMIC format configuration according to information from NHLT")
Cc: <stable@vger.kernel.org> # 5.4+
Signed-off-by: Lukasz Majczak <lma@semihalf.com>
---
 sound/soc/intel/skylake/skl-topology.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/sound/soc/intel/skylake/skl-topology.c b/sound/soc/intel/skylake/skl-topology.c
index ae466cd592922..c9abbe4ff0ba3 100644
--- a/sound/soc/intel/skylake/skl-topology.c
+++ b/sound/soc/intel/skylake/skl-topology.c
@@ -3618,12 +3618,18 @@ static void skl_tplg_complete(struct snd_soc_component *component)
 	int i;
 
 	list_for_each_entry(dobj, &component->dobj_list, list) {
-		struct snd_kcontrol *kcontrol = dobj->control.kcontrol;
-		struct soc_enum *se =
-			(struct soc_enum *)kcontrol->private_value;
-		char **texts = dobj->control.dtexts;
+		struct snd_kcontrol *kcontrol;
+		struct soc_enum *se;
+		char **texts;
 		char chan_text[4];
 
+		kcontrol = dobj->control.kcontrol;
+		if(!kcontrol)
+			continue;
+
+		se = (struct soc_enum *)kcontrol->private_value;
+		texts = dobj->control.dtexts;
+
 		if (dobj->type != SND_SOC_DOBJ_ENUM ||
 		    dobj->control.kcontrol->put !=
 		    skl_tplg_multi_config_set_dmic)

base-commit: 69fe63aa100220c8fd1f451dd54dd0895df1441d
-- 
2.25.1

