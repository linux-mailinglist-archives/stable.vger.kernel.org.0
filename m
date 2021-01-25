Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 532CB302323
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 10:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbhAYGUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 01:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbhAYGRf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 01:17:35 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 153C0C061573
        for <stable@vger.kernel.org>; Sun, 24 Jan 2021 22:16:21 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id p13so13926362ljg.2
        for <stable@vger.kernel.org>; Sun, 24 Jan 2021 22:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/zaG6O0v8k3VXbwAFUClbwHTRxDGN6NUvBuA7zlt2y8=;
        b=Baoc6XDiAIsHiBtZhPHGxJRsI9B1ko2O4aEdadE4rddBzeeyIo+g44RIKb854Ztsu6
         iusw3mCi9aw203TTlDC44xeCWljlllWqRC+tLT6t45DYIN6dR3Qxgy+uOO5Q3FF7dqlI
         4hL5uek98BeTdJfSbfyODFmXXpHcehE3aZaeGG4hz3Q/HX7O7In8JVlNtOzBQPy2Ds6r
         YG6CzAd7DcbicbR09vhE1bfjN7dZrG4S2VU7q2ivNX4WAjpAgrD/gfPTvGx+AssZnceO
         mNpwgw7FyDDedJ8onTWIynXCsnOR2KFANoBPMtgg20YrRURDKKUCDaccVHCZcpOmIjfW
         FOzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/zaG6O0v8k3VXbwAFUClbwHTRxDGN6NUvBuA7zlt2y8=;
        b=d9Bn1F0ZPr9mDA0J6JmPMr4ryWcHfgrVmuiFh0DaVrQHF+I8iWtssgsvbcuaVXgoSR
         xlE5gUodgdv/H70eoMoLV4gMWQnHXlH0K8+6+9p27pR/Xr+Z9hAaGfFwMjzcz6LA/LDu
         lNYCN9EPG8FrPPriMEOgtp6stCbBkUqTzOhppEtnj+nJaqgODmip5eGd03F0lo07Be5L
         Tedob4i6NC7a4bDYzkpDxyh1/uqQlunuXMSuxCDtVW9qL9cuwpT9aBnmfeSJHSbrpr3e
         0AfE85TmQNIERV/aFfuIRL+mrHE/2a8znmHlDdcFVbZZbmfQUgN5hNFD3ljrwQAJNhoZ
         +vGQ==
X-Gm-Message-State: AOAM531fHOLDhUBrCOzN53RIP/W2ueeZEG3/jq6PAnbn4+E12Ai9z77Q
        XCZMxM5/t0EeqG4dCQYm3lyxqRyhx5Ff/3AlgB5wsA==
X-Google-Smtp-Source: ABdhPJxU5eBGkVebQnOft5RGEvcNB2PFqwkcMvG25HAd6Fb6AYc+vtOp/pdjxyo5B44kXJXNss7vBBFgDun0A1I0s+k=
X-Received: by 2002:a2e:91d0:: with SMTP id u16mr781133ljg.480.1611555379260;
 Sun, 24 Jan 2021 22:16:19 -0800 (PST)
MIME-Version: 1.0
References: <1611313556-4004-1-git-send-email-sumit.garg@linaro.org> <CAD=FV=V8HwhdhpCoiZx4XbTMWug0CAxhsnPR+5V9rB0W7QXFTQ@mail.gmail.com>
In-Reply-To: <CAD=FV=V8HwhdhpCoiZx4XbTMWug0CAxhsnPR+5V9rB0W7QXFTQ@mail.gmail.com>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Mon, 25 Jan 2021 11:46:08 +0530
Message-ID: <CAFA6WYNyVhEzVstXCf1SDKkKGcfCdx6+LYpA5VLWtnaGsN=_7w@mail.gmail.com>
Subject: Re: [PATCH v3] kdb: Make memory allocations more robust
To:     Doug Anderson <dianders@chromium.org>
Cc:     kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks Doug for your comments.

On Fri, 22 Jan 2021 at 22:55, Doug Anderson <dianders@chromium.org> wrote:
>
> Hi,
>
> On Fri, Jan 22, 2021 at 3:06 AM Sumit Garg <sumit.garg@linaro.org> wrote:
> >
> > Currently kdb uses in_interrupt() to determine whether its library
> > code has been called from the kgdb trap handler or from a saner calling
> > context such as driver init.  This approach is broken because
> > in_interrupt() alone isn't able to determine kgdb trap handler entry from
> > normal task context. This can happen during normal use of basic features
> > such as breakpoints and can also be trivially reproduced using:
> > echo g > /proc/sysrq-trigger
>
> I guess an alternative to your patch is to fully eliminate GFP_KDB.
> It always strikes me as a sub-optimal design to choose between
> GFP_ATOMIC and GFP_KERNEL like this.  Presumably others must agree
> because otherwise I'd expect that the overall kernel would have
> something like "GFP_AUTOMATIC"?
>
> It doesn't feel like it'd be that hard to do something more explicit.
> From a quick glance:
>
> * I think kdb_defcmd() and kdb_defcmd2() are always called in response
> to a user typing something on the kdb command line.  Those should
> always be GFP_ATOMIC, right?
>
> * The one call that's not in kdb_defcmd() / kdb_defcmd2() is in
> kdb_register_flags().  That can be called either during init time or
> from kdb_defcmd2().  It doesn't seem like it'd be hard to rename
> kdb_register_flags() to _kdb_register_flags() and add a "gfp_t flags"
> to the end.  Then the exported kdb_register_flags() would pass
> GFP_KERNEL and the call from kdb_defcmd2() would pass GFP_ATOMIC:
>

Thanks for your suggestions. I agree with you that it's better to get
rid of GFP_KDB. But I think we need to backport this fix to stable
kernels as well, so IMO a minimal change like this would be better. I
will rather push a seperate code refactoring patch to incorporate your
suggestions.

>
> > We can improve this by adding check for in_dbg_master() instead which
>
> s/adding check/adding a check/
>

Ack. If we don't have any further comments, can this be incorporated
while applying this patch?

>
> > explicitly determines if we are running in debugger context.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> > ---
> >
> > Changes in v3:
> > - Refined commit description and Cc: stable@vger.kernel.org.
> >
> > Changes in v2:
> > - Get rid of redundant in_atomic() check.
> >
> >  kernel/debug/kdb/kdb_private.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
>
> I would leave it up to Daniel to say whether he agrees that a full
> removal of "GFP_KDB" would be a better solution.  However, your patch
> clearly improves the state of things, so:
>
> Reviewed-by: Douglas Anderson <dianders@chromium.org>

Thanks,
Sumit
