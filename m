Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F50A49ADE0
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 09:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448656AbiAYISs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 03:18:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41062 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448662AbiAYIQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 03:16:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E124C61356;
        Tue, 25 Jan 2022 08:15:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5DDAC340E0;
        Tue, 25 Jan 2022 08:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643098559;
        bh=oOAVFFJCw0q0MIAnSxXXySpATKyLu18DMYIWW4/U0Mo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MixvZQEtJ/M3mWJGBEyVlcZYe2/ILADKZcFMcrfgVQk5Su0dKFZWKGP8rIaNJt5Ig
         b0/LoqDGEBvvgTGjH2G3PHbXDFHumtUptYwNo8PbyK741yAj7Zb3gB4NWz+mbgcDnH
         hqs0zGUGr2+toks7mSu1CybGouzpiZLgQgyk2cc3X+3d2s5CqrWApek2oQljYpLp6Y
         286Ssa9tn+VRq2szT/vFZfItyBkcztB8r1d9iyagt10ttDJpcvg4RjIrtb/T4mnKCB
         HLZ67A2ymtng7KwK7fnFz5ZuWNISFXE/nIWCDQoroXXnRgR1li49t/nd94zxbMihsZ
         42UqvS3WnDRjA==
Date:   Tue, 25 Jan 2022 09:15:51 +0100
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Akira Yokosawa <akiyks@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.16 0728/1039] scripts: sphinx-pre-install: Fix ctex
 support on Debian
Message-ID: <20220125091551.6a6faaf6@coco.lan>
In-Reply-To: <ba541d48-826c-3d39-b3e1-05642fa6edd6@gmail.com>
References: <20220124184125.121143506@linuxfoundation.org>
        <20220124184149.801920838@linuxfoundation.org>
        <ba541d48-826c-3d39-b3e1-05642fa6edd6@gmail.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Em Tue, 25 Jan 2022 07:48:39 +0900
Akira Yokosawa <akiyks@gmail.com> escreveu:

> Hi Greg,
> 
> On Mon, 24 Jan 2022 19:41:57 +0100,
> Greg Kroah-Hartman wrote:
> > From: Mauro Carvalho Chehab <mchehab@kernel.org>
> > 
> > [ Upstream commit 87d6576ddf8ac25f36597bc93ca17f6628289c16 ]
> > 
> > The name of the package with ctexhook.sty is different on
> > Debian/Ubuntu.
> > 
> > Reported-by: Akira Yokosawa <akiyks@gmail.com>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> > Tested-by: Akira Yokosawa <akiyks@gmail.com>
> > Link: https://lore.kernel.org/r/63882425609a2820fac78f5e94620abeb7ed5f6f.1641429634.git.mchehab@kernel.org
> > Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>  
> 
> This "Fix" is against upstream commit 7baab965896e ("scripts:
> sphinx-pre-install: add required ctex dependency") which is
> also new to v5.17-rc1.
> 
> So I don't think this is worth backporting to stable branches.

Well, either both patches should be backported or none, IMHO.
I guess I would just backport also commit 7baab965896e.

> 
>         Thanks, Akira
> 
> > ---
> >  scripts/sphinx-pre-install | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/scripts/sphinx-pre-install b/scripts/sphinx-pre-install
> > index 288e86a9d1e58..61a79ce705ccf 100755
> > --- a/scripts/sphinx-pre-install
> > +++ b/scripts/sphinx-pre-install
> > @@ -369,6 +369,9 @@ sub give_debian_hints()
> >  	);
> >  
> >  	if ($pdf) {
> > +		check_missing_file(["/usr/share/texlive/texmf-dist/tex/latex/ctex/ctexhook.sty"],
> > +				   "texlive-lang-chinese", 2);
> > +
> >  		check_missing_file(["/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"],
> >  				   "fonts-dejavu", 2);
> >    



Thanks,
Mauro
