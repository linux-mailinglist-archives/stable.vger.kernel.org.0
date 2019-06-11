Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC5513D6FE
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 21:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404788AbfFKTjS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 15:39:18 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:38620 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407397AbfFKTjR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 15:39:17 -0400
Received: by mail-oi1-f193.google.com with SMTP id v186so9880280oie.5
        for <stable@vger.kernel.org>; Tue, 11 Jun 2019 12:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=St/sap2qBv8Hsq63+0Q5syfF0d0aWy8Ds6OuEFtVAXU=;
        b=BN7CXuFGuD00uiYGfneiP10UMR/4kb+NYdIMor783WtxbNUDdhf56ynR61aFXzwEBr
         P2VSfjHgsSok7ATwjpTgeT7GB7SFC98yaLc1hrQrArVYg8JqIF1q0vPbCpgAFHoTsFMP
         LJGIM0jkX7Dfqs0o3t8YUP1nQnCZHqGncNP4Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=St/sap2qBv8Hsq63+0Q5syfF0d0aWy8Ds6OuEFtVAXU=;
        b=YnxUwx3RwsS/hczlBXbHA5rcs/4fXKUjQWO+0XlYSbzTr1mzqgdfideNZiZN7ueEWO
         GLy7tr0zzxbWGZy2g3hAE7AO5gkk+OWjR3J4qTkver9TeOoyjDUaRWdjn2YzgusFzgP9
         320rz01N83nNh3ne8Qvf56G7qiHT+U8LsJ8fVgV6OPm31IZrQ4/G99zGU2R17xxyFI/K
         nTiWYjimp9h9x6FhtXIkT4qAE4Q1MdzJ3cNiVAuP408dG/a7bpWmWmRmhkf0tiDJkYTW
         LIUgVKreF1bzy4nIPWFOvCYJOz/Bjbahpn+KujlSXOZu+OVh0sc0LMXAfwBD5eG2e4pH
         vvig==
X-Gm-Message-State: APjAAAXFSTzE0gZTULcnyhM8fmpfQY9uq2Rbbt2ZWolm9VTgux2mQ8wM
        a3MeoQZUXUxYTlGQnMAo8uX54n8wmFgz5DqIEZ6o4A==
X-Google-Smtp-Source: APXvYqzFyhua/G0TG83q68hxIDjw3pEsY0N6defylPtbJFObhBAHHNNUILV9io7UDphgfrJUvIMjcZGuXtEd/sdRVoc=
X-Received: by 2002:aca:62c2:: with SMTP id w185mr17508454oib.110.1560281956544;
 Tue, 11 Jun 2019 12:39:16 -0700 (PDT)
MIME-Version: 1.0
References: <87k1dsjkdo.fsf@turtle.gmx.de> <20190611153656.GA5084@kroah.com>
 <CAKMK7uH_3P3pYkJ9Ua4hOFno5UiQ4p-rdWu9tPO75MxGCbyXSA@mail.gmail.com> <20190611174006.GB31662@kroah.com>
In-Reply-To: <20190611174006.GB31662@kroah.com>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue, 11 Jun 2019 21:39:05 +0200
Message-ID: <CAKMK7uGzBD4LzoOTrDoBNaqpPbaWkQ=_h0Q+uqJAsoeDbTnuWA@mail.gmail.com>
Subject: Re: Linux 5.1.9 build failure with CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT=n
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sven Joachim <svenjoac@gmx.de>, stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 11, 2019 at 7:40 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Jun 11, 2019 at 07:33:16PM +0200, Daniel Vetter wrote:
> > On Tue, Jun 11, 2019 at 5:37 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > > On Tue, Jun 11, 2019 at 03:56:35PM +0200, Sven Joachim wrote:
> > > > Commit 1e07d63749 ("drm/nouveau: add kconfig option to turn off nouveau
> > > > legacy contexts. (v3)") has caused a build failure for me when I
> > > > actually tried that option (CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT=n):
> > > >
> > > > ,----
> > > > | Kernel: arch/x86/boot/bzImage is ready  (#1)
> > > > |   Building modules, stage 2.
> > > > |   MODPOST 290 modules
> > > > | ERROR: "drm_legacy_mmap" [drivers/gpu/drm/nouveau/nouveau.ko] undefined!
> > > > | scripts/Makefile.modpost:91: recipe for target '__modpost' failed
> > > > `----
> >
> > Calling drm_legacy_mmap is definitely not a great idea. I think either
> > we need a custom patch to remove that out on older kernels, or maybe
> > even #ifdef if you want to be super paranoid about breaking stuff ...
> >
> > > > Upstream does not have that problem, as commit bed2dd8421 ("drm/ttm:
> > > > Quick-test mmap offset in ttm_bo_mmap()") has removed the use of
> > > > drm_legacy_mmap from nouveau_ttm.c.  Unfortunately that commit does not
> > > > apply in 5.1.9.
> > > >
> > > > Most likely 4.19.50 and 4.14.125 are also affected, I haven't tested
> > > > them yet.
> > >
> > > They probably are.
> > >
> > > Should I just revert this patch in the stable tree, or add some other
> > > patch (like the one pointed out here, which seems an odd patch for
> > > stable...)
> >
> > ... or backport the above patch, that should be save to do too. Not
> > sure what stable folks prefer?
>
> The above patch does not apply to all of the stable branches, so how
> about I just revert this?  People can live with this option not able to
> turn off for now, and if they really want it, they can use a newer
> kernel, right?

Lots of people can live with root holes in their kernels, it's still
not a great idea :-) Plan B would be to fix all the legacy ioctls and
close all the exploits in there, which absolutely no one wants to
spend time on. This way the only people who'll suffer are the ones
with horribly outdated userspace (and at that point who cares about a
few more exploits).

We should maybe update the help text to tell people they really
shouldn't enable this, the default y is really just to avoid
regression reports :-)
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
