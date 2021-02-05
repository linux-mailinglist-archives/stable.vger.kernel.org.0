Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55DA6311051
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 19:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233289AbhBERGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 12:06:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233585AbhBEQqJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 11:46:09 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F99C0617A7
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 10:27:35 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id f1so11254813lfu.3
        for <stable@vger.kernel.org>; Fri, 05 Feb 2021 10:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mhfCHagI1sqqpf6f51+Hwn9ljjzG7Pktd2A52iAON7E=;
        b=a43ocwMCwZeo+3MGlYdg1zDoiFF7DJJOFXNomaVtcvC8cInQQD1hj2yMwIl4iNZLUD
         EJ8zjjoyTQONpuBCXbKs+ADXfo7RaoOqx0WZ/sggeC66H6qVljAubJzJu8yFWNZDl/Cn
         cArQYXLJCHtQnELcmBMDI9yUOfs0zb3ulbXyI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mhfCHagI1sqqpf6f51+Hwn9ljjzG7Pktd2A52iAON7E=;
        b=GTk1eK1ejZY5mZVyvWUPOpYENThPd5fFwvulV5TwMtUXLObhNObOeJldFazUebDz7s
         QOwDhKDnVrF2DGPXrLo6SZshTuGpscz4btzy73B88r5dGWrk3Gw/gh/FSzevYjSAU2xX
         e7vOXSpMX8buXiU//VhEa17aELMyYYOFJGF5QBvQySFHVfbFFVefrxUqJrmWh+BWCvKS
         NaCXYvd4c5nTZDVMRwcC0Dwo8MeFNAJTw5P74vR6eDfuuZuLonSMOBWlMduwSI2Y/0/D
         gAS/9gNJ3J5sTbq6w2UV0ac4vVcib1O+38fRhZoQGd2a4Q14Cq0NuWWKsptMW3nl/xVJ
         foRQ==
X-Gm-Message-State: AOAM531o25HFhWlZTGl4zEnHRubqzFOAg3LuSjVxnFdhX2q7ET+20AWv
        +XjakQHauOeEdivEEDiT+CQr/RsRNNjBNqqyVNy3HQ==
X-Google-Smtp-Source: ABdhPJyTYL9fMonnT8BhMIeFUlj9I+74ycMzbMV4QGm4w4YUVnU4ryM8D0bpDxgeFjGgDtTPf8nLKFJp+ICwr092XOM=
X-Received: by 2002:a19:750b:: with SMTP id y11mr3261168lfe.479.1612549653814;
 Fri, 05 Feb 2021 10:27:33 -0800 (PST)
MIME-Version: 1.0
References: <cover.1612534649.git.jpoimboe@redhat.com> <9583327904ebbbeda399eca9c56d6c7085ac20fe.1612534649.git.jpoimboe@redhat.com>
In-Reply-To: <9583327904ebbbeda399eca9c56d6c7085ac20fe.1612534649.git.jpoimboe@redhat.com>
From:   Ivan Babrou <ivan@cloudflare.com>
Date:   Fri, 5 Feb 2021 10:27:22 -0800
Message-ID: <CABWYdi0Dh7DJZGHX+1P-Huu=dBCwCxaf_WuyXmMLueVg9eomcA@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86/unwind/orc: Disable KASAN checking in the ORC
 unwinder, part 2
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, stable@vger.kernel.org,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 5, 2021 at 6:24 AM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>
> KASAN reserves "redzone" areas between stack frames in order to detect
> stack overruns.  A read or write to such an area triggers a KASAN
> "stack-out-of-bounds" BUG.
>
> Normally, the ORC unwinder stays in-bounds and doesn't access the
> redzone.  But sometimes it can't find ORC metadata for a given
> instruction.  This can happen for code which is missing ORC metadata, or
> for generated code.  In such cases, the unwinder attempts to fall back
> to frame pointers, as a best-effort type thing.
>
> This fallback often works, but when it doesn't, the unwinder can get
> confused and go off into the weeds into the KASAN redzone, triggering
> the aforementioned KASAN BUG.
>
> But in this case, the unwinder's confusion is actually harmless and
> working as designed.  It already has checks in place to prevent
> off-stack accesses, but those checks get short-circuited by the KASAN
> BUG.  And a BUG is a lot more disruptive than a harmless unwinder
> warning.
>
> Disable the KASAN checks by using READ_ONCE_NOCHECK() for all stack
> accesses.  This finishes the job started by commit 881125bfe65b
> ("x86/unwind: Disable KASAN checking in the ORC unwinder"), which only
> partially fixed the issue.
>
> Fixes: ee9f8fce9964 ("x86/unwind: Add the ORC unwinder")
> Reported-by: Ivan Babrou <ivan@cloudflare.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>

I haven't seen any previously observed issues with this after a day of uptime.

Tested-by: Ivan Babrou <ivan@cloudflare.com>
