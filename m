Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558BD22F8CE
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 21:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbgG0TRt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 15:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728059AbgG0TRs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 15:17:48 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8899FC061794
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 12:17:48 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id g4so2286445qki.8
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 12:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=IuAjz4vWP+fsmZ6TnPVAPxVEm1W+CToccHqyQuZwo7Q=;
        b=u4QYjAZkNActz3iV9FwwwZWe9IIgE0NWGDYYvwYHjniyikO57M1sL1w0GI0Vnl7fuU
         WMntdEWj7xLCxrtltDxnlyCiL3CeLZkTMX4qVwvu+0ln8jmKdcJ5cYKQUvhY89JXvQXS
         awBJ53QodvWSmyrdtnUQM68cEA/SoVu+9haP5fOioaNvGrvzTQ6pkEspKIxYUyHIKnqq
         T3asTHK6Aj+VttHnh7fHQ33kcP3Ll33R6/fRsQ36P/wkAyeWIk9Up8DbZ5p+dUn5LYAe
         6x1mPRdsxXFj4fgMYU08dziW5kjP2yNfcgPqmswqDGnnA5dba757LBr6+ax7vxLB/oTD
         mOAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=IuAjz4vWP+fsmZ6TnPVAPxVEm1W+CToccHqyQuZwo7Q=;
        b=VXPwnz8ZEAPQSzwS1kghYN5T1xBGO506RJbpaXlNglgsi0wzTT3dHpttVEixyQ+LVL
         LJf2rRqh5w+qxrfVvh2tYPGMvPBQpq/y6vOJiZB2XzvGG49DXTqM237Je6sGAE0pgMvQ
         sdRZscRkW6Y2/aAs3e8+fc02bEZ4b/+dSJuFSy4p1/dUaZS8RbhSrLtHY5oxBGH1o+wi
         Hyjn1ldZkZqUu8m4d2BZZZDf/DOQim+h12M1yj6qYIXYEPyLQDd2GrHJpzY0vRo6Ul71
         yjSyG+YFT8rIOhb2jb+Fzn8g7lrY58EAD0l1n/lm4TmbMhQ1efF0sczJQbOh/1QPD20F
         xvVA==
X-Gm-Message-State: AOAM5303C6GbSPV3EdqsNalDsUA3MmWqVnlaBtOs9FYzc1iDxMyCj/mb
        0GS4ah5uJpBHpps7Ydbn7U+P5/bP5V8sc+dK5uMwmtA76WLTJ1XNhMwfx/ecwXOEwtLRYiHhqr2
        osfgLNLp34hEt/RBpn7AnvY8j7BYnybR9cfqfP5yZvD23lutWUzYFqaVRNwOiP/r6o/34xwcFXF
        puxQ==
X-Google-Smtp-Source: ABdhPJwTR4mDzUGuFSFBwloxnvoyPOIeoARs8eCAQ4uf558Ox+DkBx6RXqhein/9pGIMSx7AwnY92Pv0odO+EzKX5so=
X-Received: by 2002:a0c:bf4f:: with SMTP id b15mr22352173qvj.224.1595877467520;
 Mon, 27 Jul 2020 12:17:47 -0700 (PDT)
Date:   Mon, 27 Jul 2020 12:17:45 -0700
Message-Id: <20200727191746.3644844-1-ndesaulniers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH 4.14.y] mm/page_owner.c: remove drain_all_pages from init_early_allocated_pages
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     stable@vger.kernel.org
Cc:     Miles Chen <miles.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-mediatek@lists.infradead.org,
        Oscar Salvador <osalvador@techadventures.net>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oscar Salvador <osalvador@techadventures.net>

commit u6bec6ad77fac3d29aed0d8e0b7526daedc964970 upstream.

When setting page_owner = on, the following warning can be seen in the
boot log:

  WARNING: CPU: 0 PID: 0 at mm/page_alloc.c:2537 drain_all_pages+0x171/0x1a0
  Modules linked in:
  CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.15.0-rc7-next-20180109-1-default+ #7
  Hardware name: Dell Inc. Latitude E7470/0T6HHJ, BIOS 1.11.3 11/09/2016
  RIP: 0010:drain_all_pages+0x171/0x1a0
  Call Trace:
    init_page_owner+0x4e/0x260
    start_kernel+0x3e6/0x4a6
    ? set_init_arg+0x55/0x55
    secondary_startup_64+0xa5/0xb0
  Code: c5 ed ff 89 df 48 c7 c6 20 3b 71 82 e8 f9 4b 52 00 3b 05 d7 0b f8 00 89 c3 72 d5 5b 5d 41 5

This warning is shown because we are calling drain_all_pages() in
init_early_allocated_pages(), but mm_percpu_wq is not up yet, it is being
set up later on in kernel_init_freeable() -> init_mm_internals().

Link: http://lkml.kernel.org/r/20180109153921.GA13070@techadventures.net
Signed-off-by: Oscar Salvador <osalvador@techadventures.net>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ayush Mittal <ayush.m@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
Fixes an easliy reproduced WARN_ON_ONCE observed with
CONFIG_PAGE_OWNER=y and page_owner=on boot param.  Looks like this
landed in v4.15-rc9 but hasn't been backported yet. Thanks to
Miles Chen <miles.chen@mediatek.com> for the report.

 mm/page_owner.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 6ac05a6ff2d1..4753b317ef7b 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -617,7 +617,6 @@ static void init_early_allocated_pages(void)
 {
 	pg_data_t *pgdat;
 
-	drain_all_pages(NULL);
 	for_each_online_pgdat(pgdat)
 		init_zones_in_node(pgdat);
 }
-- 
2.28.0.rc0.142.g3c755180ce-goog

