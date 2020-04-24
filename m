Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEAE91B6A57
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 02:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbgDXAdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 20:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728151AbgDXAdG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 20:33:06 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B82BC09B042
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 17:33:06 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id w20so8592314iob.2
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 17:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dfjeF+d7f9NchHXEWqAz4f/HnH49yqOC4MhXcsnjPaM=;
        b=OfncXb0O4cVD0cZpQ4jDkPy305BpN2r2P6z9LeO3OvDhYXxKOFHMOU8Pj6qbqSzS14
         C40RGwJqenIsNVE/ovN9M7/H6gFqi0mAW3QFYy9HITeS15eCFysYg+bAuQsFdSDsK27f
         4j+FVPc8VEU3Yg+AINVLc0oQOaI7dK0ITdVXeUcdJ9XwQjae+keWlGG78BHWuiLeCXA1
         NZUJq0on5szHmu8ieY+iiuAg+R+N1SEP8MkqHGbG7BsCnnXiAoKQuV7P0M9FL/GO22kf
         FXzn784qCA8uzVvHmOSnuoce4fvVutaayvlJ9ZgcxMSF5QxZr+fJ1GDkbPsgI6z32pt5
         e6xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dfjeF+d7f9NchHXEWqAz4f/HnH49yqOC4MhXcsnjPaM=;
        b=tseu5ixwluFXZUz0r3MmaWHnoFPAhZMoGxYx+mcpyT3gxEBg1yEwRUK+ELND/XytTd
         lnjGgh9/dR7kg8UPbyAq62JAdafZu1kfyCgWY99vo1OjXy5FIR7HXoto+2eFc8ashuIU
         PWmUnwmhqFn605tBMohsLdqZNzQ4yb1ZOTKFc+oMbRTl1I7fON4raBLjgBlTcJrbVOGT
         nz6cAQnH3Z3rtZUZsAS21xSx/KEkd2p1yh7MFYu8RGDvTB9yD4OXB0WhrWyiYKURqk2A
         5ojFyq3uwmKfybjXzj93sb4Rpf9Y0gd4U9YTD3roz5wxUffLgAFAEUVyJvUPpeSdtUs1
         G1Bg==
X-Gm-Message-State: AGi0PuagvLblh3pTL1dZIQbq2+PiffS8fUg2ctvN8wwAR5McYkcDtn8f
        XjnYznLer/BRU0Tgf42XMt0a7n0szoozw5ANLLBWpO8o
X-Google-Smtp-Source: APiQypLfDBonSXxsZaHM7ln0qSrbXJaSzoysFHIIsK2n0TzON7ibPIEEzZVTXUFpiXq29OXiIaOGzMX2BjgxE+A9n+A=
X-Received: by 2002:a5d:9042:: with SMTP id v2mr6150729ioq.81.1587688385872;
 Thu, 23 Apr 2020 17:33:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200423061629.24185-1-laoar.shao@gmail.com> <20200423153323.GA1318256@chrisdown.name>
 <20200423211319.GC83398@carbon.DHCP.thefacebook.com>
In-Reply-To: <20200423211319.GC83398@carbon.DHCP.thefacebook.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Fri, 24 Apr 2020 08:32:29 +0800
Message-ID: <CALOAHbDEASiELSEOshgeuKBQzEv6Cyj+UO6MsRoMtAqM_Y43ng@mail.gmail.com>
Subject: Re: [PATCH] mm, memcg: fix wrong mem cgroup protection
To:     Roman Gushchin <guro@fb.com>
Cc:     Chris Down <chris@chrisdown.name>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Linux MM <linux-mm@kvack.org>, stable@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 24, 2020 at 5:13 AM Roman Gushchin <guro@fb.com> wrote:
>
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
>

Thanks for your explanation. Your explanation make the issue more clear.
If you don't mind, I will copy some of your comments to improve the commit log.



-- 
Thanks
Yafang
