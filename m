Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8296E47BEF
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 10:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbfFQIPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 04:15:50 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:37413 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbfFQIPq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 04:15:46 -0400
Received: by mail-lf1-f66.google.com with SMTP id d11so5826754lfb.4
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 01:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=ISvoq3+E231xgZNYDcOvysydNx1/W6JTFl0n7wdsdXI=;
        b=ZOtAuzcBiPy8sZiGvKxzKSX+qeQlH2Y1m2S3iyyz1jJIpk9+LYlngBGC0rUZ5I8cdc
         bShxfNHMpLwZq3IGZiIM8ncZ9TFhxJ2Mra+dT/FL/LeEzwFARKu+Ef8vh+InHBRYMGtD
         52rDegfzOwyWgYc5lHhAaUkCJ1gX5IRvv+8drvesRYmH4SJa4vrWokLlGJj7ZlfTl/T4
         Lqoy5i7/XhGpGMqjFBQ0YcQEtPSHX9QocNRX/9vCo336nL7sk+B/DQU34VZd3Y5F14Qy
         NBslVl53ep8bPNtyixSRAwa+UeHw1NNBIw3NHWPQes15BqzqLgsTewl8Dc+Ybq8sFxr2
         hIdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=ISvoq3+E231xgZNYDcOvysydNx1/W6JTFl0n7wdsdXI=;
        b=rMUWB7JH7Q4JW4oHJ3qTVTmAX9bc1tVrNsbQGdLbVeORWuVmg74tOciSLSeAlQmuXO
         9Dg7WNGKtq0RuVN1zjYZqi/KkTAEcfrip4/PQKsdq8x919wSI+/KhzWQ4BgG77rm3iRq
         AQ2PbMWPxyDuckAJv0t7JCrrH3A7ajMYz9U+q9cq91ivkTeFlMJvYS4As7ki4QDtD4Jn
         wOgEsALE0TX8UkWz+YsC/++YO5vS3egSWLL5bgfOmqJ76pRQcuyE69FuL117gV0w+2+v
         b+q51H6qvis0RB8A/wm/vOSrAvqgX5PkqHKk/AjHIg6AAtfjMUSRerR50RUUpgY7l2zj
         +Xvg==
X-Gm-Message-State: APjAAAWDxIsbDSiUcb1fcDOV5Aso9bXzysUq6R6eRMbrP9G+FwMDuOF/
        px6FT+Esqan1PzVeR8FlUNXDzlKMHhU98t2/Q4/RwkzCCDE=
X-Google-Smtp-Source: APXvYqxWua19+hSUVQ6C+AsovORGeOGCcB+tB474a5UOunGTM5LyKrbLX7rEkOyiNu0nvEBRlbTDwCNI1pC+wu+lG24=
X-Received: by 2002:a05:6512:51c:: with SMTP id o28mr38430162lfb.67.1560759344233;
 Mon, 17 Jun 2019 01:15:44 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 17 Jun 2019 13:45:32 +0530
Message-ID: <CA+G9fYsFL5AH6dkdN2Qd6UP=wdiXRDR_ioQFPSCq=uUBcmtHXw@mail.gmail.com>
Subject: stable-rc: ptrace: peeksiginfo failed on 4.19, 4.14, 4.9 and 4.4
To:     ebiederm@xmission.com, avagin@gmail.com
Cc:     linux- stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lkft-triage@lists.linaro.org,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

selftests: ptrace: peeksiginfo failed on x86_64, i386, arm64 and arm.
FAILED on stable rc branches 4.19, 4.14, 4.9 and 4.4.
PASS on mainline, next and 5.1 stable rc branch.

Test output:
------------------
cd /opt/kselftests/mainline/ptrace
./peeksiginfo
Error (peeksiginfo.c:143): Only 0 signals were read

The git bisect show that below commit caused this test to fail.

 git bisect bad
5b6b0eac235ef1f915f24eda6d501a754022cbf0 is the first bad commit
commit 5b6b0eac235ef1f915f24eda6d501a754022cbf0
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Tue May 28 18:46:37 2019 -0500

    signal/ptrace: Don't leak unitialized kernel memory with PTRACE_PEEK_SIGINFO

    commit f6e2aa91a46d2bc79fce9b93a988dbe7655c90c0 upstream.

    Recently syzbot in conjunction with KMSAN reported that
    ptrace_peek_siginfo can copy an uninitialized siginfo to userspace.
    Inspecting ptrace_peek_siginfo confirms this.

    The problem is that off when initialized from args.off can be
    initialized to a negaive value.  At which point the "if (off >= 0)"
    test to see if off became negative fails because off started off
    negative.

    Prevent the core problem by adding a variable found that is only true
    if a siginfo is found and copied to a temporary in preparation for
    being copied to userspace.

    Prevent args.off from being truncated when being assigned to off by
    testing that off is <= the maximum possible value of off.  Convert off
    to an unsigned long so that we should not have to truncate args.off,
    we have well defined overflow behavior so if we add another check we
    won't risk fighting undefined compiler behavior, and so that we have a
    type whose maximum value is easy to test for.

    Cc: Andrei Vagin <avagin@gmail.com>
    Cc: stable@vger.kernel.org
    Reported-by: syzbot+0d602a1b0d8c95bdf299@syzkaller.appspotmail.com
    Fixes: 84c751bd4aeb ("ptrace: add ability to retrieve signals
without removing from a queue (v4)")
    Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

:040000 040000 ff9f3109f210274d0b87851d226c35e7305ce44a
b36de2c855fe2a0b332f145f0966dc1a0304d4bd M kernel

Test case link,
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/testing/selftests/ptrace/peeksiginfo.c#n143

Test output log link,
https://lkft.validation.linaro.org/scheduler/job/777223#L1084

Test results comparison on different branches,
https://qa-reports.linaro.org/_/comparetest/?project=22&project=6&project=58&project=135&project=40&project=23&project=167&suite=kselftest&test=ptrace_peeksiginfo

Best regards
Naresh Kamboju
