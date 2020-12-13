Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D45F42D8AD0
	for <lists+stable@lfdr.de>; Sun, 13 Dec 2020 02:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439974AbgLMBVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Dec 2020 20:21:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439971AbgLMBVF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Dec 2020 20:21:05 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413C5C0613CF;
        Sat, 12 Dec 2020 17:20:25 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id y8so6712438plp.8;
        Sat, 12 Dec 2020 17:20:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5w7+jTgC8hBJiHtcsnmrY7j8FYxZ7rdBNlmPCyHcgzw=;
        b=PD/47T/zAPbDNd2ZPt8k9Mv+Mn1VXpQeAhkbcM7VQMohbhTNvjyEtL4VFn1CvygL91
         gqVBG/pL2SrfuMPfoVhZoZ/q27AuuyInxdJlSspeOgmUKlWMm0RoedXJTaL9jC3Blqxm
         G/1OIT1XPqiem/SagfHaMK28261VXClzwspLymV+pq+9jXcZBUSTpgSODIM0OURxvdFv
         VhTmvcHX7d5/nWBbFZoGuV4DCfZNf4jYOdAqJmQndy9lrcuL5WaZ67zXclw5SBokGary
         iih14x1dGf2m8ftOA6y7oBY8mhDPZLnp58jYO5Elck51q3Y3BbVKO66ZUwqddLLVCy8N
         yCUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5w7+jTgC8hBJiHtcsnmrY7j8FYxZ7rdBNlmPCyHcgzw=;
        b=OoSL4kpOFcFx16uzZulyatu6FeJMVF5rcrP6nvQZECg4g0iiYSivnr8OJsra79k+dc
         WFJml4E6jQVfitdrqeS8/Ako5uM0hgkprsykbJKjX7x0danBZs62ADRRtHVrY9vzqDmm
         s0CXc89ecF9ada9ByinqPqc3WeNlJPAzhKmAeFJyFeRT3LwG2jrmOZi4DouSVLBQfvrV
         XR3t7YQ8r55UihaSoe7eq9SiqyTtcRBqzirLDiX6zDfUZi8LC6i38aA+x8lDJWmc2UpZ
         MNrj5i2MCX3AQtJNya31BuAK7qZisUPCUppDID1T0Pe7tg82zu4McZsgXlJh/Gka/nW5
         cRFA==
X-Gm-Message-State: AOAM531M8hKSg/i48Lceghow65cZgk3ULePOH29BTMZ8cIB86zm4ZRpz
        9hcoZXp1fYv268M/Sp0UI4W+DG1tTByQKTrL
X-Google-Smtp-Source: ABdhPJxD7QxA9VZj9NvzLnEEK1zxJxuFW5VGThfbPVXjzDJ61BgCpHdj6MGvjGe97ihVxDShLrIOog==
X-Received: by 2002:a17:902:9b97:b029:da:4299:2214 with SMTP id y23-20020a1709029b97b02900da42992214mr17124758plp.37.1607822424413;
        Sat, 12 Dec 2020 17:20:24 -0800 (PST)
Received: from glados.. ([2601:647:6000:3e5b::a27])
        by smtp.gmail.com with ESMTPSA id u189sm1642670pfb.51.2020.12.12.17.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Dec 2020 17:20:24 -0800 (PST)
From:   Thomas Hebb <tommyhebb@gmail.com>
To:     linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
Cc:     Thomas Hebb <tommyhebb@gmail.com>, stable@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org
Subject: [PATCH] ASoC: dapm: remove widget from dirty list on free
Date:   Sat, 12 Dec 2020 17:20:12 -0800
Message-Id: <f8b5f031d50122bf1a9bfc9cae046badf4a7a31a.1607822410.git.tommyhebb@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A widget's "dirty" list_head, much like its "list" list_head, eventually
chains back to a list_head on the snd_soc_card itself. This means that
the list can stick around even after the widget (or all widgets) have
been freed. Currently, however, widgets that are in the dirty list when
freed remain there, corrupting the entire list and leading to memory
errors and undefined behavior when the list is next accessed or
modified.

I encountered this issue when a component failed to probe relatively
late in snd_soc_bind_card(), causing it to bail out and call
soc_cleanup_card_resources(), which eventually called
snd_soc_dapm_free() with widgets that were still dirty from when they'd
been added.

Fixes: db432b414e20 ("ASoC: Do DAPM power checks only for widgets changed since last run")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>
---

 sound/soc/soc-dapm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 7f87b449f950..148c095df27b 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -2486,6 +2486,7 @@ void snd_soc_dapm_free_widget(struct snd_soc_dapm_widget *w)
 	enum snd_soc_dapm_direction dir;
 
 	list_del(&w->list);
+	list_del(&w->dirty);
 	/*
 	 * remove source and sink paths associated to this widget.
 	 * While removing the path, remove reference to it from both
-- 
2.29.2

