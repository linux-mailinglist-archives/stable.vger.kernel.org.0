Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFB9265D69D
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbjADOzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:55:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236020AbjADOzi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:55:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8512A1EEC3;
        Wed,  4 Jan 2023 06:55:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3869CB8169D;
        Wed,  4 Jan 2023 14:55:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B76C433F0;
        Wed,  4 Jan 2023 14:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672844134;
        bh=zwF9T2z5L044ggy5j+5rYTatc9avuUbCH+Aw6bOhtFs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=szIP0Hr7BqLslgfZBQLFYOHb4HjlQ1udMsGC8m19ZnM0dkAO6sqNgCIJsYSoemi2x
         XvPOWn93w1b7RUKQ7aqoqhOIRBNemu8X9SwbtwVRX+Ig6ju9lCf7rdCMaSNf4/Jnyu
         n9BBVL+qOmeXJRkhKLlFLsoE/w9GKWKUGyYOr2D4=
Date:   Wed, 4 Jan 2023 15:48:11 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Dragos-Marian Panait <dragos.panait@windriver.com>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        David Zhou <David1.Zhou@amd.com>,
        amd-gfx@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [PATCH 4.19 1/1] drm/amdkfd: Check for null pointer after
 calling kmemdup
Message-ID: <Y7WRq7MaFaIJ2uGF@kroah.com>
References: <20230103184308.511448-1-dragos.panait@windriver.com>
 <20230103184308.511448-2-dragos.panait@windriver.com>
 <Y7Vz8mm0X+1h844b@kroah.com>
 <a8c6859f-5876-08cf-5949-ecf88e6bb528@amd.com>
 <CADnq5_Ons+yMyGxcSaFaOb5uNXooHgH_4N=ThHOGYaW9Pb_Q8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADnq5_Ons+yMyGxcSaFaOb5uNXooHgH_4N=ThHOGYaW9Pb_Q8A@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 04, 2023 at 09:35:03AM -0500, Alex Deucher wrote:
> On Wed, Jan 4, 2023 at 8:23 AM Christian König <christian.koenig@amd.com> wrote:
> >
> > Am 04.01.23 um 13:41 schrieb Greg KH:
> > > On Tue, Jan 03, 2023 at 08:43:08PM +0200, Dragos-Marian Panait wrote:
> > >> From: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> > >>
> > >> [ Upstream commit abfaf0eee97925905e742aa3b0b72e04a918fa9e ]
> > >>
> > >> As the possible failure of the allocation, kmemdup() may return NULL
> > >> pointer.
> > >> Therefore, it should be better to check the 'props2' in order to prevent
> > >> the dereference of NULL pointer.
> > >>
> > >> Fixes: 3a87177eb141 ("drm/amdkfd: Add topology support for dGPUs")
> > >> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> > >> Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
> > >> Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
> > >> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > >> Signed-off-by: Dragos-Marian Panait <dragos.panait@windriver.com>
> > >> ---
> > >>   drivers/gpu/drm/amd/amdkfd/kfd_crat.c | 3 +++
> > >>   1 file changed, 3 insertions(+)
> > > For obvious reasons, I can't take a patch for 4.19.y and not newer
> > > kernel releases, right?
> > >
> > > Please provide backports for all kernels if you really need to see this
> > > merged.  And note, it's not a real bug at all, and given that a CVE was
> > > allocated for it that makes me want to even more reject it to show the
> > > whole folly of that mess.
> >
> > Well as far as I can see this is nonsense to back port.
> >
> > The code in question is only used only once during driver load and then
> > never again, that exactly this allocation fails while tons of other are
> > made before and after is extremely unlikely.
> >
> > It's nice to have it fixed in newer kernels, but not worth a backport
> > and certainly not stuff for a CVE.
> 
> It's already fixed in Linus' tree:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=abfaf0eee97925905e742aa3b0b72e04a918fa9e

Yes, that's what the above commit shows...

confused,

greg k-h
