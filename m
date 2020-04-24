Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6071B76B5
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 15:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgDXNOy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 09:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726806AbgDXNOx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 09:14:53 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577FEC09B045
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 06:14:53 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id ep1so4606837qvb.0
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 06:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Mp6P7EuowXgf1Z05AVHM5X9/T2fvGq2V0AUIWl56Bfc=;
        b=sI9lU2rwmoOgQb4sOWPMx6/2JwNm8o6yusvDcM5jFn65xHqx1AVtLstARmFCCi785q
         ciie5Q/3FVP5a09qc6LjdzXeBx/h0JcAfwN5KrN0uDBY7IJ9T7PadA7MtakDn/ptURUG
         e1JRgF3OothN+HKLtVW4vFtbaJSbsApMBao/AgMgdc+vLUsIFAS8m2k6p5F6r8yQcFQD
         tfcA2GoN+PIjquTuPyUPMswEr/JdvQdoAvnWYEVMV0Bwo1uW17IqXdAivknRTGabND9/
         Tjc+nE7V6fX9Rc1DuUbsAUjWQbaS4O5kYbiIbqkL/2+T7eBCT/KieV94Z0Hsjp6qLQ9f
         Apqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Mp6P7EuowXgf1Z05AVHM5X9/T2fvGq2V0AUIWl56Bfc=;
        b=TcPEUPGe+KdDn4cs6QQr1mHYoLygR6cA4uC0+D6Vo+7IB8YajSKpXoTzDKmOSJYdb1
         6AZwaF0rcxprzvIywCSaI+vInxTeQ9uRdXqtMnkwnhnVSkMZmATjBJIaPhqMBFM0vNVT
         PJtLn1mIM5X7uIU3NTGYg2vzy28gZX1mt+YBOP9ZFCB81pkUcv+dlp/4AK1U7CChzCEn
         iV1gv1xWXP9j2GNJkt/cUdieBFt7R5ADjQr4lXVxQewc9RSJ77ywlw4S6NJd99gGPJum
         ILcjEZzEzY2Sp0EtifHJY4GNRi3UJT4PqFahW27c6eK2FECBg1+RSIgqSOkyvIkU/5cA
         V35Q==
X-Gm-Message-State: AGi0PuYeBo8ZrSOJjRSfLPL/ILi/+nglS5WxVYTooMKiQK9MTuSZ+DvZ
        OQ1RAjld9o8T0MlWdOvbnMorMw==
X-Google-Smtp-Source: APiQypK8s2Ta3EVuQQRTzavHi6y2BDX8/R3BppjjGl+RVv9oXfLDBkmlpV0kzCcV9rFLr/QZdupKOQ==
X-Received: by 2002:a0c:e8c2:: with SMTP id m2mr8747891qvo.24.1587734092456;
        Fri, 24 Apr 2020 06:14:52 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::921])
        by smtp.gmail.com with ESMTPSA id u126sm3666208qkh.66.2020.04.24.06.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 06:14:51 -0700 (PDT)
Date:   Fri, 24 Apr 2020 09:14:50 -0400
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     akpm@linux-foundation.org, mhocko@kernel.org,
        vdavydov.dev@gmail.com, linux-mm@kvack.org,
        Chris Down <chris@chrisdown.name>,
        Roman Gushchin <guro@fb.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm, memcg: fix wrong mem cgroup protection
Message-ID: <20200424131450.GA495720@cmpxchg.org>
References: <20200423061629.24185-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423061629.24185-1-laoar.shao@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 23, 2020 at 02:16:29AM -0400, Yafang Shao wrote:
> This patch is an improvement of a previous version[1], as the previous
> version is not easy to understand.
> This issue persists in the newest kernel, I have to resend the fix. As
> the implementation is changed, I drop Roman's ack from the previous
> version.

Now that I understand the problem, I much prefer the previous version.

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 745697906ce3..2bf91ae1e640 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6332,8 +6332,19 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
 
 	if (!root)
 		root = root_mem_cgroup;
-	if (memcg == root)
+	if (memcg == root) {
+		/*
+		 * The cgroup is the reclaim root in this reclaim
+		 * cycle, and therefore not protected. But it may have
+		 * stale effective protection values from previous
+		 * cycles in which it was not the reclaim root - for
+		 * example, global reclaim followed by limit reclaim.
+		 * Reset these values for mem_cgroup_protection().
+		 */
+		memcg->memory.emin = 0;
+		memcg->memory.elow = 0;
 		return MEMCG_PROT_NONE;
+	}
 
 	usage = page_counter_read(&memcg->memory);
 	if (!usage)

> Here's the explanation of this issue.
> memory.{low,min} won't take effect if the to-be-reclaimed memcg is the
> sc->target_mem_cgroup, that can also be proved by the implementation in
> mem_cgroup_protected(), see bellow,
> 	mem_cgroup_protected
> 		if (memcg == root) [2]
> 			return MEMCG_PROT_NONE;
> 
> But this rule is ignored in mem_cgroup_protection(), which will read
> memory.{emin, elow} as the protection whatever the memcg is.
> 
> How would this issue happen?
> Because in mem_cgroup_protected() we forget to clear the
> memory.{emin, elow} if the memcg is target_mem_cgroup [2].
> 
> An example to illustrate this issue.
>    root_mem_cgroup
>          /
>         A   memory.max: 1024M
>             memory.min: 512M
>             memory.current: 800M ('current' must be greater than 'min')
> Once kswapd starts to reclaim memcg A, it assigns 512M to memory.emin of A.
> Then kswapd stops.
> As a result of it, the memory values of A will be,
>    root_mem_cgroup
>          /
>         A   memory.max: 1024M
>             memory.min: 512M
>             memory.current: 512M (approximately)
>             memory.emin: 512M
> 
> Then a new workload starts to run in memcg A, and it will trigger memcg
> relcaim in A soon. As memcg A is the target_mem_cgroup of this
> reclaimer, so it return directly without touching memory.{emin, elow}.[2]
> The memory values of A will be,
>    root_mem_cgroup
>          /
>         A   memory.max: 1024M
>             memory.min: 512M
>             memory.current: 1024M (approximately)
>             memory.emin: 512M
> Then this memory.emin will be used in mem_cgroup_protection() to get the
> scan count, which is obvoiusly a wrong scan count.
> 
> [1]. https://lore.kernel.org/linux-mm/20200216145249.6900-1-laoar.shao@gmail.com/
> 
> Fixes: 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
> Cc: Chris Down <chris@chrisdown.name>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>

As others have noted, it's fairly hard to understand the problem from
the above changelog. How about the following:

A cgroup can have both memory protection and a memory limit to isolate
it from its siblings in both directions - for example, to prevent it
from being shrunk below 2G under high pressure from outside, but also
from growing beyond 4G under low pressure.

9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
implemented proportional scan pressure so that multiple siblings in
excess of their protection settings don't get reclaimed equally but
instead in accordance to their unprotected portion.

During limit reclaim, this proportionality shouldn't apply of course:
there is no competition, all pressure is from within the cgroup and
should be applied as such. Reclaim should operate at full efficiency.

However, mem_cgroup_protected() never expected anybody to look at the
effective protection values when it indicated that the cgroup is above
its protection. As a result, a query during limit reclaim may return
stale protection values that were calculated by a previous reclaim
cycle in which the cgroup did have siblings.

When this happens, reclaim is unnecessarily hesitant and potentially
slow to meet the desired limit. In theory this could lead to premature
OOM kills, although it's not obvious this has occurred in practice.
