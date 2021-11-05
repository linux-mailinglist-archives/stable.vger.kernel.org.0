Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523FD44671B
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 17:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbhKEQkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 12:40:24 -0400
Received: from mail-oo1-f41.google.com ([209.85.161.41]:36746 "EHLO
        mail-oo1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233382AbhKEQkY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 12:40:24 -0400
Received: by mail-oo1-f41.google.com with SMTP id t7-20020a4aadc7000000b002b8733ab498so3210118oon.3;
        Fri, 05 Nov 2021 09:37:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P1Gp0/MAdFAvXBeRj35bImIZhx/EFHupa8h4iwZFEeg=;
        b=WNo4yOW/fr/VGFaAidZB97Q23JxqT7NeepXrOaVTku/HvdmPrMiaOmLTdZxDJotuib
         VPbrpWGa4ty44MmyRPL3hxCCqyO+ZNKGVLcVOih06WdGHB3k2mFvruiftY7dKtclarjo
         fpzIZKDf9UU37J/oHtZ7KpR9ZbxK3r/C85UZzLSpmm4bclOE2dy3ABQMjl28tdqAPXY0
         9DXiOezPsLlGDPYIyJkgX0/dlTR7c22Sp4ngZClY4/vX2YGhj9InyyQ8/o+Ygrjd+Hh0
         itDowhTH0zaUC77qSSTjSN6WVs72j7gVvrX1TbYCUZ44FwP3jv6DovCd/TSol2VGuyst
         Yeuw==
X-Gm-Message-State: AOAM53378VE8s8aP3cFUYFKWYyrk79zfQ13jpCjLHgvhzFPnMCeXnlx1
        zFymDF7/14NdMNC2AYusCI88KcqtImcP9oSpzKQ=
X-Google-Smtp-Source: ABdhPJwJDsvykL3wZ8MVMKzW4SKFSt5yr4+mf5kAd6MjF5Yui+IbB1w0qgns3f1hdjUwgp+W/rrt+pGwrnXgL1KJiA0=
X-Received: by 2002:a4a:e544:: with SMTP id s4mr9557867oot.0.1636130264293;
 Fri, 05 Nov 2021 09:37:44 -0700 (PDT)
MIME-Version: 1.0
References: <1636070227-15909-1-git-send-email-quic_subbaram@quicinc.com>
 <CAJZ5v0gONybD_pVCAq6ZJTMuStXtoF064u9qPYxco4y=b-JD9A@mail.gmail.com> <c7ede029-b75f-e57e-24f1-9633d5d47401@linaro.org>
In-Reply-To: <c7ede029-b75f-e57e-24f1-9633d5d47401@linaro.org>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 5 Nov 2021 17:37:33 +0100
Message-ID: <CAJZ5v0j1TDe0ZiBg_ju-JDuCsBDb_exueRDUwCcJ6VD_=fbzjg@mail.gmail.com>
Subject: Re: [RESEND PATCH v2] thermal: Fix a NULL pointer dereference
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Collins <quic_collinsd@quicinc.com>,
        Manaf Meethalavalappu Pallikunhi <quic_manafm@quicinc.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 5, 2021 at 5:19 PM Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
>
> On 05/11/2021 16:14, Rafael J. Wysocki wrote:
> > On Fri, Nov 5, 2021 at 12:57 AM Subbaraman Narayanamurthy
> > <quic_subbaram@quicinc.com> wrote:
> >>
> >> of_parse_thermal_zones() parses the thermal-zones node and registers a
> >> thermal_zone device for each subnode. However, if a thermal zone is
> >> consuming a thermal sensor and that thermal sensor device hasn't probed
> >> yet, an attempt to set trip_point_*_temp for that thermal zone device
> >> can cause a NULL pointer dereference. Fix it.
> >>
> >>  console:/sys/class/thermal/thermal_zone87 # echo 120000 > trip_point_0_temp
> >>  ...
> >>  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020
> >>  ...
> >>  Call trace:
> >>   of_thermal_set_trip_temp+0x40/0xc4
> >>   trip_point_temp_store+0xc0/0x1dc
> >>   dev_attr_store+0x38/0x88
> >>   sysfs_kf_write+0x64/0xc0
> >>   kernfs_fop_write_iter+0x108/0x1d0
> >>   vfs_write+0x2f4/0x368
> >>   ksys_write+0x7c/0xec
> >>   __arm64_sys_write+0x20/0x30
> >>   el0_svc_common.llvm.7279915941325364641+0xbc/0x1bc
> >>   do_el0_svc+0x28/0xa0
> >>   el0_svc+0x14/0x24
> >>   el0_sync_handler+0x88/0xec
> >>   el0_sync+0x1c0/0x200
> >>
> >> While at it, fix the possible NULL pointer dereference in other
> >> functions as well: of_thermal_get_temp(), of_thermal_set_emul_temp(),
> >> of_thermal_get_trend().
> >
> > Can the subject be more specific, please?
> >
> > The issue appears to be limited to the of_thermal_ family of
> > functions, but the subject doesn't reflect that at all.
> >
> >> Suggested-by: David Collins <quic_collinsd@quicinc.com>
> >> Signed-off-by: Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>
> >
> > Daniel, any concerns regarding the code changes below?
>
> I've a concern about the root cause but I did not have time to
> investigate how to fix it nicely.
>
> thermal_of is responsible of introducing itself between the thermal core
> code and the backend. So it defines the ops which in turn call the
> sensor ops leading us to this problem.
>
> So, without a better solution, this fix can be applied until we rethink
> the thermal_of approach.
>
> Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

Thanks!

I've queued it up for 5.16-rc as "thermal: Fix NULL pointer
dereferences in of_thermal_ functions".
