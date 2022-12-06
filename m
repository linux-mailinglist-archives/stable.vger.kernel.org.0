Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63FE2644540
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 15:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234507AbiLFOBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 09:01:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231866AbiLFOBG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 09:01:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A7D3B1
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 06:01:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E35226173E
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 14:01:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC3F3C433D6;
        Tue,  6 Dec 2022 14:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670335264;
        bh=oJN4NBlB2mKCtqUEcv5as5QUBb3xRJ1jo9+5rxipJjY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WtZYv+/E+t4SdwO48ju7L9Hdy0gcOuJgdZeCvTFGkovXA4dSyQ+NousRhofHr93Qb
         Uv5dHwQNwTI/85RbhNK5TDzE94GwHlASvkm4Jm+Ahy2UI0PuIesSanr4GRqrgDP/vy
         AcRrot9EV0rUs+MSklReEH7CX+p99mh3JYeobGZDOmCWJpCCl0GtGLNslJKNP7+Ftj
         IsQO0AHW7ItHHepDXez2nK0sNxLPqXnyq12Xhnp2Kb37aQcnczy2DH3P6/fH4msJoN
         rRCYfSguZGtN7gWGphtu1nET3fWm2bZmY1Tzd/HIW0FClFVb/Bsh6Su8zoskq1DxrC
         NLqH00lTANGNw==
Date:   Tue, 6 Dec 2022 14:00:56 +0000
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
Message-ID: <Y49LGBGXI7lkc3N2@google.com>
References: <20221206124223.130619-1-lee@kernel.org>
 <Y486nm3MKxWlq+Bc@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y486nm3MKxWlq+Bc@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 06 Dec 2022, Greg KH wrote:

> On Tue, Dec 06, 2022 at 12:42:23PM +0000, Lee Jones wrote:
> > commit 152fe65f300e1819d59b80477d3e0999b4d5d7d2 upstream.
> > 
> > When enabled, KASAN enlarges function's stack-frames.  Pushing quite a few
> > over the current threshold.  This can mainly be seen on 32-bit
> > architectures where the present limit (when !GCC) is a lowly 1024-Bytes.
> > 
> > Link: https://lkml.kernel.org/r/20221125120750.3537134-3-lee@kernel.org
> > Signed-off-by: Lee Jones <lee@kernel.org>
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: Alex Deucher <alexander.deucher@amd.com>
> > Cc: "Christian König" <christian.koenig@amd.com>
> > Cc: Daniel Vetter <daniel@ffwll.ch>
> > Cc: David Airlie <airlied@gmail.com>
> > Cc: Harry Wentland <harry.wentland@amd.com>
> > Cc: Leo Li <sunpeng.li@amd.com>
> > Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > Cc: Maxime Ripard <mripard@kernel.org>
> > Cc: Nathan Chancellor <nathan@kernel.org>
> > Cc: Nick Desaulniers <ndesaulniers@google.com>
> > Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
> > Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
> > Cc: Thomas Zimmermann <tzimmermann@suse.de>
> > Cc: Tom Rix <trix@redhat.com>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > [Lee: Back-ported to linux-5.15.y]
> > Signed-off-by: Lee Jones <lee@kernel.org>
> 
> This is already in the -rc1 releases of 5.15 (and 5.10) that went out
> yesterday, right?
> 
> Or is that version not correct somehow?

Did you fix the back-port already?  I was working on the back of:

 FAILED: patch "[PATCH] Kconfig.debug: provide a little extra FRAME_WARN leeway when" failed to apply to 5.10-stable tree
 FAILED: patch "[PATCH] Kconfig.debug: provide a little extra FRAME_WARN leeway when" failed to apply to 5.15-stable tree

-- 
Lee Jones [李琼斯]
