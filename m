Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0934EA48E
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 03:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiC2BX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 21:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiC2BX2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 21:23:28 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1082C117;
        Mon, 28 Mar 2022 18:21:45 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id t2so14449112pfj.10;
        Mon, 28 Mar 2022 18:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=nGUt+aj/CNfWrM2Ds8HvT/Dl56Vks6aVB/g96nW8bf8=;
        b=CDT/BuavpP8mQxwjlPaichjpYYhA3Pw5JcLcuD/nscNa9g9fnbkC3tpHyJqdSexocF
         zFhQRERUhpt+lkdFizRqiSfEzjvH94C69yp6cRX2WnpK9ax1Z/pulaCRMCJkMmdtu1/m
         kqKBw8HtGQgdVEFMMuJdfWWoounDtqP92su7IXtOCPxCVpFWJgwZ555vugcwen10Bw+Y
         3zFCWzY8DEZAiRXmmsAlMptcmOJ0l3XDPVmDWbCKj5Ez/+UmTuJyDO8oYwBixSrRCL8o
         AJtCVg3evK6iTcQA0t3sBdngLoQRMxexm4kaWSC404LdoglxH6F8HdK7Hjzuv+zjydj0
         +ftQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nGUt+aj/CNfWrM2Ds8HvT/Dl56Vks6aVB/g96nW8bf8=;
        b=pbRbXNtOSt4TPlN+S49vV48hkSFOrKAkja5uE6QKJmpf2Ns4DO1p+nWVqrnvRFP1H6
         VlEwRZep/+AMPz47H9gnWdC0lo/lHz2a6XbpE7W5ym/BNdAEyIJ6JkF7ApKuk82KCw81
         otxs5Z/MRG7/xEAaB858pEILZ+njh84ipVLWp5upW6/4gEthZZwOhtP4pdwvrWwDgjTx
         lN3spEkRl4zF6vsFzdffiCWhwOPwf+K5+EHk+FCXinmL3t3h2GNNJGrJVaTEVAp+Wami
         MW+PBlgMjo9C98zuoI+10GIVPY6Z4RWsBGMlcb5GUD7FQwsM8kdzlqBOUAKxCXXFy6Rk
         D34Q==
X-Gm-Message-State: AOAM532M0JmgTs2urqlVmTVTNzDql9aXkzSdvCpcF8DKr3itlxiDwiKH
        ThWfQDJDFvmZUodgR3545XM=
X-Google-Smtp-Source: ABdhPJwDvk6CTkxu40Th8VYA7G8Ypnxcz3UfPRvUwaSKEbrhu8GZ/6nnc6yLDNCGDEC1DyUuejQVKQ==
X-Received: by 2002:a63:5020:0:b0:382:4781:7f4c with SMTP id e32-20020a635020000000b0038247817f4cmr176192pgb.230.1648516904993;
        Mon, 28 Mar 2022 18:21:44 -0700 (PDT)
Received: from localhost ([119.3.119.18])
        by smtp.gmail.com with ESMTPSA id i15-20020a63b30f000000b003803aee35a2sm13711447pgf.31.2022.03.28.18.21.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 28 Mar 2022 18:21:44 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz,
        tiwai@suse.com
Cc:     alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v2] soc: soc-dapm: fix two incorrect uses of list iterator
Date:   Tue, 29 Mar 2022 09:21:34 +0800
Message-Id: <20220329012134.9375-1-xiam0nd.tong@gmail.com>
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

The original intention was to continue the outer list_for_each_entry_safe()
loop with the same entry if w->event is NULL, but misunderstanding the
meaning of list_for_each_entry_safe_continue().

So just add a 'continue;' to fix the bug.

Cc: stable@vger.kernel.org
Fixes: 163cac061c973 ("ASoC: Factor out DAPM sequence execution")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---

changes since v1:
 - use continue statement instead (Mark Brown)

v1:https://lore.kernel.org/lkml/20220327082138.13696-1-xiam0nd.tong@gmail.com/

---
 sound/soc/soc-dapm.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index b06c5682445c..fb43b331a36e 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -1687,8 +1687,7 @@ static void dapm_seq_run(struct snd_soc_card *card,
 		switch (w->id) {
 		case snd_soc_dapm_pre:
 			if (!w->event)
-				list_for_each_entry_safe_continue(w, n, list,
-								  power_list);
+				continue;
 
 			if (event == SND_SOC_DAPM_STREAM_START)
 				ret = w->event(w,
@@ -1700,8 +1699,7 @@ static void dapm_seq_run(struct snd_soc_card *card,
 
 		case snd_soc_dapm_post:
 			if (!w->event)
-				list_for_each_entry_safe_continue(w, n, list,
-								  power_list);
+				continue;
 
 			if (event == SND_SOC_DAPM_STREAM_START)
 				ret = w->event(w,
-- 
2.17.1

