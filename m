Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D4D402D95
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 19:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345605AbhIGRUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 13:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345688AbhIGRUP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 13:20:15 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9237C061575;
        Tue,  7 Sep 2021 10:19:07 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id y17so8670739pfl.13;
        Tue, 07 Sep 2021 10:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FjhWJM3JAcxJyWXW2pwc/fGwqLigw+FDFXMEyVU7A5A=;
        b=FZEOnQYIH4IFKS0zgfI8NJI7grFEyCvnUTWh0L6GR5t4Qzyg4C2zbDD+bfVKF2g1sn
         LPDXOQBb/2DbZqJ1QAfegV0z7SNUyCWA5t7/6PlwrI3CHK1MRE2Fuslxeg7GktznHPKP
         aOjvFt7QqZdYO6+bqOCDdVhASStXJbDQLCdVQZG6WzZLy4aYLd9KcT3uKjw0IayV2JE5
         SqXrgGTVqU/B+4rUtpGJPxLaUvSsSnavCYQb0Z45OlGPYRpTUeeJPojTf7e0cD14Le2t
         Q2lalSHIn6WmCwVXFkCMwWlWF9RCecqVS/23XM4qVFWUmIgg9nvyPKt3dTFLZP5Y7yQr
         16EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=FjhWJM3JAcxJyWXW2pwc/fGwqLigw+FDFXMEyVU7A5A=;
        b=oqJxeFzV4IgWmje+zdUhtAdtuX3Gvsmexm84sebF+hJQjhfbeUkiTSG+9B5CIO0Y4X
         NPW3UlC0EqiswdY1oANsP/OjCyZesrsT/gG0oam49r3K9gZ/RTkK1LHfNePUUynZgyNU
         exyp5qx/FZdCQ6Rme4DQ3n/RUBaABBpqge9dzTXlBcaGVA0WpIm8zdY99ZTUBZ1bGYLO
         rSM/JniotQrea2WJEjTx6/eDApqzdHkRRXyy15qHAAm8ay8vRhL1U3yXASBrkEBqpESR
         PN26+I4j4a7M6afc+j/li25bR34emelB7MJKH33dybaERv04iK7DaguKBIwjQRjbQwn0
         f51A==
X-Gm-Message-State: AOAM531W2DuWGJqC111EjS873bGx6vh481lQPCCneOgwpL55TzqLU6K4
        XDUeWQVnIzAqPqDLR6d5eIo=
X-Google-Smtp-Source: ABdhPJz1SeEcczEmswkEIWrD7qBVuoj9C5afyOSXtc3LHmZSPtfHHerjVmUuRY411ca3np0luekZjw==
X-Received: by 2002:a63:e04a:: with SMTP id n10mr17628021pgj.381.1631035147041;
        Tue, 07 Sep 2021 10:19:07 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-e24f-43ff-fee6-449f.res6.spectrum.com. [2603:800c:1a02:1bae:e24f:43ff:fee6:449f])
        by smtp.gmail.com with ESMTPSA id l23sm3121914pji.45.2021.09.07.10.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 10:19:06 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Tue, 7 Sep 2021 07:19:05 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Andrey Ryabinin <arbn@yandex-team.com>
Cc:     Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        bharata@linux.vnet.ibm.com, boris@bur.io, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/5] cputime, cpuacct: Include guest time in user time
 in cpuacct.stat
Message-ID: <YTefCTq1KyRxYlxr@slm.duckdns.org>
References: <20210217120004.7984-1-arbn@yandex-team.com>
 <20210820094005.20596-1-arbn@yandex-team.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210820094005.20596-1-arbn@yandex-team.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 20, 2021 at 12:40:01PM +0300, Andrey Ryabinin wrote:
> cpuacct.stat in no-root cgroups shows user time without guest time
> included int it. This doesn't match with user time shown in root
> cpuacct.stat and /proc/<pid>/stat. This also affects cgroup2's cpu.stat
> in the same way.
> 
> Make account_guest_time() to add user time to cgroup's cpustat to
> fix this.
> 
> Fixes: ef12fefabf94 ("cpuacct: add per-cgroup utime/stime statistics")
> Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
> Cc: <stable@vger.kernel.org>

The fact that this has been broken for so long, prolly from the beginning,
gives me some pause but the patches looks fine to me.

For the series,

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
