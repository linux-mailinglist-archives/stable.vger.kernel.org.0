Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB545680AB1
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 11:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbjA3KWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 05:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbjA3KWc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 05:22:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A44CB44B;
        Mon, 30 Jan 2023 02:22:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15A06B80EF0;
        Mon, 30 Jan 2023 10:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD55C433EF;
        Mon, 30 Jan 2023 10:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675074148;
        bh=l2jre3iHB3Bs/ZVbdIMxyNn0ZCbV0x1+gKltjmDsJhU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RovmwEzX/oA70hh2nVs3iLRzg9vlO8H6cKlzZ0XyCOZJ5HLhXY69du2oQonxfYcwZ
         kZLqBWajvD4badsCKgVhdvZZsLAKXp7+7qpDp3bCYV/WnBgKELTCQogzAPPKOSczfm
         7Zh7N3yV5C0Ty5ShBu6nDO7NJ+/nM9b6L+pfqxRA=
Date:   Mon, 30 Jan 2023 11:22:25 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     stable@vger.kernel.org, Chun-Tse Shao <ctshao@google.com>,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH 5.15.y] kbuild: Allow kernel installation packaging to
 override pkg-config
Message-ID: <Y9eaYcJl52ub5dAl@kroah.com>
References: <20230113002149.3984494-1-swboyd@chromium.org>
 <Y8Ky1UgT2yxFB2EB@kroah.com>
 <CAE-0n52wiAiHACFXeki6w7hfn3swuUp6jK6gpFvPxfrnmcV0TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE-0n52wiAiHACFXeki6w7hfn3swuUp6jK6gpFvPxfrnmcV0TQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 17, 2023 at 12:09:29PM -0800, Stephen Boyd wrote:
> Quoting Greg KH (2023-01-14 05:49:09)
> > On Thu, Jan 12, 2023 at 04:21:49PM -0800, Stephen Boyd wrote:
> > > From: Chun-Tse Shao <ctshao@google.com>
> > >
> > > commit d5ea4fece4508bf8e72b659cd22fa4840d8d61e5 upstream.
> > >
> > > Add HOSTPKG_CONFIG to allow tooling that builds the kernel to override
> > > what pkg-config and parameters are used.
> > >
> > > Signed-off-by: Chun-Tse Shao <ctshao@google.com>
> > > Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> > > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> > > [swboyd@chromium.org: Drop certs/Makefile hunk that doesn't
> > > apply because pkg-config isn't used there, add dtc/Makefile hunk to
> > > fix dtb builds]
> > > Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> > > ---
> > >
> > > I need this to properly compile 5.15.y stable kernels in the chromeos
> > > build system.
> >
> > Is this a new issue?  A regression?  This feels odd to add a new build
> > feature to an old kernel when nothing changed to require it other than
> > an external tool suddenly requiring something new?
> >
> 
> The chromeos build system checks for pkg-config being called directly
> and fails the build if the proper wrapper isn't used. We set
> HOSTPKG_CONFIG in the environment when building the kernel so that it
> doesn't fail.
> 
> It's not exactly a new issue, but a self-inflicted one that makes
> building the stable kernel annoying. I figured it was similar to fixing
> problems with compiling stable kernels with newer toolchains, but if it
> feels odd then I'll just have to remember to pick this patch whenever
> bisecting stable trees. No worries.

Now queued up, thanks.

greg k-h
