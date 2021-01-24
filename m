Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F71301E07
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 19:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725918AbhAXSCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 13:02:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbhAXSCp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jan 2021 13:02:45 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9F6C061573
        for <stable@vger.kernel.org>; Sun, 24 Jan 2021 10:02:04 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id v24so14546389lfr.7
        for <stable@vger.kernel.org>; Sun, 24 Jan 2021 10:02:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qhc7cnz0RKFXOf698IrJkfakceVLloqd5WmltfYsgto=;
        b=ZC2/TGkDAYL98/DPFpoGdIc7/hZCRHLxArcJi5wFjJoAPBnlzdizpyFoz+c3Sl8x4F
         NT6pR18r4pfdOGhZZoJ2rkz25i+QptDZaPtUt8kYuKTgsKfbKZPAIcCippOJJiErqq8n
         386umxMzxipEa0drs+PoarwmbHL7Da9zCu7GEVHLfj9VytPDwsYKWkG9ukZTXIOVxLPl
         1TAcp9r7QMMhYO0LB96sDSSQMG3oEOXaL+rpUjAoeSKf9Q5rqw7msEpiCkDB+2OIU7M9
         xdx4j/Et7XG4Og4iAH/5+bDuvYphX1VHjcnMbL6/FVGTyGcNMBYCh55qpZ8aAhKi77xK
         DREw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qhc7cnz0RKFXOf698IrJkfakceVLloqd5WmltfYsgto=;
        b=S+0t1EA/1TYtSi6Waso4WU8gkWfehcGUHkDfNZM3Ok99IOOzrlhqgHuotrEcjjSp1w
         87S2Clr/KXFEOl5lG+nIH9nTZgFfl2ceCUOVLowfcvtpVdX3wwhsGoYHBx8F1cJJZSKt
         W/TpE3Bhbe/SAknF5yG8N7DnbxWqjLXyFz4PJBHYZP5FMcCO2Q8FEqELPBXY1XQQguQv
         518NDBwC0yv6aOFm/lUqjJYOLxz0zG3juSB9kFz/hZZIXB+YxqAypHKgC2YetUOyhWzP
         HisnamiXaCC21ssgjB09IU3XKlvHPmJib05wuiRR2WIzk0brbC4a1kL2+j7W0iWIRcqh
         jI6w==
X-Gm-Message-State: AOAM5314pZVGsjLGsMHkww3bTS9GDZUFfL+ugQk/RPOrh8JrlV6J3DWA
        C0iuJs6QfSnPzlWy9DTrizHvAVl22+Ligf8aTHOeCg==
X-Google-Smtp-Source: ABdhPJxu5eVM/lKokhkCxod5AjChPP5/rCoA3Q4eaevWLtFpplMXPwX8bkxls7c8I5NQJ3UMRT6dol7p1SIoFmtYKv8=
X-Received: by 2002:a19:644b:: with SMTP id b11mr610105lfj.358.1611511322517;
 Sun, 24 Jan 2021 10:02:02 -0800 (PST)
MIME-Version: 1.0
References: <20210123210029.a7c704d0cab204683e41ad10@linux-foundation.org> <20210124050119.34lm1Gw1Q%akpm@linux-foundation.org>
In-Reply-To: <20210124050119.34lm1Gw1Q%akpm@linux-foundation.org>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Sun, 24 Jan 2021 10:01:51 -0800
Message-ID: <CALvZod7vf=NF40xSFqtugaZUaVx7X75LS10dpF6Q8LR=R=JhDA@mail.gmail.com>
Subject: Re: [patch 06/19] mm: memcontrol: prevent starvation when writing memory.high
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Linux MM <linux-mm@kvack.org>, Michal Hocko <mhocko@suse.com>,
        =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 23, 2021 at 9:01 PM Andrew Morton <akpm@linux-foundation.org> w=
rote:
>
> From: Johannes Weiner <hannes@cmpxchg.org>
> Subject: mm: memcontrol: prevent starvation when writing memory.high
>
> When a value is written to a cgroup's memory.high control file, the
> write() context first tries to reclaim the cgroup to size before putting
> the limit in place for the workload.  Concurrent charges from the workloa=
d
> can keep such a write() looping in reclaim indefinitely.
>
> In the past, a write to memory.high would first put the limit in place fo=
r
> the workload, then do targeted reclaim until the new limit has been met -
> similar to how we do it for memory.max.  This wasn't prone to the
> described starvation issue.  However, this sequence could cause excessive
> latencies in the workload, when allocating threads could be put into long
> penalty sleeps on the sudden memory.high overage created by the write(),
> before that had a chance to work it off.
>
> Now that memory_high_write() performs reclaim before enforcing the new
> limit, reflect that the cgroup may well fail to converge due to concurren=
t
> workload activity.  Bail out of the loop after a few tries.
>
> Link: https://lkml.kernel.org/r/20210112163011.127833-1-hannes@cmpxchg.or=
g
> Fixes: 536d3bf261a2 ("mm: memcontrol: avoid workload stalls when lowering=
 memory.high")
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Shakeel Butt <shakeelb@google.com>
> Reported-by: Tejun Heo <tj@kernel.org>
> Acked-by: Roman Gushchin <guro@fb.com>
> Reviewed-by: Michal Koutn=C3=BD <mkoutny@suse.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: <stable@vger.kernel.org>    [5.8+]
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Johannes requested to replace this patch with
https://lore.kernel.org/linux-mm/20210122184341.292461-1-hannes@cmpxchg.org=
/
