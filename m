Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72B76644878
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 16:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbiLFP7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 10:59:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232865AbiLFP7g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 10:59:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3224324BF8
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 07:59:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3FF2617A0
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 15:59:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1DBC433D7;
        Tue,  6 Dec 2022 15:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670342345;
        bh=kacuhyz3ziYQX1LnXx2TjYZORnCn/oM/KSufZCqVgSM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R9eAzwEtW9wSu8XDHNKQarGYjDGrMp6dlW2+0TurYR6qXqpBemL+tC8tyUZSRnf4P
         5DSrid6QXgsEdV99Mun6uQr7DCPKn0QU2AdhQrR7jroV+4mmQQ5wM3fMb/x5tYOqrm
         XI9ETUIsMjNbQ7B31Efjeglb9Jn2B2Tye2rGed7I=
Date:   Tue, 6 Dec 2022 16:59:02 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee@kernel.org>
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
Message-ID: <Y49mxp1zIyrTlccF@kroah.com>
References: <20221206124223.130619-1-lee@kernel.org>
 <Y486nm3MKxWlq+Bc@kroah.com>
 <Y49LGBGXI7lkc3N2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y49LGBGXI7lkc3N2@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 06, 2022 at 02:00:56PM +0000, Lee Jones wrote:
> On Tue, 06 Dec 2022, Greg KH wrote:
> 
> > On Tue, Dec 06, 2022 at 12:42:23PM +0000, Lee Jones wrote:
> > > commit 152fe65f300e1819d59b80477d3e0999b4d5d7d2 upstream.
> > > 
> > > When enabled, KASAN enlarges function's stack-frames.  Pushing quite a few
> > > over the current threshold.  This can mainly be seen on 32-bit
> > > architectures where the present limit (when !GCC) is a lowly 1024-Bytes.
> > > 
> > > Link: https://lkml.kernel.org/r/20221125120750.3537134-3-lee@kernel.org
> > > Signed-off-by: Lee Jones <lee@kernel.org>
> > > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > > Cc: Alex Deucher <alexander.deucher@amd.com>
> > > Cc: "Christian König" <christian.koenig@amd.com>
> > > Cc: Daniel Vetter <daniel@ffwll.ch>
> > > Cc: David Airlie <airlied@gmail.com>
> > > Cc: Harry Wentland <harry.wentland@amd.com>
> > > Cc: Leo Li <sunpeng.li@amd.com>
> > > Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > > Cc: Maxime Ripard <mripard@kernel.org>
> > > Cc: Nathan Chancellor <nathan@kernel.org>
> > > Cc: Nick Desaulniers <ndesaulniers@google.com>
> > > Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
> > > Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
> > > Cc: Thomas Zimmermann <tzimmermann@suse.de>
> > > Cc: Tom Rix <trix@redhat.com>
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > [Lee: Back-ported to linux-5.15.y]
> > > Signed-off-by: Lee Jones <lee@kernel.org>
> > 
> > This is already in the -rc1 releases of 5.15 (and 5.10) that went out
> > yesterday, right?
> > 
> > Or is that version not correct somehow?
> 
> Did you fix the back-port already?  I was working on the back of:
> 
>  FAILED: patch "[PATCH] Kconfig.debug: provide a little extra FRAME_WARN leeway when" failed to apply to 5.10-stable tree
>  FAILED: patch "[PATCH] Kconfig.debug: provide a little extra FRAME_WARN leeway when" failed to apply to 5.15-stable tree

Sasha seems to have already fixed it, look at the -rc releases for the
backports.

thanks,

greg k-h
