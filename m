Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE4112B494
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 13:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbfL0MoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 07:44:16 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36795 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfL0MoQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Dec 2019 07:44:16 -0500
Received: by mail-pl1-f196.google.com with SMTP id a6so10964727plm.3
        for <stable@vger.kernel.org>; Fri, 27 Dec 2019 04:44:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=n+mXUnSBdUmpj+rPxKhgXq+NePAWLTnS1N3EeApr+XU=;
        b=MClM5SS7oF7CHekECq80qPRhE7p20RkNMF9ENF0twOArz78T0bPiy1T+Wad1Pe57yV
         dVtWTNHYbEqKmd2k31Okt4zhDIvhG6rIKBexkC4+bbnFIpGgsuFgMffbDT88omSusPNk
         myDvOHwO+d8TuGbY+A7gBYVha8NY1PRYpiGJ3taTTn+ibKucAerEIfct+2JdY2OVDefj
         rJhOxatKXAfy9mb8wuyETiK9hZTvSrYzInH7Lbpqt9H3iu8ea1klZI9WdemZHuXdwzyG
         RGXWPggybOWr65DwbqFv65FlY2oKyzPQbDnKcM4SICDzvb8JGVKU9k1kyMmigRL3UnQR
         7a5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=n+mXUnSBdUmpj+rPxKhgXq+NePAWLTnS1N3EeApr+XU=;
        b=bbieQjO1G2Xt27RDoWX4OhC/qpbFW0FMUg2k34rx8zoYUYqcN4CDnOY6Xjdpv3OK5v
         qqhiJRRRLWSoNsErfDv+D2dXv6g4NNwgoUiOQqoLTk81m8eyNEOIhVTDgbebFaHjrCIj
         Hk+P6Xg/EWI7rUo9h4M1F09FqjradYH/F6owt/C++91BMhQ4V85+meIlH4LIBkWe0l/1
         vp2x2xCqZW6xhaeSdSEnKH79jkblo8w66g3JFTxucG6dcbv6XEqHwfD35Zpall7QmyGK
         ZY5BY38WbqtHShgUOD1JEJyt7qLW/9Z0FTYOsiPCmpPmHY2KyqY7VWLYW7UtJ1aN+8u4
         NAcg==
X-Gm-Message-State: APjAAAW+ceMUwCeE96dWWKzpgeZxfMFzXAFsnIEYTa0DhVaPKposyg7U
        JdicTVzz3N6oH0LDlrYL06c=
X-Google-Smtp-Source: APXvYqwgKLBTx3Hcbrh/WHlWE/LXA4+A1BPxsuTm/PkYpjc0qumV0yS72w7efbXfZQ5HQDicNLxrAQ==
X-Received: by 2002:a17:902:241:: with SMTP id 59mr17878300plc.36.1577450655997;
        Fri, 27 Dec 2019 04:44:15 -0800 (PST)
Received: from dev.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id c2sm14125591pjq.27.2019.12.27.04.44.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Dec 2019 04:44:15 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        vdavydov.dev@gmail.com, akpm@linux-foundation.org
Cc:     linux-mm@kvack.org, Yafang Shao <laoar.shao@gmail.com>,
        Chris Down <chris@chrisdown.name>, stable@vger.kernel.org
Subject: [PATCH] mm, memcg: reset memcg's memory.{min, low} for reclaiming itself
Date:   Fri, 27 Dec 2019 07:43:53 -0500
Message-Id: <1577450633-2098-2-git-send-email-laoar.shao@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1577450633-2098-1-git-send-email-laoar.shao@gmail.com>
References: <1577450633-2098-1-git-send-email-laoar.shao@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

memory.{emin, elow} are set in mem_cgroup_protected(), and the values of
them won't be changed until next recalculation in this function. After
either or both of them are set, the next reclaimer to relcaim this memcg
may be a different reclaimer, e.g. this memcg is also the root memcg of
the new reclaimer, and then in mem_cgroup_protection() in get_scan_count()
the old values of them will be used to calculate scan count, that is not
proper. We should reset them to zero in this case.

Here's an example of this issue.

    root_mem_cgroup
         /
        A   memory.max=1024M memory.min=512M memory.current=800M

Once kswapd is waked up, it will try to scan all MEMCGs, including
this A, and it will assign memory.emin of A with 512M.
After that, A may reach its hard limit(memory.max), and then it will
do memcg reclaim. Because A is the root of this reclaimer, so it will
not calculate its memory.emin. So the memory.emin is the old value
512M, and then this old value will be used in
mem_cgroup_protection() in get_scan_count() to get the scan count.
That is not proper.

Fixes: 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Roman Gushchin <guro@fb.com>
Cc: stable@vger.kernel.org
---
 mm/memcontrol.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 601405b..bb3925d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6287,8 +6287,17 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
 
 	if (!root)
 		root = root_mem_cgroup;
-	if (memcg == root)
+	if (memcg == root) {
+		/*
+		 * Reset memory.(emin, elow) for reclaiming the memcg
+		 * itself.
+		 */
+		if (memcg != root_mem_cgroup) {
+			memcg->memory.emin = 0;
+			memcg->memory.elow = 0;
+		}
 		return MEMCG_PROT_NONE;
+	}
 
 	usage = page_counter_read(&memcg->memory);
 	if (!usage)
-- 
1.8.3.1

