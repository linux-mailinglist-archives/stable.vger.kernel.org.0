Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80482380A9B
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 15:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbhENNqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 09:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbhENNqL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 May 2021 09:46:11 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09CF6C061574;
        Fri, 14 May 2021 06:45:00 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1620999897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Jjy0U9TVSgQ/UDMCkhIERPIDzus1fWQqGP32JHzOO1I=;
        b=UtuaPgWzO9zfB6iMIFwhPWSqmMP5wvuBvHYlkcATekBDoPJhOYyPA6DnQNHpYy3/2CwUCv
        XQVhWwlwYeLmJ3QSE6ifWg2N+8Ma9QmzTsYXLsdXjtf0SefxKd4++Nzuul1hTnZp6HwzDX
        LLKl18SMYDjhGdFPhz4a4CJ5A/sp+wPAuUvIGYTGgk7nTdkQVnO+LNd7rXqzGCBkHhlmGR
        SzKnN3xpu2oM6pi/HhDG37ABJzvDYs6ux7bz30XOq4tkFel08QPdX+VOU8ENcyKipMSIQj
        +aDaMg5qe25R/phsxd4fAsIjAmUN3s9zf0rMr8E/jnHEYR52Xof8TdrWHiDdeA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1620999897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Jjy0U9TVSgQ/UDMCkhIERPIDzus1fWQqGP32JHzOO1I=;
        b=rs/WfdhwubkjY+Ynk5qqlultcDtj9/9JGaGu2UoAIC7NiYbmVKUd3R59P5tMLig6m9mZDf
        eBSyIwyuWUCPfTBw==
To:     Maximilian Luz <luzmaximilian@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, Sachi King <nakato@nakato.io>,
        "x86\@kernel.org" <x86@kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/i8259: Work around buggy legacy PIC
In-Reply-To: <e7dbd4d1-f23f-42f0-e912-032ba32f9ec8@gmail.com>
References: <20210512210459.1983026-1-luzmaximilian@gmail.com> <9b70d8113c084848b8d9293c4428d71b@AcuMS.aculab.com> <e7dbd4d1-f23f-42f0-e912-032ba32f9ec8@gmail.com>
Date:   Fri, 14 May 2021 15:44:57 +0200
Message-ID: <87r1i94eg6.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Max,

On Thu, May 13 2021 at 12:11, Maximilian Luz wrote:
> And lastly, if that's any help at all: The PIC device is described in
> ACPI in [3]. The Surface Laptop 3 also has an AMD CPU (although a prior
> generation) and has the PIC described in the exact same way (can also be
> found in that repository), but doesn't exhibit that behavior (and
> doesn't show the "Using NULL legacy PIC" line). I expect there's not
> much you can change to that definition so that's probably irrelevant
> here.
>
> Again, I don't really know anything about these devices, so my guess
> would be bad hardware revision or bad firmware revision. All I know is
> that retrying seems to "fix" it.

That might be a a power optimization thing.

Except for older systems the PIC is not really required for IOAPiC to
work. But there is some historical code which makes assumptions. We can
change that, but that needs some careful thoughts.

Thanks,

        tglx
