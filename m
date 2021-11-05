Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1F444698B
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 21:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbhKEUWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 16:22:45 -0400
Received: from mail-oo1-f43.google.com ([209.85.161.43]:42853 "EHLO
        mail-oo1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbhKEUWp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 16:22:45 -0400
Received: by mail-oo1-f43.google.com with SMTP id a17-20020a4a6851000000b002b59bfbf669so3386209oof.9;
        Fri, 05 Nov 2021 13:20:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7MPKTdHQno9jBif76suur5pudLPh3OWTJgqggfvLu34=;
        b=H5t3W2R+QO6wkKZaa/pR8QlZwA2sNdZ7XW+CO/I8j5Rwu2CyYugy/w3Ke9UWYmHbj0
         /hTCrpHxETVNfpxCXP74IXxV8yOVK1ZiVOjOMRvIsjZHmmsUyPoy7Rp4ZQSivj8n3hvc
         AIC0Kie51lQ5Ms55KueTxozYMc0fClGyKX5uZDy2d4D6PPECh9x5bXV8+3aI4PGQijQA
         BdLPM/1cm8JMIafd51usDPncVVLjpmkRY1CNYdrOAV2kioSmZqEByC461b2RDMttVtoK
         Lf/WMKwC4FqFCALKloIhScyCRvznEk44WdUsCpqWMrJBCHxeb0gsTq7rpfJDJX1viXrE
         dt+Q==
X-Gm-Message-State: AOAM531aauC/IfmyrfgOcrbqmvavWWhZsufixwClk1YrHqVvfHmZL7r4
        LVvMwcbQxMByB3ByJdv6cbE3T1+5rEJdWLea3GU=
X-Google-Smtp-Source: ABdhPJzEjUNBJy+QF4alCNwY7iLrMoJolwPu/ujQMI4VKhzkDlx+PegEdT0GgVqoeDpNCKm3/i5mYGPBhtqm58nmLFo=
X-Received: by 2002:a4a:e544:: with SMTP id s4mr10428042oot.0.1636143602756;
 Fri, 05 Nov 2021 13:20:02 -0700 (PDT)
MIME-Version: 1.0
References: <1636070227-15909-1-git-send-email-quic_subbaram@quicinc.com>
 <CAJZ5v0gONybD_pVCAq6ZJTMuStXtoF064u9qPYxco4y=b-JD9A@mail.gmail.com>
 <c7ede029-b75f-e57e-24f1-9633d5d47401@linaro.org> <CAJZ5v0j1TDe0ZiBg_ju-JDuCsBDb_exueRDUwCcJ6VD_=fbzjg@mail.gmail.com>
 <6fd1b6ca-15fc-757b-8755-7f8ec4110bcc@quicinc.com>
In-Reply-To: <6fd1b6ca-15fc-757b-8755-7f8ec4110bcc@quicinc.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 5 Nov 2021 21:19:51 +0100
Message-ID: <CAJZ5v0haK3570pipSHg3k22=vUXu5DUpoDrbxWSqELSuGd0uxQ@mail.gmail.com>
Subject: Re: [RESEND PATCH v2] thermal: Fix a NULL pointer dereference
To:     Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
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

On Fri, Nov 5, 2021 at 9:08 PM Subbaraman Narayanamurthy
<quic_subbaram@quicinc.com> wrote:
>
> On 11/5/21 9:37 AM, Rafael J. Wysocki wrote:
> > On Fri, Nov 5, 2021 at 5:19 PM Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
> >> On 05/11/2021 16:14, Rafael J. Wysocki wrote:
> >>> On Fri, Nov 5, 2021 at 12:57 AM Subbaraman Narayanamurthy
> >>> <quic_subbaram@quicinc.com> wrote:
> >>>> of_parse_thermal_zones() parses the thermal-zones node and registers a
> >>>> thermal_zone device for each subnode. However, if a thermal zone is
> >>>> consuming a thermal sensor and that thermal sensor device hasn't probed
> >>>> yet, an attempt to set trip_point_*_temp for that thermal zone device
> >>>> can cause a NULL pointer dereference. Fix it.
> >>>>
> >>>>  console:/sys/class/thermal/thermal_zone87 # echo 120000 > trip_point_0_temp
> >>>>  ...
> >>>>  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020
> >>>>  ...
> >>>>  Call trace:
> >>>>   of_thermal_set_trip_temp+0x40/0xc4
> >>>>   trip_point_temp_store+0xc0/0x1dc
> >>>>   dev_attr_store+0x38/0x88
> >>>>   sysfs_kf_write+0x64/0xc0
> >>>>   kernfs_fop_write_iter+0x108/0x1d0
> >>>>   vfs_write+0x2f4/0x368
> >>>>   ksys_write+0x7c/0xec
> >>>>   __arm64_sys_write+0x20/0x30
> >>>>   el0_svc_common.llvm.7279915941325364641+0xbc/0x1bc
> >>>>   do_el0_svc+0x28/0xa0
> >>>>   el0_svc+0x14/0x24
> >>>>   el0_sync_handler+0x88/0xec
> >>>>   el0_sync+0x1c0/0x200
> >>>>
> >>>> While at it, fix the possible NULL pointer dereference in other
> >>>> functions as well: of_thermal_get_temp(), of_thermal_set_emul_temp(),
> >>>> of_thermal_get_trend().
> >>> Can the subject be more specific, please?
> >>>
> >>> The issue appears to be limited to the of_thermal_ family of
> >>> functions, but the subject doesn't reflect that at all.
> >>>
> >>>> Suggested-by: David Collins <quic_collinsd@quicinc.com>
> >>>> Signed-off-by: Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>
> >>> Daniel, any concerns regarding the code changes below?
> >> I've a concern about the root cause but I did not have time to
> >> investigate how to fix it nicely.
> >>
> >> thermal_of is responsible of introducing itself between the thermal core
> >> code and the backend. So it defines the ops which in turn call the
> >> sensor ops leading us to this problem.
> >>
> >> So, without a better solution, this fix can be applied until we rethink
> >> the thermal_of approach.
> >>
> >> Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> > Thanks!
> >
> > I've queued it up for 5.16-rc as "thermal: Fix NULL pointer
> > dereferences in of_thermal_ functions".
>
> Thanks, Daniel and Rafael. So, I guess I don't need to send v3 with fixing commit subject right?

Right.
