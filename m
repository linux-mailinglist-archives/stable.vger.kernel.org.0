Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA801EE823
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 18:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729648AbgFDQAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jun 2020 12:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729630AbgFDQAk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jun 2020 12:00:40 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C27C08C5C2
        for <stable@vger.kernel.org>; Thu,  4 Jun 2020 09:00:40 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id j1so3284775pfe.4
        for <stable@vger.kernel.org>; Thu, 04 Jun 2020 09:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gSE6BdE4/VFzX3t/Cxitf0IUrhF90wQNUXw+URqjRrk=;
        b=mLy/HvzHev9qn2v1D69VG573ZlAmuwdGrUAVyFRAlQGYhXDAB4eRmdrAwXHU8suvZl
         vr1IG9/sDG1dSwSMCOeVIzqK9QUy6EZ0bxxEpLsnbPNzaP75fa/Q5Fv8/tWV7wSoqcI8
         pZcmZvYpvkkbnCEqDbzFQNJI61Y5loWolvvCs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gSE6BdE4/VFzX3t/Cxitf0IUrhF90wQNUXw+URqjRrk=;
        b=ZBT0SBx2H85sn6dkuqZa8Fu9LLgkQ6E4jPObSHXKNjZsDBsWsYb/I0vHbdgCQ8H911
         fziTvrrfA4e2WFeclP+CHfs2SPY5LoU2LOvCPT1INxkOuorI05lpqBgbaz4TEMogqlzE
         7lgIe3z/pfUe2XV7Qu6zcb0Fo/REAvLvxETPhRCM/vUs6OWbpYFemAEqtc8iPDMUbNcX
         UNk0Oij8dHZxMFwHih/MlHkKxDMEfGECtQYDdt4rzUOw9cNIbeLBgMaY9/GfTPwAsH+x
         mMGbA7f5bBu28UgPNUs4B2eO2tv62S8Kg0q56wVvBGrCxRXJYTvqymjV/dRHzjrKzocc
         9iQg==
X-Gm-Message-State: AOAM531FZ+bdEmihVmKVRziVmBx1X4XeUHMR2jD6323KkD0ZxApk4fun
        CC3HJpfUEBs1T9EF2SelX2Gfiw==
X-Google-Smtp-Source: ABdhPJwq+768JHUPs48Z0J9vaqFr0+IpTTbagVhAnL/NiO8TC7cwHwnRZXvfLQn2ETnbbnh0dzzl3w==
X-Received: by 2002:a63:5054:: with SMTP id q20mr5083098pgl.117.1591286439853;
        Thu, 04 Jun 2020 09:00:39 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w206sm5098711pfc.28.2020.06.04.09.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 09:00:38 -0700 (PDT)
Date:   Thu, 4 Jun 2020 09:00:37 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Potapenko <glider@google.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org, royyang@google.com,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] ovl: explicitly initialize error in ovl_copy_xattr()
Message-ID: <202006040858.3BF48FCF63@keescook>
References: <20200604084245.161480-1-glider@google.com>
 <CAJfpegv5W9BnCFGc2jWxCGS_RcqT0LFxw5ke2Z2XbCotokdUWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegv5W9BnCFGc2jWxCGS_RcqT0LFxw5ke2Z2XbCotokdUWw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 04, 2020 at 10:57:24AM +0200, Miklos Szeredi wrote:
> On Thu, Jun 4, 2020 at 10:43 AM <glider@google.com> wrote:
> >
> > Under certain circumstances (we found this out running Docker on a
> > Clang-built kernel with CONFIG_INIT_STACK_ALL) ovl_copy_xattr() may
> > return uninitialized value of |error| from ovl_copy_xattr().
> > It is then returned by ovl_create() to lookup_open(), which casts it to
> > an invalid dentry pointer, that can be further read or written by the
> > lookup_open() callers.
> >
> > The uninitialized value is returned when all the xattr on the file
> > are ovl_is_private_xattr(), which is actually a successful case,
> > therefore we initialize |error| with 0.
> >
> > Signed-off-by: Alexander Potapenko <glider@google.com>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Roy Yang <royyang@google.com>
> > Cc: <stable@vger.kernel.org> # 4.1
> >
> > ---
> >
> > The bug seem to date back to at least v4.1 where the annotation has been
> > introduced (i.e. the compilers started noticing error could be used
> > before being initialized). I hovever didn't try to prove that the
> > problem is actually reproducible on such ancient kernels. We've seen it
> > on a real machine running v4.4 as well.
> >
> > v2:
> >  -- Per Vivek Goyal's suggestion, changed |error| to be 0
> 
> Thanks, applied patch posted here (with your signed-off as well, since
> the patch is the same...):
> 
> https://lore.kernel.org/linux-unionfs/874ks212uj.fsf@m5Zedd9JOGzJrf0/

Can you please add:

Link: https://bugs.chromium.org/p/chromium/issues/detail?id=1050405
Fixes: e4ad29fa0d22 ("ovl: use a minimal buffer in ovl_copy_xattr")
Reviewed-by: Kees Cook <keescook@chromium.org>

(and adjust the CC field to drop the "# 4.1" so tools can figure it
out?)

Thanks!

-- 
Kees Cook
