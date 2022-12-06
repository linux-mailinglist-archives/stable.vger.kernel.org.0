Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6E4644907
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 17:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbiLFQSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 11:18:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235237AbiLFQRg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 11:17:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56CC631218
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 08:14:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C274CB81A10
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 16:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6F8C433D6;
        Tue,  6 Dec 2022 16:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670343238;
        bh=zFQdlNPF3yxmtoyqWroscHPfc0GK1Di7opY8yB0nhy0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nsJqkbTG2GXb0xTNW/U+UsneAd+hKURfTgzsNjDdqWwXFX76dEmLo7EWaP2oJVgqJ
         jPC7/zmxhsbL/D7rMjlhUhV66XVmZnbRW7lNzkGsKPtV9RF73NOnzJVWWaomW+uWyX
         u+USjwsgXk6JvhohA0g2UGw9iJP4Aebw/XiM0oAQgJLE0WdcDfoFmBxktPF6PtlBHq
         noUcHvHqRVRtMG8L2G1RRd3vinrdLX4lFNW2wt+A9ilRiB+CHdm6pdWBDDU4MQnszY
         56Z5ebibP6NzC0UaKOtZpxqNGms2tEWHYOR64Jpnu6Qfeb89kI/RFFQA5FU618Xpuo
         9ORMvQGwcEBDQ==
Date:   Tue, 6 Dec 2022 16:13:50 +0000
From:   Lee Jones <lee@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@gmail.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Tom Rix <trix@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5.15 1/1] Kconfig.debug: provide a little extra
 FRAME_WARN leeway when KASAN is enabled
Message-ID: <Y49qPgCQ+7iro+ev@google.com>
References: <20221206124223.130619-1-lee@kernel.org>
 <Y486nm3MKxWlq+Bc@kroah.com>
 <Y49LGBGXI7lkc3N2@google.com>
 <Y49mxp1zIyrTlccF@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y49mxp1zIyrTlccF@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 06 Dec 2022, Greg KH wrote:

> On Tue, Dec 06, 2022 at 02:00:56PM +0000, Lee Jones wrote:
> > On Tue, 06 Dec 2022, Greg KH wrote:
> > 
> > > On Tue, Dec 06, 2022 at 12:42:23PM +0000, Lee Jones wrote:
> > > > commit 152fe65f300e1819d59b80477d3e0999b4d5d7d2 upstream.
> > > > 
> > > > When enabled, KASAN enlarges function's stack-frames.  Pushing quite a few
> > > > over the current threshold.  This can mainly be seen on 32-bit
> > > > architectures where the present limit (when !GCC) is a lowly 1024-Bytes.
> > > > 
> > > > Link: https://lkml.kernel.org/r/20221125120750.3537134-3-lee@kernel.org
> > > > Signed-off-by: Lee Jones <lee@kernel.org>
> > > > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > > > Cc: Alex Deucher <alexander.deucher@amd.com>
> > > > Cc: "Christian König" <christian.koenig@amd.com>
> > > > Cc: Daniel Vetter <daniel@ffwll.ch>
> > > > Cc: David Airlie <airlied@gmail.com>
> > > > Cc: Harry Wentland <harry.wentland@amd.com>
> > > > Cc: Leo Li <sunpeng.li@amd.com>
> > > > Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > > > Cc: Maxime Ripard <mripard@kernel.org>
> > > > Cc: Nathan Chancellor <nathan@kernel.org>
> > > > Cc: Nick Desaulniers <ndesaulniers@google.com>
> > > > Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
> > > > Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
> > > > Cc: Thomas Zimmermann <tzimmermann@suse.de>
> > > > Cc: Tom Rix <trix@redhat.com>
> > > > Cc: <stable@vger.kernel.org>
> > > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > > [Lee: Back-ported to linux-5.15.y]
> > > > Signed-off-by: Lee Jones <lee@kernel.org>
> > > 
> > > This is already in the -rc1 releases of 5.15 (and 5.10) that went out
> > > yesterday, right?
> > > 
> > > Or is that version not correct somehow?
> > 
> > Did you fix the back-port already?  I was working on the back of:
> > 
> >  FAILED: patch "[PATCH] Kconfig.debug: provide a little extra FRAME_WARN leeway when" failed to apply to 5.10-stable tree
> >  FAILED: patch "[PATCH] Kconfig.debug: provide a little extra FRAME_WARN leeway when" failed to apply to 5.15-stable tree
> 
> Sasha seems to have already fixed it, look at the -rc releases for the
> backports.

Works for me.  Thank you Sasha.

-- 
Lee Jones [李琼斯]
