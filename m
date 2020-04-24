Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9813F1B75B2
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 14:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbgDXMpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 08:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726707AbgDXMpD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 08:45:03 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373DFC09B045
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 05:45:03 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id i3so10138889ioo.13
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 05:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C9eaDvvJ77XZj4T792zYETZIjpst74RXf8cetFIYTV0=;
        b=IPtI4KQHxwUwaaA8eOqyqVqQPA+KsITCVvkSTir8OP6/4c4rXQELT0ZEIzfsLYliYO
         pyr69zy7+lTXHBIxL+LPnQClEPDnfyS7uuDVUjsuARqB+IsdlVW9Cx1pijGKawS6UXNO
         trNHaCuch69bbRxLkZHDmnjudOlu+iSeFsX+OWp4Ix+aMmmdWQh129dODnP5xph0dBNW
         gGel7/TsdFG8AEAb7MyQo11a43rR4OLRlP4cAOPbtjaUu1zJFOQERh9Yz2IQnPfTPROb
         WMUE5pGZ2ee4WMem+hGjie8dj1DS1ViNXe8Eou7m3q8wsRdVczlUKvigFeBFZT5Dt02U
         Jhcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C9eaDvvJ77XZj4T792zYETZIjpst74RXf8cetFIYTV0=;
        b=SPms71o6UtIWx8RA1m37mr10Shq4pCSyT0HZ1cLrrO4nbSBmjwyhxPvGwNPvcvqYAc
         LSiFFeJGkBR01Hw8YNRIJiUe2+A+K6KF7frlXkvkG27iemLc+jw0N0d06dK9eMiN8eId
         oKjM/yJ/98ogh0z6BB0q6t720XfFkSCgnNG87Rq9f2nc/R9wPPBK8dO/EU7dkjZisR9m
         VDRwYv/+Fjzsb/ZL87m9NU9ZOwhBg0SWDbzVqhAiHqR+bl3sn1OUVFYUw2BVfIzO5lRa
         53N+I0VdzZVzF1AA0HGGqmh/uZDXqzguHsYdMnF06C77CEl9i3tfHbBq4HV4D56scn5Z
         Um2w==
X-Gm-Message-State: AGi0PubH7JX9/9lBP+22+LT8gZ2sw7ylsn27jff83FVhatBlpRty/00Z
        KZ05cs8XCd+cPHjOVhlYBM0fdQ0l1CUzpr8Zgzg=
X-Google-Smtp-Source: APiQypIGw+Uo04vrJIk/6ymlihcuQUMRs9FYS8HnwngrnrOwSaCM2SxMHpHnlobzxTtBAnMoIROEaEtYr7npH+7/PvQ=
X-Received: by 2002:a05:6602:199:: with SMTP id m25mr8464280ioo.13.1587732302623;
 Fri, 24 Apr 2020 05:45:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200423061629.24185-1-laoar.shao@gmail.com> <20200423153323.GA1318256@chrisdown.name>
 <CALOAHbDpvRZWcaoKBs2ywJFSY0MXT-WEe6wZTR=ed4-85Ovcgg@mail.gmail.com> <20200424121836.GA1379200@chrisdown.name>
In-Reply-To: <20200424121836.GA1379200@chrisdown.name>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Fri, 24 Apr 2020 20:44:26 +0800
Message-ID: <CALOAHbAPkB4ryfQ1Lof+5REyC6KAD+WCz+sZqPb9tK3iZs+xnQ@mail.gmail.com>
Subject: Re: [PATCH] mm, memcg: fix wrong mem cgroup protection
To:     Chris Down <chris@chrisdown.name>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Linux MM <linux-mm@kvack.org>, Roman Gushchin <guro@fb.com>,
        stable@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 24, 2020 at 8:18 PM Chris Down <chris@chrisdown.name> wrote:
>
> Yafang Shao writes:
> >If the author can't understand deeply in the code worte by
> >himself/herself, I think the author should do more test on his/her
> >patches.
> >Regarding the issue in this case, my understanding is you know the
> >benefit of proportional reclaim, but I'm wondering that do you know
> >the loss if the proportional is not correct ?
> >I don't mean to affend you, while I just try to explain how the
> >community should cooperate.
>
> I'm pretty sure that since multiple people on mm list have already expressed
> confusion at this patch, this isn't a question of testing, but of lack of
> clarity in usage :-)
>
> Promoting "testing" as a panacea for this issue misses a significant part of
> the real problem: that the intended semantics and room for allowed races is
> currently unclear, which is why there is a general sense of confusion around
> your proposed patch and what it solves. If more testing would help, then the
> benefit of your patch should be patently obvious -- but it isn't.

I have shown a testcase in my commit log.
Bellow is the result without my patch,

[  601.811428] vmscan: protection 1048576 memcg /foo target memcg /foo
[  601.811429] vmscan:
[  601.811429] vmscan: protection 1048576 memcg /foo target memcg /foo
[  601.811430] vmscan:
[  601.811430] vmscan: protection 1048576 memcg /foo target memcg /foo
[  601.811431] vmscan:
[  602.452791] vmscan: protection 1048576 memcg /foo target memcg /foo
[  602.452795] vmscan:
[  602.452796] vmscan: protection 1048576 memcg /foo target memcg /foo
[  602.452805] vmscan:
[  602.452805] vmscan: protection 1048576 memcg /foo target memcg /foo
[  602.452806] vmscan:
[  602.452807] vmscan: protection 1048576 memcg /foo target memcg /foo
[  602.452808] vmscan:


Here's patch to print the above info.

diff --git a/mm/vmscan.c b/mm/vmscan.c
index b06868fc4926..7525665d7cec 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2344,10 +2344,18 @@ static void get_scan_count(struct lruvec
*lruvec, struct scan_control *sc,
                unsigned long lruvec_size;
                unsigned long scan;
                unsigned long protection;
+               struct mem_cgroup *target = sc->target_mem_cgroup;

                lruvec_size = lruvec_lru_size(lruvec, lru, sc->reclaim_idx);
                protection = mem_cgroup_protection(memcg,
                                                   sc->memcg_low_reclaim);
+               if (memcg && memcg != root_mem_cgroup && target) {
+                       pr_info("protection %lu memcg ", protection);
+                       pr_cont_cgroup_path(memcg->css.cgroup);
+                       pr_cont(" target memcg ");
+                       pr_cont_cgroup_path(target->css.cgroup);
+                       pr_info("\n");
+               }

                if (protection) {


So my question is that do you think the protection in these log is okay ?
Can you answer me ?

Hint: what should protection be if memcg is the target memcg ?

-- 
Thanks
Yafang
