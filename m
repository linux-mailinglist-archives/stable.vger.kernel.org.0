Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35592141557
	for <lists+stable@lfdr.de>; Sat, 18 Jan 2020 02:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbgARBI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 20:08:27 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:43295 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728778AbgARBI1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 20:08:27 -0500
Received: by mail-ot1-f68.google.com with SMTP id p8so24115808oth.10;
        Fri, 17 Jan 2020 17:08:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l6P4Fnegy4rwUdhWwaJ6/C5SEB1gW7H6NwOiITs9ONM=;
        b=rGW+QfMh6+H1RsSDNhw/ZevM+v07L0Fk1yP9hKBvpFBCCiN/sf5gl6INwTFZohanlV
         5uH479eUkMM1B4gcpXvbOm0Al4+6uG3SWShalfg+dNPKWQ/tu+QtoudKlzsyGMwzsrMM
         reh2vnDrshTZBYLGKDfTKqkK0STb/Q8jF7cH/A3oq1eWb3HbJCyvMOdN9XYUHfw6epP8
         BPIcyC2mwXLY8frrFbAcexTRH4xGsBMoqC2apA9g6wwgyDuWxoBLpVLLmGjnmn8FXDhm
         AQu3yJHS6dhPi2EHXByIggKdw5vpfyyuM2osSf/tNJ1fEZrn00vomWSW8dmlZaFPy3Rs
         joQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l6P4Fnegy4rwUdhWwaJ6/C5SEB1gW7H6NwOiITs9ONM=;
        b=hr4Bu/zUYJfYxfEWog4eJT9iFyzcHYgsw7xAb5/3wp7TSfv8ke8X8vLH76kKxEQeSf
         D7rSLs0yxZYq4bWDUuT7DB3yhYChWp/AKhtxcMh+aF7PzobnI0IRyjX7tXGstAWLQAMM
         EnHH+EiBaFa//eu8+IUFoUHFj0hTu2EYvNrctDbJ/raEVnu52by2ABHqs1XBH/A9COu+
         bsUfzzpTeuLkJxZvL04bEWJGWp6tdJlXVRqAjDINkqu4tR8fUb/I+Jas54dVsGxuRFDN
         v4FTTkU2mKGX7s9qjeBHL075MVZTryuwlehPxpVgeH4+6B6qRy8WnoY0/ozcKtT5G3oJ
         ss1w==
X-Gm-Message-State: APjAAAXV4pkrPn24jIij4pTkG/u7BoK+IERIo7urdceMDL+hP8KZ3eK7
        3CDlIFq9DQJZG7vCJi7khJRmgz91YCzymevS1Kg=
X-Google-Smtp-Source: APXvYqz90xS6SX3QX744m9bE2bDuKzbBBbUGKiW5LA1u7OcwdWB3RdMQZtYEPw41Ebv4qN5Hub+V5NPcu256KbghbOI=
X-Received: by 2002:a9d:7592:: with SMTP id s18mr8452268otk.130.1579309705918;
 Fri, 17 Jan 2020 17:08:25 -0800 (PST)
MIME-Version: 1.0
References: <20200115171736.16994-1-christian.brauner@ubuntu.com>
In-Reply-To: <20200115171736.16994-1-christian.brauner@ubuntu.com>
From:   Andrei Vagin <avagin@gmail.com>
Date:   Fri, 17 Jan 2020 17:08:14 -0800
Message-ID: <CANaxB-wOJCc_Z3YXiokMeTLi2=rPf0-=7-bwAJnEjX-bDvTPEg@mail.gmail.com>
Subject: Re: [PATCH] ptrace: reintroduce usage of subjective credentials in ptrace_has_cap()
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Serge Hallyn <shallyn@cisco.com>, Jann Horn <jannh@google.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Eric Paris <eparis@redhat.com>, stable@vger.kernel.org,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Adrian Reber <adrian@lisas.de>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 15, 2020 at 9:18 AM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> Commit 69f594a38967 ("ptrace: do not audit capability check when outputing /proc/pid/stat")
> introduced the ability to opt out of audit messages for accesses to
> various proc files since they are not violations of policy.
> While doing so it somehow switched the check from ns_capable() to
> has_ns_capability{_noaudit}(). That means it switched from checking the
> subjective credentials of the task to using the objective credentials. I
> couldn't find the original lkml thread and so I don't know why this switch
> was done. But it seems wrong since ptrace_has_cap() is currently only used
> in ptrace_may_access(). And it's used to check whether the calling task
> (subject) has the CAP_SYS_PTRACE capability in the provided user namespace
> to operate on the target task (object). According to the cred.h comments
> this would mean the subjective credentials of the calling task need to be
> used.
> This switches it to use security_capable() because we only call
> ptrace_has_cap() in ptrace_may_access() and in there we already have a
> stable reference to the calling tasks creds under cred_guard_mutex so
> there's no need to go through another series of dereferences and rcu
> locking done in ns_capable{_noaudit}().

This patch breaks CRIU tests:

All CRIU tests fail because ptrace returns EPERM:

$ python test/zdtm.py run -t zdtm/static/env00 --sat
=== Run 1/1 ================ zdtm/static/env00
========================== Run zdtm/static/env00 in h ==========================
Start test
./env00 --pidfile=env00.pid --outfile=env00.out --envname=ENV_00_TEST
Run criu dump
=[strace]=> dump/zdtm/static/env00/44/1/dump.strace
=[log]=> dump/zdtm/static/env00/44/1/dump.log
------------------------ grep Error ------------------------
b'(00.014558) cg:     `- [net_cls,net_prio] -> [/] [0]'
b'(00.014634) cg:     `- [perf_event] -> [/] [0]'
b'(00.014713) cg:     `- [pids] ->
[/user.slice/user-0.slice/session-1.scope] [0]'
b'(00.014818) cg: Set 1 is criu one'
b'(00.015123) Warn  (compel/src/lib/infect.c:127): Unable to interrupt
task: 44 (Operation not permitted)'
b'(00.015302) Unlock network'
b'(00.015423) Unfreezing tasks into 1'
b'(00.015524) \tUnseizing 44 into 1'
b'(00.015701) Error (compel/src/lib/infect.c:346): Unable to detach
from 44: No such process'
b'(00.015864) Error (criu/cr-dump.c:1775): Dumping FAILED.'
------------------------ ERROR OVER ------------------------
################### Test zdtm/static/env00 FAIL at CRIU dump ###################
Send the 9 signal to  44
Wait for zdtm/static/env00(44) to die for 0.100000
##################################### FAIL #####################################

Here is a strace output for the criu dump process:

write(4, "(00.014482) cg:     `- [name=zdt"..., 61) = 61 <0.000028>
write(4, "(00.014558) cg:     `- [net_cls,"..., 53) = 53 <0.000028>
write(4, "(00.014634) cg:     `- [perf_eve"..., 47) = 47 <0.000031>
write(4, "(00.014713) cg:     `- [pids] ->"..., 80) = 80 <0.000034>
write(4, "(00.014818) cg: Set 1 is criu on"..., 34) = 34 <0.000028>
rt_sigaction(SIGALRM, {sa_handler=0x43de00, sa_mask=[ALRM],
sa_flags=SA_RESTORER, sa_restorer=0x7f962247c6b0}, NULL, 8) = 0
<0.000018>
alarm(10)                               = 0 <0.000025>
ptrace(PTRACE_SEIZE, 44, NULL, 0)       = -1 EPERM (Operation not
permitted) <0.000022>
write(4, "(00.015123) Warn  (compel/src/li"..., 104) = 104 <0.000029>
alarm(0)                                = 10 <0.000032>
write(4, "(00.015302) Unlock network\n", 27) = 27 <0.000043>
write(4, "(00.015423) Unfreezing tasks int"..., 36) = 36 <0.000036>

The criu process is started with all capabilities in the root user namespace.

I don't have time to investigate this issue right now, will provide
more details next Tuesday.

The issue has been detected by our travis-c job:
https://travis-ci.org/avagin/linux/jobs/638547093

Thanks,
Andrei
