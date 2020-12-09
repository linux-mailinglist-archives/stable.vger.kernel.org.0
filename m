Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 721FB2D397C
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 05:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbgLIEM7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 23:12:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:36730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726904AbgLIEM7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Dec 2020 23:12:59 -0500
X-Gm-Message-State: AOAM5323zSz9dNpu3avzKCT+emP5/iZBw9HC8tQYfbpQcCMxDRXXPpIX
        p1PuQsUXt9CUIvuKW2ZnIF4IZpoK7DJSAqSCbGY+xA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607487138;
        bh=T188CSCzmaxoBb4wflGrzriHtk1b6lO8/Wsfirzkfcs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=esnv+UyoDJL4sotnWJgJUKSI6WaJPo0tsNN5DTebhV8tMq1cLVxfGjapmRmdBg6ve
         OhYix6fwPMTIgDBc3ZiYNZEJvmcmiMkCLsC434GDcpaXBMhoQvG612ZbaZOm6i9QyD
         nBzjC5pMrmM7pH9TJpZHt3c/ePven/Gm/c1lPq83K70TU8aLYFSJ0NWba380jbqYVu
         B6avjJPmWR0fdhNdqX8z6pQLb2qA2tB4sRHf8TqouHclX9nuIDPgFmDw8c0UsIqBed
         2QFBXze0oJvwUh1QpMmCVGDm66M1UUFZ67sFafsCX012Cenqnn/odzQ9lcPWGf6lIL
         0NgTxuulcHwJg==
X-Google-Smtp-Source: ABdhPJya/UabVq/pf2WMuv8V5Nfjpqg5bAe9yGKg1i5sbKNO8eZgqPLfOQUFDmUaGRBce9Dgzdi3mmz5pyquaA6ccjk=
X-Received: by 2002:adf:e64b:: with SMTP id b11mr359389wrn.257.1607487137144;
 Tue, 08 Dec 2020 20:12:17 -0800 (PST)
MIME-Version: 1.0
References: <cover.1607058304.git.luto@kernel.org> <d3e7197e034fa4852afcf370ca49c30496e58e40.1607058304.git.luto@kernel.org>
In-Reply-To: <d3e7197e034fa4852afcf370ca49c30496e58e40.1607058304.git.luto@kernel.org>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 8 Dec 2020 20:12:06 -0800
X-Gmail-Original-Message-ID: <CALCETrWPLcNk5XsartvjPD+LNxrmwHrv5hY4hrFwbhYjugw+9g@mail.gmail.com>
Message-ID: <CALCETrWPLcNk5XsartvjPD+LNxrmwHrv5hY4hrFwbhYjugw+9g@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] membarrier: Add an actual barrier before rseq_preempt()
To:     Andy Lutomirski <luto@kernel.org>
Cc:     X86 ML <x86@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Anton Blanchard <anton@ozlabs.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 3, 2020 at 9:07 PM Andy Lutomirski <luto@kernel.org> wrote:
>
> It seems to me that most RSEQ membarrier users will expect any
> stores done before the membarrier() syscall to be visible to the
> target task(s).  While this is extremely likely to be true in
> practice, nothing actually guarantees it by a strict reading of the
> x86 manuals.  Rather than providing this guarantee by accident and
> potentially causing a problem down the road, just add an explicit
> barrier.
>
> Cc: stable@vger.kernel.org

Fixes: 2a36ab717e8f ("rseq/membarrier: Add
MEMBARRIER_CMD_PRIVATE_EXPEDITED_RSEQ")

which is new in 5.10, so it doesn't need cc:stable if it makes 5.10.
