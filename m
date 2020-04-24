Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6A01B722D
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 12:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgDXKkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 06:40:45 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44865 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbgDXKkp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 06:40:45 -0400
Received: by mail-wr1-f65.google.com with SMTP id d17so10167170wrg.11
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 03:40:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6wACukIKb7o75IBFHY+ZsWVM/DZEQ0pO8PdBY9H3MtQ=;
        b=Ef3kMVNu9JdQ+urlRA5h3aLBVfwTKiRTElHYNtpIevr8jUxR400jpBrvgQpN/FwaF3
         3r/XUq44xNhFND5/7JL9KzAq3zPth3X4IWXmsrP414CBIBnTEX+m9oo5BT6dJ05dE07R
         BAnbtTBc43ekRh+GD7YSQUBs5p0awlGfOGdZJc5Hz65jNAifY1b1lu/TY7mbpXWiU/jO
         RBVD84PazVfgOy3nDJmot99UhopSxCEcEG0pRskAH+FRnS2prJk/BMthk3dql9TiV/kR
         ZzzBzmoL+oYNStq5ioyylt5BbkuLrUgR3+d/TSrRME0Hw13rJny4dq7ofCQU2FEOZtCH
         xgVg==
X-Gm-Message-State: AGi0PuZUYSJrI4uRPPpJ6y98LIHxGXWlazxRgtngIn51H8CJI6xqjbWz
        MQjeDaYaXSGPJhs3eFfgsCs=
X-Google-Smtp-Source: APiQypI4kH4zJOTmKM6Tbsn9Z6WkxZM4yrZ1fOQ7gK83yr2LBeErj5QxTvDHH/I6XrOkgloNtjBlJg==
X-Received: by 2002:a5d:6b85:: with SMTP id n5mr10504100wrx.370.1587724843192;
        Fri, 24 Apr 2020 03:40:43 -0700 (PDT)
Received: from localhost (ip-37-188-130-62.eurotel.cz. [37.188.130.62])
        by smtp.gmail.com with ESMTPSA id w11sm2208829wmi.32.2020.04.24.03.40.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 03:40:42 -0700 (PDT)
Date:   Fri, 24 Apr 2020 12:40:41 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Roman Gushchin <guro@fb.com>
Cc:     Chris Down <chris@chrisdown.name>,
        Yafang Shao <laoar.shao@gmail.com>, akpm@linux-foundation.org,
        vdavydov.dev@gmail.com, linux-mm@kvack.org, stable@vger.kernel.org,
        hannes@cmpxchg.org
Subject: Re: [PATCH] mm, memcg: fix wrong mem cgroup protection
Message-ID: <20200424104041.GE11591@dhcp22.suse.cz>
References: <20200423061629.24185-1-laoar.shao@gmail.com>
 <20200423153323.GA1318256@chrisdown.name>
 <20200423211319.GC83398@carbon.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423211319.GC83398@carbon.DHCP.thefacebook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 23-04-20 14:13:19, Roman Gushchin wrote:
> On Thu, Apr 23, 2020 at 04:33:23PM +0100, Chris Down wrote:
> > Hi Yafang,
> > 
> > I'm afraid I'm just as confused as Michal was about the intent of this patch.
> > 
> > Can you please be more concise and clear about the practical ramifications
> > and demonstrate some pathological behaviour? I really can't visualise what's
> > wrong here from your explanation, and if I can't understand it as the person
> > who wrote this code, I am not surprised others are also confused :-)
> > 
> > Or maybe Roman can try to explain, since he acked the previous patch? At
> > least to me, the emin/elow behaviour seems fairly non-trivial to reason
> > about right now.
> 
> Hi Chris!
> 
> So the thing is that emin/elow cached values are shared between global and
> targeted (caused by memory.max) reclaim. It's racy by design, but in general
> it should work ok, because in the end we'll reclaim or not approximately
> the same amount of memory.
> 
> In the case which Yafang described, the emin value calculated in the process
> of the global reclaim leads to a slowdown of the targeted reclaim. It's not
> a tragedy, but not perfect too. It seems that the proposed patch makes it better,
> and as now I don't see any bad consequences.

Do we have any means to quantify the effect?

I do understand the racy nature of the effective protection values. We
do update them in mem_cgroup_protected and that handles the
reclaim_target == memcg case already. So why do we care later on in
mem_cgroup_protection? And why don't we care about any other concurrent
reclaimers which have a different reclaim memcg target? This just
doesn't make any sense.

Either we do care about races because they are harmful and then we care
for all possible case or we don't and this patch doesn't really any big
value. Or I still miss the point.

-- 
Michal Hocko
SUSE Labs
