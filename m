Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D06023DCB9
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 18:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729556AbgHFQz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 12:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729832AbgHFQzR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 12:55:17 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDEDC0A8898
        for <stable@vger.kernel.org>; Thu,  6 Aug 2020 07:47:07 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id y3so44274568wrl.4
        for <stable@vger.kernel.org>; Thu, 06 Aug 2020 07:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=03JEwr6ezb5WWFreHJCUvLbiyQ1gojnKvciKIU/PzlY=;
        b=iAkbtawshGBABEDnza01Bc07vMR2dTMuDCVjbvNB9SsvWpz1nmyNcoO/nYuUCLlXju
         dQJiPnlpGQ/lz52OCIg+ghEPWjSLvkCwXcBlkgOvgMe8NuUCImLG6OiwrSy6STi8kk6I
         UMkmEOidzvyUlV0xUQs6U1pVSc/bLc4FKHKrLBxF9OtKb+yYyFiV0+3BiKLpmRckGL/s
         ntz17M3ZGY58JKqs2t6ideE7gsLXW52iBg+ZmpjpD3jeeC2w+zR3bzPCBS7ytbeNT02u
         oW7bdS/L4YQb7opclFzUS4yCPcOzTy5WoscOkevzylfEIsfuZW2ylaudgTBEdaT2ym87
         UjoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=03JEwr6ezb5WWFreHJCUvLbiyQ1gojnKvciKIU/PzlY=;
        b=kbdb8FXShz9olL18rtfluQjvlJUpIYnLPDDDHIPXNVCiLVQRYFgG0qw97iPTCkR0LT
         +gtm2bIV7zjsVft6c+h+WGR/xzZ/yFbHK5mElggoukXIFKafkvKKEWWpTfaJ1npQ1Knw
         38+uKOFAR1hDBbusvo2F5XfM8uwtADDnbKHq70dQNTCk9WVUqcnsNlStuv7NlKG/VyUp
         4kMxZ7lGWESJmnFFxg5cc9024jAzfsP43NxXopOuvfaumPq1vB/ql+JyvWWqeX4j2W6t
         JFLKZ+yCSc4GnF+WTYkgOO5bBjF1w/TIzxnvjXVUImeqeGlGxK/rl/ZQhkB8txqw1RhY
         XOSQ==
X-Gm-Message-State: AOAM531BmD7rpWV5p2j1TBfJ6ZCtN2NoiLFRhlbLSgQWorsnpgHTE7go
        pN/Rf+0H9wm9I6k/SiOcrXngmoc3SxTgwkzvQlw=
X-Google-Smtp-Source: ABdhPJwZB8/4YFjZU9cfZAILMo9aXfSB/wrc/L3cR/+1BeQ/wibWpqbZPiHhL4sccFPPAr9mnwiYd/LxYxcgsPVjzjY=
X-Received: by 2002:a5d:494b:: with SMTP id r11mr8192850wrs.419.1596725220690;
 Thu, 06 Aug 2020 07:47:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200805215700.451808-1-alexander.deucher@amd.com>
 <20200806070103.GC2582961@kroah.com> <CADnq5_N0P8S5X4bqsavjNJ5KgZUKN=3cDrigiH=W8-3PiEv49w@mail.gmail.com>
 <20200806144435.GB2891564@kroah.com>
In-Reply-To: <20200806144435.GB2891564@kroah.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Thu, 6 Aug 2020 10:46:49 -0400
Message-ID: <CADnq5_MeCDbjn4zXwqr6RMhax0jYBWL7-jgWFaO4v=Zbdzp1TQ@mail.gmail.com>
Subject: Re: [PATCH] drm/amdgpu: fix ordering of psp suspend
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "for 3.8" <stable@vger.kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Huang Rui <ray.huang@amd.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 6, 2020 at 10:44 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Aug 06, 2020 at 09:42:51AM -0400, Alex Deucher wrote:
> > On Thu, Aug 6, 2020 at 7:10 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Wed, Aug 05, 2020 at 05:57:00PM -0400, Alex Deucher wrote:
> > > > The ordering of psp_tmr_terminate() and psp_asd_unload()
> > > > got reversed when the patches were applied to stable.
> > > >
> > > > Fixes: 22ff658396b446 ("drm/amdgpu: asd function needs to be unloaded in suspend phase")
> > > > Fixes: 2c41c968c6f648 ("drm/amdgpu: add TMR destory function for psp")
> > > > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > > > Cc: stable@vger.kernel.org # 5.7.x
> > > > Cc: Huang Rui <ray.huang@amd.com>
> > > > ---
> > > >  drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 8 ++++----
> > > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > >
> > > What is the git commit id of this patch in Linus's tree?
> >
> > It doesn't exist in Linus' tree.  The order is correct in 5.8 and
> > newer.  The order got reversed when the patches were applied to
> > stable.
>
> Than this needs to be explicitly called out and documented in the patch,
> otherwise we have no idea what is going on...

I'll respin and make it explicit.  thanks!

Alex
