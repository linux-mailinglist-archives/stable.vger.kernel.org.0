Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 342FD56163D
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 11:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234307AbiF3JWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 05:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234420AbiF3JVx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 05:21:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3653ED38;
        Thu, 30 Jun 2022 02:21:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C0B1B828D5;
        Thu, 30 Jun 2022 09:21:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91104C34115;
        Thu, 30 Jun 2022 09:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656580907;
        bh=axuitQjFtpwc+k2ohCqhScWs+9Cz5t084MKPFGznb+c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aH867f0opGEEwvZZc80T6go20+G3Yh9oIrKFPpp3jSGtJ7mDMa4ij5ZZ1EzrtivFu
         neRXvl2bQO3saPkwLg447zPLs+9XaBpMnYvfuPro0FCEUlL3+DOWmXlLPVS9cFV+QO
         qK8v8vef2QYquuGSp+QSqIMzaqHL4qyph7sxFJQY=
Date:   Thu, 30 Jun 2022 11:21:44 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Jessica Yu <jeyu@kernel.org>, Christoph Hellwig <hch@lst.de>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH 5.4 57/60] modpost: fix section mismatch check for
 exported init/exit sections
Message-ID: <Yr1rKDFBA70dbY3M@kroah.com>
References: <20220627111927.641837068@linuxfoundation.org>
 <20220627111929.368555413@linuxfoundation.org>
 <6cd16364-f0cd-b3f3-248f-4b6d585d05ef@gmail.com>
 <CAKwvOdm8UiY8CsqNgyoq4MdC2TbBj-1+cRE+fWZ9+vVBxNZz_Q@mail.gmail.com>
 <20220629053854.GA16297@lst.de>
 <CAKwvOd=S05LN=bDXcWpkpz1NG+C=M4Hd0HW0xcP_hrSsf8Mb9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOd=S05LN=bDXcWpkpz1NG+C=M4Hd0HW0xcP_hrSsf8Mb9Q@mail.gmail.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 29, 2022 at 09:59:25AM -0700, Nick Desaulniers wrote:
> On Tue, Jun 28, 2022 at 10:38 PM Christoph Hellwig <hch@lst.de> wrote:
> >
> > On Tue, Jun 28, 2022 at 12:11:50PM -0700, Nick Desaulniers wrote:
> > > Maybe let's check with Christoph if it's ok to backport bf22c9ec39da
> > > to stable 5.10 and 5.4?
> >
> > I'd be fine with that, but in the end it is something for the relevant
> > maintainers to decide.
> 
> $ ./scripts/get_maintainer.pl -f drivers/gpu/drm/drm_crtc_helper_internal.h
> Maarten Lankhorst <maarten.lankhorst@linux.intel.com> (maintainer:DRM
> DRIVERS AND MISC GPU PATCHES)
> Maxime Ripard <mripard@kernel.org> (maintainer:DRM DRIVERS AND MISC GPU PATCHES)
> Thomas Zimmermann <tzimmermann@suse.de> (maintainer:DRM DRIVERS AND
> MISC GPU PATCHES)
> David Airlie <airlied@linux.ie> (maintainer:DRM DRIVERS)
> Daniel Vetter <daniel@ffwll.ch> (maintainer:DRM DRIVERS)
> dri-devel@lists.freedesktop.org (open list:DRM DRIVERS)
> linux-kernel@vger.kernel.org (open list)
> 
> Maarten, Maxime, Thomas, David, or Daniel,
> Is it ok to backport
> commit bf22c9ec39da ("drm: remove drm_fb_helper_modinit")
> to 5.10.y and 5.4.y to fix the modpost warning reported by Florian in
> https://lore.kernel.org/stable/6cd16364-f0cd-b3f3-248f-4b6d585d05ef@gmail.com/ ?

I've queued this up now, thanks.

greg k-h
