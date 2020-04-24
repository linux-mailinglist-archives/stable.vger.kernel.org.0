Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8DB1B769F
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 15:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgDXNLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 09:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728246AbgDXNL1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 09:11:27 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4503C09B046
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 06:11:26 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id q10so9204264ile.0
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 06:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kpgZoqrV7vV3TcMiu1TtDaIjMxaQ7eQG0RjdnsGxrLg=;
        b=KcKIbzi3DLHmkbSolHBgFeOo113vE9fQVC/EzBfY08JbS017GrQPRK4m8ZpkqGeFf/
         5wtLajB5q+dZsXiSKClvBOQI/9Vw/NPyHyzarIC4CygYXBpNv5Ig+g48bnx74K7c3gWJ
         5NGp0TXdl+FCncDQ0a+dhr6QOBIsao+gVbxNqGoA1YcYVV/8hCgG7m8Xxb5wZS7Syk94
         EK5iGRfRCZLjZFtPmwaZfi5aPO6Vt2RvTXbistEV85IHiVMfIC27iULZk9/2uWPvcNWe
         SG/BAJYq27ZhfAnsTzM57weaaWGXyf/OaxZiTxb+dE5Z3aC8InfIEuIV5igzGh7rKS23
         0c9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kpgZoqrV7vV3TcMiu1TtDaIjMxaQ7eQG0RjdnsGxrLg=;
        b=uBFmW2LfbSNfYMMr3ln5S1zTA/APc+292+SK1TPNle27EwGJYTbvZJAyMxgR2/mcpp
         waSUoP2s72p1gPUarvgWNl8jGjLK8OCqkUGnRjJY3lwp6SV10PmakOWUGK/78ggRumb7
         SLln4Yku87av2PqMymn2OxlKSt8utFbuVwUOFpuqxSwA1AV471YLZJZeaGs9k/iwa6Xb
         f/vORGkCBEJ6iL/G8psymYGUeHRUciu07ZNuDlJIWFEXVfaoEez4tdT9PpQgcGQcmcSM
         Rggz3TT2ICSkI8kW+kHFVqy9w2PBv3oX6idt+aJNqXlR1mA3/8xAGQKl80WCvGGp4h+r
         H7yA==
X-Gm-Message-State: AGi0PuZrUHFnrrvSRDVk6k1VDf07iGissiZliWDeJzoT2xoy/6gSHvLm
        wonm+HvRnadpOkmukrARCwV/AZFyoNyUFMWnYSc=
X-Google-Smtp-Source: APiQypLMFAmObUQ+ZN1CjLt8QbT7uwZUxYjZFYt2fNzbpkpPFmN2Ma1yprLb0ksa/qMOazDSNK5FPdpjZ3KRZggvyJA=
X-Received: by 2002:a92:c004:: with SMTP id q4mr8154017ild.93.1587733886020;
 Fri, 24 Apr 2020 06:11:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200423061629.24185-1-laoar.shao@gmail.com> <20200423153323.GA1318256@chrisdown.name>
 <CALOAHbDpvRZWcaoKBs2ywJFSY0MXT-WEe6wZTR=ed4-85Ovcgg@mail.gmail.com>
 <20200424121836.GA1379200@chrisdown.name> <CALOAHbAPkB4ryfQ1Lof+5REyC6KAD+WCz+sZqPb9tK3iZs+xnQ@mail.gmail.com>
 <20200424130554.GA1462690@chrisdown.name>
In-Reply-To: <20200424130554.GA1462690@chrisdown.name>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Fri, 24 Apr 2020 21:10:49 +0800
Message-ID: <CALOAHbB5WDEAH_eRmmTD6FPiqHkEc96CezLevr-zMtV08EnhLw@mail.gmail.com>
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

On Fri, Apr 24, 2020 at 9:05 PM Chris Down <chris@chrisdown.name> wrote:
>
> I'm not debating whether your test case is correct or not, or whether the
> numbers are correct or not. The point is that 3 out of 4 people from mm list
> who have looked at this patch have no idea what it's trying to do, why it's
> important, or why these numbers *should* necessarily be wrong.
>
> It's good that you have provided a way to demonstrate the effects of your
> changes, but one can't solve cognitive gaps with testing. If one could, then
> things like TDD would be effective on complex projects -- but they aren't[0].
>
> We're really getting off in the weeds here, though. I just want to make it
> clear to you that if you think "more testing" is a solution to kernel ailments
> like this, you're going to be disappointed.
>
> 0: http://people.brunel.ac.uk/~csstmms/FucciEtAl_ESEM2016.pdf


Hi  Chris,

Pls. answer my question directly - what should protection be if memcg
is the target memcg ?
If you can't answer my quesiont, I suggest to revist your patch.

-- 
Thanks
Yafang
