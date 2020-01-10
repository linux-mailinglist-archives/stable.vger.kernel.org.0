Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F195A1374DF
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 18:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbgAJRdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 12:33:47 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:40925 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728081AbgAJRdq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jan 2020 12:33:46 -0500
Received: by mail-oi1-f196.google.com with SMTP id c77so2525673oib.7
        for <stable@vger.kernel.org>; Fri, 10 Jan 2020 09:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ksl+vJ81uwWzx8tmYMkSddxoxlD6SBF31Vqw/Cm4F+4=;
        b=pDxzWr7JwNvVuHmgOkjXvIPc55f0Lxat/iHEV3kBknVGkWuYT//7MLvF/rGm1UEw13
         xgDXvajUgFSkVn/Mowb0vgHH2bwIAwKnEETTxzK1eXw7e84VJbxaQcyW4S5wirg+EJxh
         H6xgxHjXMbk/cX6gJ0jpb3sUmn3n47ozfND3hrv3kd4iGvakcCkAdAC4c8X2NAxPcxWM
         vu+CPR26ON3H+Y2xutoAt1P1ZqvPtWYDDXfH3/sJMxDa0JrFdbXujOl0sL3cFN/9T3wS
         u0YArVRLEqfFQG7ig9QV4Bp1mClj87MvFdBC14326lSfQKSOZJERsfaU5JA3e3JgzIOA
         j8cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ksl+vJ81uwWzx8tmYMkSddxoxlD6SBF31Vqw/Cm4F+4=;
        b=sIzU4I/N7Y2UtI4/vvqv2L/0DKdnUDSnVc8TfHhYVCIgiceKXmp8Q4BeUiEITnFV79
         xhyH2PvseRzSgwy5IHJh7xYCk1sZ54QjJCkUEQkNkbLvRyOyeGL3ZI4YqLvNh3yv1XUa
         f8JTOSnyYghhYygVtdsKSKeEJH7peXSrVpcMy57n0C+/XMgou14nnFcloMBAUqQLgK83
         cBZe05ArzqpuGkm1Nrd0cPaJ4dYVz1ASpl3MFPBr7YlguaZRYJOJZJgsFRXKlFvRiMHR
         UI+GOQGxt9OqlFc09p2EC/BcxjL9kmdaLHHd3MbD7BlyR7NY4Vlvk3OCLRxBbHM9Y9js
         nsXA==
X-Gm-Message-State: APjAAAXXUGJxcCqI/GIhmTcuB9x5yLrAcnPS45u2V24Bep3xbwuEo72U
        mSKV/gSYv/h0v23YkQ8pv7ZPRcPrSi9IM+hy3mjgxQ==
X-Google-Smtp-Source: APXvYqzhq0ZmPdm2FvbVqqhxRBWJSuPUXMhdMbWwgHAHxrtLp0P4UgLsD45jDwlWNkJLZu30q0SN2uRTJVQPKboYUDo=
X-Received: by 2002:aca:4c9:: with SMTP id 192mr3272786oie.105.1578677626092;
 Fri, 10 Jan 2020 09:33:46 -0800 (PST)
MIME-Version: 1.0
References: <157863061737.2230556.3959730620803366776.stgit@dwillia2-desk3.amr.corp.intel.com>
 <e60e64f9-894b-4121-d97b-fb61459cbbe5@redhat.com> <CAPcyv4jm=fmP=-5vbo2jxzMe2qXqZP=zDYF8G_rs3X6_Om0wPg@mail.gmail.com>
 <4d0334e2-c4e7-6d3f-99ba-2ca0495e1549@redhat.com> <CAPcyv4jixmv8fJ5FiYE=97Jud3Mc+6QzRX1txceSYU+WY_0rQA@mail.gmail.com>
 <fc0cfb97-5a60-7e73-4f85-d8e6947c5e28@redhat.com>
In-Reply-To: <fc0cfb97-5a60-7e73-4f85-d8e6947c5e28@redhat.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 10 Jan 2020 09:33:35 -0800
Message-ID: <CAPcyv4jVpN26RGQLRn4BewYtzHDoQfvh37DEdEBq1dd4-BP0kw@mail.gmail.com>
Subject: Re: [PATCH] mm/memory_hotplug: Fix remove_memory() lockdep splat
To:     David Hildenbrand <david@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Michal Hocko <mhocko@suse.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 10, 2020 at 9:29 AM David Hildenbrand <david@redhat.com> wrote:
[..]
> > So then the comment is actively misleading for that case. I would
> > expect an explicit _unlocked path for that case with a comment about
> > why it's special. Is there already a comment to that effect somewhere?
> >
>
> __add_memory() - the locked variant - is called from the same ACPI location
> either locked or unlocked. I added a comment back then after a longe
> discussion with Michal:
>
> drivers/acpi/scan.c:
>         /*
>          * Although we call __add_memory() that is documented to require the
>          * device_hotplug_lock, it is not necessary here because this is an
>          * early code when userspace or any other code path cannot trigger
>          * hotplug/hotunplug operations.
>          */
>
>
> It really is a special case, though.

That's a large comment block when we could have just taken the lock.
There's probably many other code paths in the kernel where some locks
are not necessary before userspace is up, but the code takes the lock
anyway to minimize the code maintenance burden. Is there really a
compelling reason to be clever here?
