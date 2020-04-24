Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93FC71B6A7F
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 02:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgDXAuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 20:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728156AbgDXAuP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 20:50:15 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D84C09B042
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 17:50:15 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id q10so7719716ile.0
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 17:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DH+1wZRFcAGugGUmHt8yA2LS6AHEpgK1G4ZlJe1XPRQ=;
        b=VMXQGgTx7+K/Em1P83QYLS414PnUEe61KtkU2fgIvtDkyZWw/7tzsAUOYZD4+rJUlp
         jL9BSfo5L4JSkP10d4OQi1NbJAqFDVUEwe7cWxwGZb0CVUYvSIyIvewXQv9KLHPfuLDp
         g8V8kMgbXhVqhdzCKx7HWgUJWjinSKqvQpAcGJt1rV7ZKzMJf0tzSc6Z/2mR6XlUE7Cz
         ICff4Aqp7sYHi0XPhlV7fhzkfSii9mHlssTn7KVHOJpX4E9oTSmRsBP72SoSDoPMEVRM
         Ft9TybbLUpUyJk8mopOeYOo1a/9o6/pgRnLSjC8On3I3M0v+n4K0OV7y7oOQ2X35EBi3
         M5Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DH+1wZRFcAGugGUmHt8yA2LS6AHEpgK1G4ZlJe1XPRQ=;
        b=hSUh/KzZi31st0bDry988l9MEmRPG6+pVmgiqUgsFEcPxaWtontp4l0EvPk25WzG1S
         zM1mVI0cgC32Omg1i1jBcO5/oZS8SHq6zyaFC3N+UbL58O4S2WArwKHAqA8xaNWKmuwk
         BI4d8zTLnX199TPPJYmn2YipHxQsYHFfx2s1QsfFkGJO57o/syKFozAMvpAXHZgQ1ah2
         xenetXJX8P53zrFi8HlcUkV4c4G5zfpW/LG21CyZ1hE2SCMnb6tCFocmjlaOy2VZbi1T
         FgYc1ymxUFj0BQlY0eIxZesxrsxhPsMlWDpFIMCqkU8gWATz7L6PCENle2Ty87gXpXsN
         0L+A==
X-Gm-Message-State: AGi0PuY7UVdPTYZj3hYJUnLjMOmaoXqYirYQZOnrxOcujKvUZ1nfHmbX
        2t8oWHB67agY9SZ/K+PeR6MZOxu7cN2ZRS4DFOI=
X-Google-Smtp-Source: APiQypKIgHCGiEpeXA+KLO8dYsM6xOSLsa/ChQtYmxiRH78xTuvjsRNT4OP9jLukE2QcPVu7dTZZF1hxiQpHD3EKJJU=
X-Received: by 2002:a92:5c57:: with SMTP id q84mr6354958ilb.203.1587689415194;
 Thu, 23 Apr 2020 17:50:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200423061629.24185-1-laoar.shao@gmail.com> <20200423153323.GA1318256@chrisdown.name>
In-Reply-To: <20200423153323.GA1318256@chrisdown.name>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Fri, 24 Apr 2020 08:49:39 +0800
Message-ID: <CALOAHbDpvRZWcaoKBs2ywJFSY0MXT-WEe6wZTR=ed4-85Ovcgg@mail.gmail.com>
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

On Thu, Apr 23, 2020 at 11:33 PM Chris Down <chris@chrisdown.name> wrote:
>
> Hi Yafang,
>
> I'm afraid I'm just as confused as Michal was about the intent of this patch.
>
> Can you please be more concise and clear about the practical ramifications and
> demonstrate some pathological behaviour? I really can't visualise what's wrong
> here from your explanation, and if I can't understand it as the person who
> wrote this code, I am not surprised others are also confused :-)
>

Hi Chris,

If the author can't understand deeply in the code worte by
himself/herself, I think the author should do more test on his/her
patches.
Regarding the issue in this case, my understanding is you know the
benefit of proportional reclaim, but I'm wondering that do you know
the loss if the proportional is not correct ?
I don't mean to affend you, while I just try to explain how the
community should cooperate.

> Or maybe Roman can try to explain, since he acked the previous patch? At least
> to me, the emin/elow behaviour seems fairly non-trivial to reason about right
> now.
>

-- 
Thanks
Yafang
