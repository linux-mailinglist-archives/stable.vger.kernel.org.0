Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C91BE58EF85
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 17:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbiHJPkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 11:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiHJPjw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 11:39:52 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D8F3F30E
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 08:39:51 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-10cf9f5b500so18253322fac.2
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 08:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=T5iFlRkzTf2S5T8gHCvMBh8iS91tkoQ3hnuZ6TY90IE=;
        b=m0melDDAlcIhGcnqRRYlP1NhqVmfC6M1vM8IAlivyyu3+Mc545409YjzdCOnbMTyHN
         18uCb4J3uZByB+Iqah8aadCWvLwdBmFwqZDQr1SyjQbk6LQn3ky8eiUhltikOKAmDtc8
         P3ho/W8jvbOkokslFiwNb6aHpJ43uFtFSAisBhWn4XtDmUe6v8wJlfHv1/uxxDlgpK2g
         W6BAO8SfB2+FAX2YIQGvYV4dbQZWUlB11Nt2wWH2WAdAkHC7QMXTbQ3RJADpvbCiSXER
         06X5bHXwHZaa7xm/ecAelSvuxYgA8SMVJAz2jOTzfEaCsBolTHm60CcZYVkiAk+HtK5f
         irMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=T5iFlRkzTf2S5T8gHCvMBh8iS91tkoQ3hnuZ6TY90IE=;
        b=pzl/I71R8oLu7Hr7vZxpb5y1+0hOqvRemYurPc95rn+wF5w0GeS1SDy/UkiJStsvIg
         6CMvbQ61OsowLhfs4tvIpuc2eR7c5MY6G6DB/WTSrmN5i/LbEeMZEEqNnIYnTa67nxJ/
         NZBu39aRk63Q9nbbDIBblha1/pKfWKUzz9b81Lh0SrVGznejlwU9vLk5aOjhezjhZ4A4
         Q4Pryr0P2kOStHwq9Awd2Bz95xeMx+Ww1E5HClct8rk5L7LkjL5MiAkbATuFzM6eJprJ
         oA2m4WzMtuBqeb2dRoQ/pB38cvRiNoL8NU89ZoCfnprY4Y0RVNdZqVJqYpHdDjudaqsm
         AzWQ==
X-Gm-Message-State: ACgBeo0vcRRGXWN+nSbvbjeZ4t/pCZBAOcSD23PY94gzbfd29OuhSCup
        zlDQose8SwNeG2a17OU+sqn75rcG57AKbEKR+C+Jut4m
X-Google-Smtp-Source: AA6agR7VCR8hXQkJPuNqsdtP9KLSdlVfNHBjLy7zdWODwrYixDgG9UbxA2Ow9IL2ghUFwhTt0I9ANHkhUudYSDOXKmE=
X-Received: by 2002:a05:6870:3398:b0:113:7f43:d0e9 with SMTP id
 w24-20020a056870339800b001137f43d0e9mr1662777oae.33.1660145990881; Wed, 10
 Aug 2022 08:39:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220719185659.2068735-1-alexander.deucher@amd.com>
 <CADnq5_MkB8xKHZxVsiXfWPA-QuVrrNCNXF=ScrYAPjNbAH36LA@mail.gmail.com> <YvPQ6MBF6V5FUEHF@kroah.com>
In-Reply-To: <YvPQ6MBF6V5FUEHF@kroah.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Wed, 10 Aug 2022 11:39:39 -0400
Message-ID: <CADnq5_OtXNALuQwsp-yShKxsyZTnfhheSuf9UqfRkbtm9GddiA@mail.gmail.com>
Subject: Re: [PATCH] drm/amdgpu: fix check in fbdev init
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Alex Deucher <alexander.deucher@amd.com>, stable@vger.kernel.org,
        hgoffin@amazon.com, amd-gfx@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 10, 2022 at 11:38 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Aug 10, 2022 at 11:28:18AM -0400, Alex Deucher wrote:
> > On Tue, Jul 19, 2022 at 2:57 PM Alex Deucher <alexander.deucher@amd.com> wrote:
> > >
> > > The new vkms virtual display code is atomic so there is
> > > no need to call drm_helper_disable_unused_functions()
> > > when it is enabled.  Doing so can result in a segfault.
> > > When the driver switched from the old virtual display code
> > > to the new atomic virtual display code, it was missed that
> > > we enable virtual display unconditionally under SR-IOV
> > > so the checks here missed that case.  Add the missing
> > > check for SR-IOV.
> > >
> > > There is no equivalent of this patch for Linus' tree
> > > because the relevant code no longer exists.  This patch
> > > is only relevant to kernels 5.15 and 5.16.
> > >
> > > Fixes: 84ec374bd580 ("drm/amdgpu: create amdgpu_vkms (v4)")
> > > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > > Cc: stable@vger.kernel.org # 5.15.x
> > > Cc: hgoffin@amazon.com
> >
> > Hi Greg,
> >
> > Is there any chance this can get applied?  It fixes a regression on
> > 5.15 and 5.16.
>
> Ah, missed this as it was not obvious that this was a not-upstream
> commit at all, sorry.
>
> I'll dig it out of lore.kernel.org and queue it up for the next round of
> releases, but note, this is our "busy time" with many patches marked for
> stable.
>
> Oh and 5.16 is long end-of-life, nothing anyone can do there, and no one
> should be using that kernel version anymore, so no issues there.

Thanks Greg.  Much appreciated.

Alex

>
> thanks,
>
> greg k-h
