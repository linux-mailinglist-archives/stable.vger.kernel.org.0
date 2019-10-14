Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A490D646F
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 15:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732332AbfJNNxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 09:53:02 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54720 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732220AbfJNNxC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 09:53:02 -0400
Received: by mail-wm1-f68.google.com with SMTP id p7so17387384wmp.4
        for <stable@vger.kernel.org>; Mon, 14 Oct 2019 06:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DbMU9RPCntfZSoUp0kmD7kMs8Ccruo+x2SMQzLE6AvM=;
        b=JIVsIOWBuLmB3PaIM7QP1ZcewvV3mVfo7Ya+I0XajhKTSF8oG7+VZseicRzsAOzDy6
         gCP7WjIYmufUr8Et3/y8mQ41bQIpb47kx9otlxu2lmhaHk77QUT7X7xStQKHJi0cKXs3
         SmfCixBJA9p5WqJ47RRm7pNoCEB0gMUoej70mB6R7I0JxM+FUBtE24V73B2mXnHwM/zx
         26P2bu2BIFPRPVNlUjUWEzZXaB8WfqG7n0H3gUVFBamhVYsTifhLIqFGWER3/Svys4SG
         M3ujx9R0v9awUzUop55GNEUBjoTtNcaVzpO0S/SHD45VxpUwiflzSaiq1keFejFNZbm5
         8WXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DbMU9RPCntfZSoUp0kmD7kMs8Ccruo+x2SMQzLE6AvM=;
        b=Gb2kRMn1eqnZL2eLTM2/cgG5iILhl2M5z8yD5MPy2fQZb9buyGxopr71Mig7Nrda88
         MaP07nv/BZdNVPbk0oGh3LFplmThbA2v6sO/7ghMUzmZtTxkpHXP/3Cs849jL0EfQjNt
         w9yrnaRbY530uAnyC0cYqimOU7SjU6knLBlIr+NwG4oKQ6yI+sZQYZUVKi0Tdu/0gAbT
         ZrNCr56k4Mglp0BSS1GdXFc4bL5bvsayuu7unUD7sERwyE+83jW2QBvAoiGS5utXumn1
         7MZoShSqSK5NdOXkL2h3D8/xFxbh/N7FxSIxuON88aZQFx+ugab5iWiJWu07LQNjupJ8
         eLvg==
X-Gm-Message-State: APjAAAUhMQvPWHDm+8KdATbMo4/uRMAE7/fOpocd555Fw8uWNwFWrW6a
        /oYlbw6OjeIF6dt+evAUZKJsvjcQNEk=
X-Google-Smtp-Source: APXvYqyXOLvjYOs2m47oj9Ddg1YMyBiA/mG9zoRtk3XJWMw7YIOTI4YF86fWND1xRqTPtoEnkcJL5g==
X-Received: by 2002:a7b:c7d3:: with SMTP id z19mr11649644wmk.83.1571061180187;
        Mon, 14 Oct 2019 06:53:00 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:7687:11a4:4657:121d])
        by smtp.gmail.com with ESMTPSA id y186sm36262088wmb.41.2019.10.14.06.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 06:52:59 -0700 (PDT)
Date:   Mon, 14 Oct 2019 14:52:56 +0100
From:   Quentin Perret <qperret@google.com>
To:     Valentin Schneider <valentin.schneider@arm.com>
Cc:     Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Quentin Perret <qperret@qperret.net>,
        "# v4 . 16+" <stable@vger.kernel.org>
Subject: Re: [PATCH] sched/topology: Disable sched_asym_cpucapacity on domain
 destruction
Message-ID: <20191014135256.GA85340@google.com>
References: <20191014114710.22142-1-valentin.schneider@arm.com>
 <20191014121648.GA53234@google.com>
 <CAKfTPtDoBrE=npY_Ay1pucdXsW1yQr1UiaCGq1DXKa2VmNqcUg@mail.gmail.com>
 <fe5977ab-0a70-e705-fcca-246c7dc3d23f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe5977ab-0a70-e705-fcca-246c7dc3d23f@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Monday 14 Oct 2019 at 14:46:58 (+0100), Valentin Schneider wrote:
> (Replying to the reply because for some reason my mail client never got
> your reply?!)
> 
> On 14/10/2019 14:29, Vincent Guittot wrote:
> > On Mon, 14 Oct 2019 at 14:16, Quentin Perret <qperret@google.com> wrote:
> >> FWIW we already clear the EAS static key properly (based on the sd
> >> pointer, not the static key), so this is really only for the
> >> capacity-aware stuff.
> >>
> 
> Ah, right.
> 
> >> So what happens it you have mutiple root domains ? You might skip
> >> build_sched_domains() for one of them and end up not setting the static
> >> key when you should no ?
> >>
> >> I suppose an alternative would be to play with static_branch_inc() /
> >> static_branch_dec() from build_sched_domains() or something along those
> >> lines.
> >>
> 
> Hmph, so I went with the concept that having the key set should mandate
> having a non-NULL sd_asym_cpucapacity domain, which is why I unset it as
> soon as one CPU gets attached to a NULL domain.
> 
> Sadly as you pointed out, this doesn't work if we have another root domain
> that sees asymmetry. It also kinda sounds broken to have SDs of a root
> domain that does not see asymmetry (e.g. LITTLEs only) to see that key 
> being set. Maybe what we want is to have a key per root domain?

Right, but that's not possible by definition -- static keys aren't
variables. The static keys for asym CPUs and for EAS are just to
optimize the case when they're disabled, but when they _are_ enabled,
you have no choice but do another per-rd check.

And to clarify what I tried to say before, it might be possible to
'count' the number of RDs that have SD_ASYM_CPUCAPACITY set using
static_branch_inc()/dec(), like we do for the SMT static key. I remember
trying to do something like that for EAS, but that was easier said than
done ... :)

Thanks,
Quentin
