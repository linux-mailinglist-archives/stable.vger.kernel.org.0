Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A36B3FC205
	for <lists+stable@lfdr.de>; Tue, 31 Aug 2021 06:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234726AbhHaEsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Aug 2021 00:48:00 -0400
Received: from mo1.intermailgate.com ([91.203.103.210]:48866 "EHLO
        mo1.intermailgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233580AbhHaEr7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Aug 2021 00:47:59 -0400
Received: from localhost (localhost [127.0.0.1])
        by mo1.intermailgate.com (Postfix) with ESMTP id 3F4D4809E9
        for <stable@vger.kernel.org>; Tue, 31 Aug 2021 06:47:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=bof.de; s=20180522;
        t=1630385222; bh=vQBdUiphtsfPgcBs1AS+zxaL3pEfW5kH2Eao5L+/iFI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc;
        b=cLUOMyYYn8QbGbvAxPPuZeQCptVn7RKGefwMVnosYucpnbmtIHAvkHiOvehZfzUM9
         gUnsv5zgdu3LzXsKbytl2LOL/c+5th2WePSQQMgAuvK64zy2Pa0mCACZ0qwbEli/fb
         4Bs309qMEimaoD/s2dE6luJe+wMSqoqCANDt3ooI=
Received: from mail-lf1-f49.google.com (unknown [162.158.183.176])
        by mo1.intermailgate.com (Postfix) with ESMTPSA id CF82780F1A
        for <stable@vger.kernel.org>; Tue, 31 Aug 2021 06:46:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=bof.de; s=20180522;
        t=1630385217; bh=vQBdUiphtsfPgcBs1AS+zxaL3pEfW5kH2Eao5L+/iFI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc;
        b=ZxinhJJ8hmfV9BJdQ6RgnXW2VXoPit68KuReBaRQmKXCyBohs4o1Za48sfmj2Gau1
         WDzL9/0XR17qNk/6hneM6XICFS2BO9vimdJuZjX9T1Vlt+ZrbedhTzBs1AuyS6Rif8
         Vrq64DFBNNoxmYuxMZyNLJhPcWx/ukfk4TZU3ACA=
Received: by mail-lf1-f49.google.com with SMTP id s10so10960791lfr.11
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 21:46:57 -0700 (PDT)
X-Gm-Message-State: AOAM531JQ6zy8Btv7lmluG3Snh/gDFjzAtWglywXkGwVZp7vqZ7exWYm
        jx5SKLwAMir7yCRjEMvGSzWRasqTBda34tsLUQQ=
X-Google-Smtp-Source: ABdhPJzVdkO4u/llKb099ZNjucQmxyXekgdRXv7+Fbjpmh0/kyTt2c4StQ3wVFzF6/ZHimiDdFS6iBysPMobUZZPwJc=
X-Received: by 2002:a05:6512:3188:: with SMTP id i8mr15909765lfe.209.1630385217206;
 Mon, 30 Aug 2021 21:46:57 -0700 (PDT)
MIME-Version: 1.0
References: <61018d93.xsvXcO161PFLQFCX%bof@bof.de> <YQGXyiMb1IntqacG@kroah.com>
In-Reply-To: <YQGXyiMb1IntqacG@kroah.com>
From:   Patrick Schaaf <bof@bof.de>
Date:   Tue, 31 Aug 2021 06:46:40 +0200
X-Gmail-Original-Message-ID: <CAJ26g5S2tbDhRbWkcgRzAu0eX=FNk00P8srboOSn=jYp4saALA@mail.gmail.com>
Message-ID: <CAJ26g5S2tbDhRbWkcgRzAu0eX=FNk00P8srboOSn=jYp4saALA@mail.gmail.com>
Subject: Re: stable 5.4.135 REGRESSION / once-a-day WARNING: at kthread_is_per_cpu+0x1c/0x20
To:     stable@vger.kernel.org
Cc:     regressions@lists.linux.dev, anubis@igorloncarevic.com,
        peterz@infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looking into this again.

Unfortunately, couldn't see how I would do bisection on the issue, as
it appears with that 5.4.118 commit implicated by the call stack,and
with tha tremoved,is obviously gone(that I tested, 5.4.135 with
b56ad4febe67b8c0647c0a3e427e935a76dedb59 reverted runs smoothly for
me, while the original 5.4.135 with that 5.4.118 time commit in, now
on a dozen machines, throws the WARNING.

I got email on the side of someone (Igor, on Cc) who sees the same
with DELL servers, a newer 5.10 kernel, for him running IPVS + he sees
actual operational impact there.

I just had a look at Linus mainlinetree, and see there is this
followup / further fix from Peter Zijlstra,
https://github.com/torvalds/linux/commit/3a7956e25e1d7b3c148569e78895e1f3178122a9
; now I'm much too incompetent to try and backport that, as it looks
more involved, but I imagine such a backport would be needed to fix
the WARNING (or IPVS breakage of Igor) we see.

best regards
  Patrick
