Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C43F35E5D3
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 20:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245688AbhDMSDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 14:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242024AbhDMSDf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 14:03:35 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01425C061756
        for <stable@vger.kernel.org>; Tue, 13 Apr 2021 11:03:13 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id l22so13024352ljc.9
        for <stable@vger.kernel.org>; Tue, 13 Apr 2021 11:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q2LuJhzVKZ4Otm2O8xgEBL/YvpN8rgKv4ejnz0lZhBQ=;
        b=PO/bW2FzQ6FzDgtNlCdHkJnMiT/9i4p/A90U8bBxxRlm7QtH1Avg7IzpZfFUhf35To
         +ZprUvd82vXwEvPh0u/Wi3KG3gk81wdPlFg/XLIPaP/wNf+1sF0XsbnBxxL1x6krTUNB
         oAhJcsICyl5wezmkkpndEaqZQAhKrbopebRWE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q2LuJhzVKZ4Otm2O8xgEBL/YvpN8rgKv4ejnz0lZhBQ=;
        b=jKS+py5hDFAY4t4utdE8NXIT4nGTc2hQvTYwI/iS5cR1gc8AcC1ptbtrw/dX/8EQMC
         J+8hU8N/5lxRNxaAoFQCO1xs5VVPdlfJbb1wYigB5l+0656A6sHHr6r1xm2Juy9GvUwj
         /57zj2kgF/tTK9G7Wwl+1C/1JB1nnOOaVOEyL4OyzkiXU3KI4X5G3eAGlp3EE5Ud5M/0
         Mw0rHAAKMgeslw1qBlgNH57Oeffx3X/6xTE9p5BmwzqYpDGOhImv5Se7jH7U0pDFd5kp
         XlJFrGfV35RuO3nO1c4m9Iemwg3Y8+GNdGZ1vCYkSNtfLjovUX6SJNbLXbUrpLaM4lAp
         emvQ==
X-Gm-Message-State: AOAM5338ZFk5UO0ZZvQVSLliyZaW1au3Kzdl6KM5nFGjzXJIexseRjvj
        1xtHECsYZtMUKOc5DPq4CXpFV0AJOcK0XCGx824m1w==
X-Google-Smtp-Source: ABdhPJzhrB2wAPmm6F6wdESZbAAnM20kVhcjVE6+YBb8Q9dx2+OjXTPj+pfRlhGpetqNXpEueb9hrrRKAaxhYYwq3nQ=
X-Received: by 2002:a2e:3013:: with SMTP id w19mr9815088ljw.97.1618336992322;
 Tue, 13 Apr 2021 11:03:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210413160151.3301-1-rodrigo@kinvolk.io> <20210413160151.3301-2-rodrigo@kinvolk.io>
 <20210413175355.kttgdouoyiykug5i@wittgenstein>
In-Reply-To: <20210413175355.kttgdouoyiykug5i@wittgenstein>
From:   Rodrigo Campos <rodrigo@kinvolk.io>
Date:   Tue, 13 Apr 2021 20:02:35 +0200
Message-ID: <CACaBj2ZieT2vH3_ywSkzzWXjJuSdBr1ytXdazTJ9-8mmA7xNvg@mail.gmail.com>
Subject: Re: [PATCH 1/1] seccomp: Always "goto wait" if the list is empty
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Sargun Dhillon <sargun@sargun.me>,
        =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>,
        Alban Crequy <alban@kinvolk.io>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 13, 2021 at 7:54 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
> > Fixes: 7cf97b1254550
> > Cc: stable@vger.kernel.org # 5.9+
> > Signed-off-by: Rodrigo Campos <rodrigo@kinvolk.io>
> > ---
>
> So the agent will see the return value from
> wait_for_completion_interruptible() and know that the addfd wasn't
> successful and the target will notice that no addfd request has actually
> been added and essentially try again. Seems like a decent fix and can be

Yes, exactly!

> backported cleanly. I assume seccomp testsuite passes.

Yes, seccomp selftests (tools/testing/selftests/seccomp/seccomp_bpf) passes fine

> Acked-by: Christian Brauner <christian.brauner@ubuntu.com>

Thanks!
