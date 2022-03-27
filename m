Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 681484E86EB
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 10:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiC0IXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 04:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiC0IXX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 04:23:23 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782ED2653;
        Sun, 27 Mar 2022 01:21:45 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id c23so12284390plo.0;
        Sun, 27 Mar 2022 01:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=Mhix+urzc1FsDasWqNeU8stTynB6saIQVpKl08OSCjk=;
        b=aRWl1/Pr3/FHCGVeOLGeCqVbwbyOUpu+WXyGSqMuAWaR5sT8rAfgabm3jVAaHYkQhf
         PeF7S4fHnoTgfIOXCUJ0MOrLBz/TYahv8inuOHiCHM8LDnUkbiJDuFeWo627eBVliVY6
         +R/aC6Ur0jk2FsD7n8oNlhyjpDYw5nsYWlAQEY8wbNlfkRy4Y+/jMqqkgVV9xVWO2fqG
         gEAQdDHMm/4FWLFgPlcC3S9sMIvHBMkesMGfGuw/v9DNh2wtELCd6XsEo6Bfl2DOq5z4
         Z6ul1iSsdX2tMZ5Eo91iqt7VbO/cvSR0p2x3diwTkeJC+zk/BDQvzuDdWGZ6lP/wf8Hf
         WHbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Mhix+urzc1FsDasWqNeU8stTynB6saIQVpKl08OSCjk=;
        b=43Hf0A1mlrTaQLwdnEQaw2THOQ/PMalmNa748I62pajywsxCU5piiodxKslgSrfpJz
         cXAnCPHi9vnzVYqIyrAL+49xIeAC//oAvmvz7zOoYofIH5VaMissuDFCj/uaNGJk7XpS
         oXPLSZibNoZntPrjGQOK35VsGxI8kHIzUSVi5c4C1KBe5loKwDt+dX7UlH4QBumPij8S
         wB4kZ4cT9+2pH3umbJasyF+PCmmAlUOhNnTQDRrmbAM3Prew4/MFze7DRU9wWCQiBpSs
         bDuCqUwWHFbX4eoEHfRecZQo4WXbQ7mKneCbj35d505NO5cPYETCOv/+ldHGoqEfbdfi
         zu/A==
X-Gm-Message-State: AOAM531NHTxP+zn3fIHIuahui3cbitTJQDhDf7JOPj8AFuym/ILdvqbp
        QQ3U/5oqBRhcUn/PkWbZnfc=
X-Google-Smtp-Source: ABdhPJyCR76yNDb79V+3zmBV84Cq54AmXRpo6EPzFSzVrRRlixTTvFbW58p5I87J9LdC9dwd4MdDxg==
X-Received: by 2002:a17:902:e74d:b0:154:46d4:fcd1 with SMTP id p13-20020a170902e74d00b0015446d4fcd1mr20397397plf.58.1648369304850;
        Sun, 27 Mar 2022 01:21:44 -0700 (PDT)
Received: from localhost ([115.220.243.108])
        by smtp.gmail.com with ESMTPSA id f16-20020a056a001ad000b004fb358ffe86sm3753370pfv.137.2022.03.27.01.21.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 27 Mar 2022 01:21:44 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz,
        tiwai@suse.com
Cc:     alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] soc: soc-dapm: fix two incorrect uses of list iterator
Date:   Sun, 27 Mar 2022 16:21:38 +0800
Message-Id: <20220327082138.13696-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These two bug are here:
	list_for_each_entry_safe_continue(w, n, list,
					power_list);
	list_for_each_entry_safe_continue(w, n, list,
					power_list);

After the list_for_each_entry_safe_continue() exits, the list iterator
will always be a bogus pointer which point to an invalid struct objdect
containing HEAD member. The funciton poniter 'w->event' will be a
invalid value which can lead to a control-flow hijack if the 'w' can be
controlled.

The original intention was to break the outer list_for_each_entry_safe()
loop if w->event is NULL, but forgot to *break* switch statement first.
So just add a break to fix the bug.

Cc: stable@vger.kernel.org
Fixes: 163cac061c973 ("ASoC: Factor out DAPM sequence execution")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 sound/soc/soc-dapm.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index b06c5682445c..2a5a64d21856 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -1686,9 +1686,11 @@ static void dapm_seq_run(struct snd_soc_card *card,
 
 		switch (w->id) {
 		case snd_soc_dapm_pre:
-			if (!w->event)
+			if (!w->event) {
 				list_for_each_entry_safe_continue(w, n, list,
 								  power_list);
+				break;
+			}
 
 			if (event == SND_SOC_DAPM_STREAM_START)
 				ret = w->event(w,
@@ -1699,9 +1701,11 @@ static void dapm_seq_run(struct snd_soc_card *card,
 			break;
 
 		case snd_soc_dapm_post:
-			if (!w->event)
+			if (!w->event) {
 				list_for_each_entry_safe_continue(w, n, list,
 								  power_list);
+				break;
+			}
 
 			if (event == SND_SOC_DAPM_STREAM_START)
 				ret = w->event(w,
-- 
2.17.1

