Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5811084D60
	for <lists+stable@lfdr.de>; Wed,  7 Aug 2019 15:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388730AbfHGNdk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Aug 2019 09:33:40 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35546 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388309AbfHGNdk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Aug 2019 09:33:40 -0400
Received: by mail-qt1-f194.google.com with SMTP id d23so88336715qto.2;
        Wed, 07 Aug 2019 06:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=A4Sq4ocEVYTK0XD+qtBWIKZxIW66i4fTHcbBJmHYjU4=;
        b=DxQJfMqenZVrlyG1M+L7UTpqQY2NMpc4bz5XJnKAqHVzsbHrB9hnT3fk/I9lLddhlU
         Los92TqXW43XQhNt6Rg3RiWJ6Iu24iM/I39Mphoo5I+M2ZltuJHUvRTZOYJmcVXPyCSk
         uy6wSB4T5YOP8QoIjqMfioNHn2O1k4UeRjEYUnltdsxogP2CwNC/Pv7v6DBH+w6Tvg8B
         lpss86hmVmUpGXPysro5tuxtR3EWjlwv2nE1V2tw8I1FknED3hbsTmU9T0RqP36rZYw7
         FD+LUuLx18VCrPA58pTrzt2fFjV9IQTD8PiB+zaZvZeuUttIw9ed7I90lsI5XcrOIDDI
         9Tiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=A4Sq4ocEVYTK0XD+qtBWIKZxIW66i4fTHcbBJmHYjU4=;
        b=liOcY7S6i1g9YnbdtCaQXuzEmxx8rATS90noykBHBMbn72BWHt9g5wvr2oSi+kF2nV
         VVC8Q7Mt77dFqBZ0NpiQI1Yp2eabHG1FkEkbsgWDZNrMMB0yFr6okyZtTikipC5SkeGe
         2ccAQTYEIhwbvBwpIvXIL6E15vl+B35yR3vKmUp+0KyjS2gF/EOYeVhntr1suo/lkeIH
         jONYvCggW0SVWdCoPbgdEzLTF3DvQw6fSICfzZpHsraFhFSgiPBWJV4UWmlKAq3qFBS1
         RA0tb5PJw2YtE6DDdneinccFeleoU6uUtUxKAgEvwGPiFu9sYE8JZAk3sR1h9IBuYRXS
         FvxA==
X-Gm-Message-State: APjAAAW/rlI6EuHUy/7/X8u2VQKZ6I4f0T7t/RKbCOj2l3A1U3IsZfMJ
        Bz9ap6p4GXiueI418YH/ixd25xGueOQGyWih8pw=
X-Google-Smtp-Source: APXvYqzUd46nWSwmFEX3el+JBhCf3t5gbEPh8XiNrCaSQ4+xLt4n0K/Q5Z/4tyFbFxjA9E73lTeIH9dea/vLxMYD688=
X-Received: by 2002:ac8:5048:: with SMTP id h8mr8066056qtm.190.1565184819230;
 Wed, 07 Aug 2019 06:33:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190719135352.GF4240@sasha-vm> <20190807114649.fjfaj4oytcxaua7o@linutronix.de>
 <CADLLry6a9a0TKOEEPxOW_DS+XXwk5qUuaH+W9cmbLwvudXAV8A@mail.gmail.com> <alpine.DEB.2.21.1908071452350.24014@nanos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.21.1908071452350.24014@nanos.tec.linutronix.de>
From:   Austin Kim <austindh.kim@gmail.com>
Date:   Wed, 7 Aug 2019 22:33:31 +0900
Message-ID: <CADLLry5bKjVB5BM7HVF8wOPXkQWpQ-6xM=F78MDRHhpCxE=uBw@mail.gmail.com>
Subject: Re: NULL ptr deref in wq_worker_sleeping on 4.19
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Sasha Levin <sashal@kernel.org>, peterz@infradead.org,
        mingo@kernel.org, tj@kernel.org, jiangshanlai@gmail.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        =?UTF-8?B?I+yEnO2YleynhA==?= <mike.seo@lge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Is it possible for you to generate kernel patch only with **kernel
log** for 'use-after-free' case?
With kernel log, we only have limited information, so it is hard to
debug 'use-after-free' case with this signature.

For this matter, kernel should be compiled with below config.
CONFIG_SLUB_DEBUG=3Dy
CONFIG_SLUB_DEBUG_ON=3Dy

2019=EB=85=84 8=EC=9B=94 7=EC=9D=BC (=EC=88=98) =EC=98=A4=ED=9B=84 9:56, Th=
omas Gleixner <tglx@linutronix.de>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> On Wed, 7 Aug 2019, Austin Kim wrote:
>
>   A: Because it messes up the order in which people normally read text.
>   Q: Why is top-posting such a bad thing?
>   A: Top-posting.
>   Q: What is the most annoying thing in e-mail?
>
>   A: No.
>   Q: Should I include quotations after my reply?
>
>   http://daringfireball.net/2007/07/on_top
>
> > I wonder what kinds of workqueue is used in case of this panic.
> >
> > If system workqueue(system_wq) is used for this case, it would be a
> > help to replace it with high priority workqueue(system_highpri_wq). If
> > panic disappers with high priority workqueue(system_highpri_wq), we
> > would think about another scenario.
>
> How would that help? As Sebastian explained, something overwrote memory o=
r
> it is a Use After Free. How would a high priority workqueue 'fix' that?
>
> You need to find the root cause, which is either memory corruption or a u=
se
> after free.
>
> Thanks,
>
>         tglx
