Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A288300AB3
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 19:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729907AbhAVSA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729510AbhAVR0o (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jan 2021 12:26:44 -0500
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE83C061786
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 09:25:59 -0800 (PST)
Received: by mail-vs1-xe2e.google.com with SMTP id o19so3425942vsn.3
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 09:25:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qmG3ReoOA+nFPdXtaVvEXKSYJ1hlcICvB+O+sBZ8Rxs=;
        b=BPbc972+YUig5NQtxOSZg1EHCRcGGhpBv63PGBCsP3/QeXaDnBsC/61eMD37MX0uMN
         ZhmDjYDXz45huhioduettk9AW1GqVp0JBbK15z7BRc2ri7dbK9F+6g4UBens8NOAJm/V
         w48k13PY+LsADehsNNoI1EOXdrCmtQAA4E0HE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qmG3ReoOA+nFPdXtaVvEXKSYJ1hlcICvB+O+sBZ8Rxs=;
        b=qgcMkcSI3rLFYOK1XsGG08hqKEx2IMqh4L1B06Ioq9xP5yRotG9Q+4DDxRLMfjZSR4
         UZ4nGhXS5Wsoa53nM/8IhcmbreTHU/sCb2Yc6GT3zEj6F/dliqgH+hcjnSCBgAaPkimc
         zC9YoVIdFj18lewnrlclbHY8+NaLVaE3e0DFk4cWu/f0v3vyr2K3ZRYLtGZT2aM7a9cn
         jX1IKQ1+7fKyMBcvN148ApKeZsFrcWNViKqikwbay+LzY0K2az3z52CCuzHakQHzFXqE
         ongHj8hyWzS081Mexms0Df95hdjkD0pWurNaT2KkO64GEe05jBZfu8iRUd0hYFpZAR28
         FIdA==
X-Gm-Message-State: AOAM532mP/ZJXchugoTDeZZLGYDO6OeJWmbm2KSVT6n2SLBrvbFXYgJL
        djYoXY9ma3s0HjiHDwVXLS3Jzd4HFTAxeA==
X-Google-Smtp-Source: ABdhPJzpco/ZcrCWfAmQQwUtZGCeFbo8lZMyY4/uNK2k0hPVnjTXMR7y+FsPjVwkyjMaQg8h4RiXMg==
X-Received: by 2002:a67:cb1a:: with SMTP id b26mr295399vsl.22.1611336358191;
        Fri, 22 Jan 2021 09:25:58 -0800 (PST)
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com. [209.85.217.51])
        by smtp.gmail.com with ESMTPSA id g139sm1388518vke.18.2021.01.22.09.25.56
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jan 2021 09:25:56 -0800 (PST)
Received: by mail-vs1-f51.google.com with SMTP id p20so3409795vsq.7
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 09:25:56 -0800 (PST)
X-Received: by 2002:a67:ed09:: with SMTP id l9mr789858vsp.4.1611336356103;
 Fri, 22 Jan 2021 09:25:56 -0800 (PST)
MIME-Version: 1.0
References: <1611313556-4004-1-git-send-email-sumit.garg@linaro.org>
In-Reply-To: <1611313556-4004-1-git-send-email-sumit.garg@linaro.org>
From:   Doug Anderson <dianders@chromium.org>
Date:   Fri, 22 Jan 2021 09:25:44 -0800
X-Gmail-Original-Message-ID: <CAD=FV=V8HwhdhpCoiZx4XbTMWug0CAxhsnPR+5V9rB0W7QXFTQ@mail.gmail.com>
Message-ID: <CAD=FV=V8HwhdhpCoiZx4XbTMWug0CAxhsnPR+5V9rB0W7QXFTQ@mail.gmail.com>
Subject: Re: [PATCH v3] kdb: Make memory allocations more robust
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Fri, Jan 22, 2021 at 3:06 AM Sumit Garg <sumit.garg@linaro.org> wrote:
>
> Currently kdb uses in_interrupt() to determine whether its library
> code has been called from the kgdb trap handler or from a saner calling
> context such as driver init.  This approach is broken because
> in_interrupt() alone isn't able to determine kgdb trap handler entry from
> normal task context. This can happen during normal use of basic features
> such as breakpoints and can also be trivially reproduced using:
> echo g > /proc/sysrq-trigger

I guess an alternative to your patch is to fully eliminate GFP_KDB.
It always strikes me as a sub-optimal design to choose between
GFP_ATOMIC and GFP_KERNEL like this.  Presumably others must agree
because otherwise I'd expect that the overall kernel would have
something like "GFP_AUTOMATIC"?

It doesn't feel like it'd be that hard to do something more explicit.
From a quick glance:

* I think kdb_defcmd() and kdb_defcmd2() are always called in response
to a user typing something on the kdb command line.  Those should
always be GFP_ATOMIC, right?

* The one call that's not in kdb_defcmd() / kdb_defcmd2() is in
kdb_register_flags().  That can be called either during init time or
from kdb_defcmd2().  It doesn't seem like it'd be hard to rename
kdb_register_flags() to _kdb_register_flags() and add a "gfp_t flags"
to the end.  Then the exported kdb_register_flags() would pass
GFP_KERNEL and the call from kdb_defcmd2() would pass GFP_ATOMIC:


> We can improve this by adding check for in_dbg_master() instead which

s/adding check/adding a check/


> explicitly determines if we are running in debugger context.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> ---
>
> Changes in v3:
> - Refined commit description and Cc: stable@vger.kernel.org.
>
> Changes in v2:
> - Get rid of redundant in_atomic() check.
>
>  kernel/debug/kdb/kdb_private.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

I would leave it up to Daniel to say whether he agrees that a full
removal of "GFP_KDB" would be a better solution.  However, your patch
clearly improves the state of things, so:

Reviewed-by: Douglas Anderson <dianders@chromium.org>
