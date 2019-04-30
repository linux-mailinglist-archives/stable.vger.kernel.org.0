Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28BF810113
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 22:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbfD3Ul3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 16:41:29 -0400
Received: from mail-io1-f43.google.com ([209.85.166.43]:39027 "EHLO
        mail-io1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfD3Ul3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Apr 2019 16:41:29 -0400
Received: by mail-io1-f43.google.com with SMTP id c3so13431881iok.6
        for <stable@vger.kernel.org>; Tue, 30 Apr 2019 13:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5Jot6L2DVm1DWEeaHZuaSLO/rNQCGghrc0uARjJajGo=;
        b=VHSnmGmpEPyel5884xq+xrHO1JSCSZG0ujFNgFqkE9BE/7yHJ4nl9Rp0WjguYJsKK0
         yqF6EAhPQ4aX+EhWGAhwVYM3uoqOiVuv7u+X3Bnns+++e42n3BVQQpCGBddjtiUDxXqm
         sZNi1rOp9ZkvotzhhMtIqOyw/IpLlIWFLRzvpUyWec0GX6QV5FWBdQQUQ8iyC0RLv6tq
         aviuNv8hTlnvrIRoUS52rEGKzqTifyVMGBi0sdCF+yecJz6Ir7SEaow/po5VdaVGZXVR
         lF3bjz+K7uwJ0lIWnvUSvHC8fXEgVls1upl0qMZuZLrC3VvABVCp4RC0f4lG9vq4ShE9
         0WaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5Jot6L2DVm1DWEeaHZuaSLO/rNQCGghrc0uARjJajGo=;
        b=ekJ6KJAX7NniiklqGxpCofmWgP0e/7AM/q+I6C5IjF7e3uV60yGpqxVbZ9WVCjap5b
         tlrBXzIOXzWHYe43P/6GAU9+WLBA/6o2gxqF+BE0C/2XVV/i9Sr4J/3r0u2wGT7kr3b5
         C0aAOyVcqNIb/0jZ/L0c+ENX6MLjbPJs6hmxFxrky3O6I/oEplsrD3FLWNJkCbDuslqS
         V+qlLh3MiSBcGzxwCpUPvyulWl8kBc3KYv4+LYWRR8fJUVpInMg8Ha44hmUSsy5l1AOc
         bXMiiMmGjOmOKdFYHyQdmvtZYlrHUApvgAGBUwfDA2aydRQI04gPi+Uqmi28Tjgj8xzZ
         biwg==
X-Gm-Message-State: APjAAAV5QHTOjbaHqEbdFIxlu8MuhhNZM2KXltsL2CHr6MacVjCV4PwE
        yYAGDTOwD27Fv0pDwTjKbNe8iQ2naMPz/M5minhBgA==
X-Google-Smtp-Source: APXvYqwWwErI3KDqM+hgWHj3qAOS6t/yqhY8CkAC8+eDkdGcjrKYnTPzIbIK75Sg2D7F9hWL2wEAmn8sym8VRpeRSFc=
X-Received: by 2002:a6b:7401:: with SMTP id s1mr3736992iog.55.1556656887851;
 Tue, 30 Apr 2019 13:41:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAMVonLhjzv-DWgKV82gDMCACML14UmE3zCqsffuiMKOSGfajhQ@mail.gmail.com>
 <20190424165009.GE21916@kroah.com> <CAMVonLhmPhcTVSAbZzCbmYQxRECWK+6bychxFzg232dtAXeqEA@mail.gmail.com>
 <20190424183419.GB10495@kroah.com>
In-Reply-To: <20190424183419.GB10495@kroah.com>
From:   Vaibhav Rustagi <vaibhavrustagi@google.com>
Date:   Tue, 30 Apr 2019 13:41:16 -0700
Message-ID: <CAMVonLiXfX8r=1-fwQCk275wrkBmxjXuyWJSAmW=7hjvy7YPyg@mail.gmail.com>
Subject: Re: [For Stable] mm: memcontrol: fix excessive complexity in
 memory.stat reporting
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, hannes@cmpxchg.org, tj@kernel.org,
        mhocko@suse.com, vdavydov.dev@gmail.com, guro@fb.com,
        riel@surriel.com, sfr@canb.auug.org.au, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, Aditya Kali <adityakali@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 24, 2019 at 11:53 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
>
> A: Because it messes up the order in which people normally read text.
> Q: Why is top-posting such a bad thing?
> A: Top-posting.
> Q: What is the most annoying thing in e-mail?
>
> A: No.
> Q: Should I include quotations after my reply?
>
> http://daringfireball.net/2007/07/on_top
>
> On Wed, Apr 24, 2019 at 10:35:51AM -0700, Vaibhav Rustagi wrote:
> > Apologies for sending a non-plain text e-mail previously.
> >
> > This issue is encountered in the actual production environment by our
> > customers where they are constantly creating containers
> > and tearing them down (using kubernetes for the workload).  Kubernetes
> > constantly reads the memory.stat file for accounting memory
> > information and over time (around a week) the memcg's got accumulated
> > and the response time for reading memory.stat increases and
> > customer applications get affected.
>
> Please define "affected".  Their apps still run properly, so all should
> be fine, it would be kubernetes that sees the slowdowns, not the
> application.  How exactly does this show up to an end-user?
>

Over time as the zombie cgroups get accumulated, kubelet (process
doing frequent memory.stat) becomes more cpu resource intensive and
all other user containers running on the same machine will starve for
cpu. It affects the user containers in at-least 2 ways that we know
of: (1) User experience liveness probe failures where there
applications are not completed in expected amount of time. (2) new
user jobs cannot be schedule,
There certainly is a possibilty of reducing the adverse affect at
Kubernetes level as well, and we are investigating that as well. But,
the kernel patches requested helps in not exacerbating the problem.

> > The repro steps mentioned previously was just used for testing the
> > patches locally.
> >
> > Yes, we are moving to 4.19 but are also supporting 4.14 till Jan 2020
> > (so production environment will still contain 4.14 kernel)
>
> If you are already moving to 4.19, this seems like a good as reason as
> any (hint, I can give you more) to move off of 4.14 at this point in
> time.  There's no real need to keep 4.14 around, given that you don't
> have any out-of-tree code in your kernels, so all should be simple to
> just update the next reboot, right?
>

Based on the past experiences, major kernel upgrade sometime
introduces new regressions as well. So while we are working to roll
out kernel 4.19, it may not be a practical solution for all the users.

> thanks,
>
> greg k-h

Thanks,
Vaibhav
