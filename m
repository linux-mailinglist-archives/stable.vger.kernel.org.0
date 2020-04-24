Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22BDD1B7749
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 15:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgDXNol (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 09:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726698AbgDXNok (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 09:44:40 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C4BC09B045
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 06:44:40 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id ep1so4655631qvb.0
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 06:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GrqwkdFthEBqmV0EtTHQbF1VPg6uCI8XEJMKDMyh0as=;
        b=reMptdcUfkhPGshqy/6RnWXmeBSTBbug+imnrttfwdK9Hn4aguqliKLxiDTGrHrDQM
         cQjXw8N9UR8VQ/kwgXPM0DIoQlqb4sE3ECXBCSxfa2MpQEvK2HiAAHhxf3c8Jg135rS3
         QyGI2hkWzBs8j7O9dy05RtAJjT3wkbVICBrT5vI+s9c1Yb0gDtmCeVgzfzwBSsu9uvfd
         qGGeWWNI920Qki5//bbxBkz8Zk3JUkBbHvOSzXlyl3CD18KpC7bSaGGoBgmZKXFoCwBw
         tNMzDsZxAsXbiZarNX6PBIyjdXdcRYiE/y87nnzXTpqeN11g2ZsHufdtgYK7tAIhKJoL
         1yIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GrqwkdFthEBqmV0EtTHQbF1VPg6uCI8XEJMKDMyh0as=;
        b=EyQqt25JJQu1jA3bWbuSqYaPPNIcZ4HWZqceQCrnAgyxBL4fBOUpjFpWKjQkNOwW5r
         rhfzvB7Ayexhz2A+Q5XgKtA9npJ3w5R0NsbkfzX/U90aHyq7Uaz6cD4NG71DYP9Rk2sD
         YaLbR4/rUkwWl3w5yKpi9y9NOxBiEic6AGorDJWLcRUZbk2PNJT/D0mPyd0Hze/1jkDE
         urjJPqhnGytsLuNooZqLRLYEN4zVmXIYJKfiBuQ7w4hNAPRKP/32tff0F1fTh+uDVoim
         p76VVnmhvdziD6m2JM8GbeZOLPziCHDGXlt/tiynVfnhqokZm53hf5iEbEXJPz4ijMkQ
         A5vw==
X-Gm-Message-State: AGi0PuaQ1pOZi7hYmx8a6YEihl7Ws3Gs3GEZrQVURJzjFeVw5b+j9gc6
        4+GorsiOfhc+spJS6U7pSYU97g==
X-Google-Smtp-Source: APiQypKcW62pt2L+mTN64ooWKizwU3N66xR0k/5MwAc1zgIPdIIOeJm2tvohmfg5gQrYhvktYABVxA==
X-Received: by 2002:a0c:a68a:: with SMTP id t10mr9031292qva.133.1587735879325;
        Fri, 24 Apr 2020 06:44:39 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::921])
        by smtp.gmail.com with ESMTPSA id k2sm4142562qta.39.2020.04.24.06.44.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 06:44:38 -0700 (PDT)
Date:   Fri, 24 Apr 2020 09:44:38 -0400
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     akpm@linux-foundation.org, mhocko@kernel.org,
        vdavydov.dev@gmail.com, linux-mm@kvack.org,
        Chris Down <chris@chrisdown.name>,
        Roman Gushchin <guro@fb.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm, memcg: fix wrong mem cgroup protection
Message-ID: <20200424134438.GA496852@cmpxchg.org>
References: <20200423061629.24185-1-laoar.shao@gmail.com>
 <20200424131450.GA495720@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424131450.GA495720@cmpxchg.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 24, 2020 at 09:14:52AM -0400, Johannes Weiner wrote:
> However, mem_cgroup_protected() never expected anybody to look at the
> effective protection values when it indicated that the cgroup is above
> its protection. As a result, a query during limit reclaim may return
> stale protection values that were calculated by a previous reclaim
> cycle in which the cgroup did have siblings.

Btw, I think there is opportunity to make this a bit less error prone.

We have a mem_cgroup_protected() that returns yes or no, essentially,
but protection isn't a binary state anymore.

It's also been a bit iffy that it looks like a simple predicate
function, but it indeed needs to run procedurally for each cgroup in
order for the calculations throughout the tree to be correct.

It might be better to have a

	mem_cgroup_calculate_protection()

that runs for every cgroup we visit and sets up the internal state;
then have more self-explanatory query functions on top of that:

	mem_cgroup_below_min()
	mem_cgroup_below_low()
	mem_cgroup_protection()

What do you guys think?

diff --git a/mm/vmscan.c b/mm/vmscan.c
index e0f502b5fca6..dbd3f75d39b9 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2615,14 +2615,15 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 		unsigned long reclaimed;
 		unsigned long scanned;
 
-		switch (mem_cgroup_protected(target_memcg, memcg)) {
-		case MEMCG_PROT_MIN:
+		mem_cgroup_calculate_protection(target_memcg, memcg);
+
+		if (mem_cgroup_below_min(memcg)) {
 			/*
 			 * Hard protection.
 			 * If there is no reclaimable memory, OOM.
 			 */
 			continue;
-		case MEMCG_PROT_LOW:
+		} else if (mem_cgroup_below_low(memcg)) {
 			/*
 			 * Soft protection.
 			 * Respect the protection only as long as
@@ -2634,16 +2635,6 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 				continue;
 			}
 			memcg_memory_event(memcg, MEMCG_LOW);
-			break;
-		case MEMCG_PROT_NONE:
-			/*
-			 * All protection thresholds breached. We may
-			 * still choose to vary the scan pressure
-			 * applied based on by how much the cgroup in
-			 * question has exceeded its protection
-			 * thresholds (see get_scan_count).
-			 */
-			break;
 		}
 
 		reclaimed = sc->nr_reclaimed;
