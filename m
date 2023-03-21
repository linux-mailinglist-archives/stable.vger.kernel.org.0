Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 138716C2B8F
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 08:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjCUHmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 03:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjCUHmx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 03:42:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B778D3B221
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 00:42:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 109FF619FC
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 07:41:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0979C433D2;
        Tue, 21 Mar 2023 07:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679384516;
        bh=S3VRznWfLjiX2cURb1ka41cuQW6iu8yamzLmbX5Ffvw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LbDVat/iaY44uLuqSki39bNGeFM+OX/Kz89uIko3CginJZv3xTvEcuJZmPPaOPsrt
         4oWvU6aZ/Aj55B1IVxrqE2dmAETcK5NCBCOL333o6AETUxfzRnPmmo+4P6bCdfAAcX
         /wNxDUU6AQhcQxI5tJLUv1Q2DAEqm46cV31msGh8=
Date:   Tue, 21 Mar 2023 08:41:53 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tom Saeger <tom.saeger@oracle.com>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Thomas Gleixner <tglx@linutronix.de>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 084/357] treewide: Replace DECLARE_TASKLET() with
 DECLARE_TASKLET_OLD()
Message-ID: <ZBlfwfpCPVy4lHE9@kroah.com>
References: <20230310133733.973883071@linuxfoundation.org>
 <20230310133737.692796889@linuxfoundation.org>
 <20230317182806.owvwdor6qpzp6tve@oracle.com>
 <ZBhek48t2C6QBUrp@kroah.com>
 <20230320164800.mtiol2cbrtr4jfsy@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230320164800.mtiol2cbrtr4jfsy@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 20, 2023 at 11:48:00AM -0500, Tom Saeger wrote:
> On Mon, Mar 20, 2023 at 02:24:35PM +0100, Greg Kroah-Hartman wrote:
> > On Fri, Mar 17, 2023 at 12:28:06PM -0600, Tom Saeger wrote:
> > > On Fri, Mar 10, 2023 at 02:36:13PM +0100, Greg Kroah-Hartman wrote:
> > > > From: Kees Cook <keescook@chromium.org>
> > > > 
> > > > [ Upstream commit b13fecb1c3a603c4b8e99b306fecf4f668c11b32 ]
> > > > 
> > > > This converts all the existing DECLARE_TASKLET() (and ...DISABLED)
> > > > macros with DECLARE_TASKLET_OLD() in preparation for refactoring the
> > > > tasklet callback type. All existing DECLARE_TASKLET() users had a "0"
> > > > data argument, it has been removed here as well.
> > > > 
> > > > Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > Acked-by: Thomas Gleixner <tglx@linutronix.de>
> > > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > > > Stable-dep-of: 1fdeb8b9f29d ("wifi: iwl3945: Add missing check for create_singlethread_workqueue")
> > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > ---
> > > 
> > > I noticed kernelci.org bot (5.4) reports:
> > > 
> > >     Build Failures Detected:
> > > 
> > >     mips:
> > >         ip27_defconfig: (gcc-10) FAIL
> > >         ip28_defconfig: (gcc-10) FAIL
> > >         lasat_defconfig: (gcc-10) FAIL
> > > 
> > >     Errors summary:
> > > 
> > >     1    arch/mips/lasat/picvue_proc.c:87:20: error: ‘pvc_display_tasklet’ undeclared (first use in this function)
> > >     1    arch/mips/lasat/picvue_proc.c:42:44: error: expected ‘)’ before ‘&’ token
> > >     1    arch/mips/lasat/picvue_proc.c:33:13: error: ‘pvc_display’ defined but not used [-Werror=unused-function]
> > > 
> > > Link: https://lore.kernel.org/stable/64041dda.170a0220.8cc25.79c9@mx.google.com/
> > > 
> > > Here's what I found...
> > > this backport to 5.4.y of:
> > > b13fecb1c3a6 ("treewide: Replace DECLARE_TASKLET() with DECLARE_TASKLET_OLD()")
> > > changed all locations of DECLARE_TASKLET with DECLARE_TASKLET_OLD,
> > > except one, in arch/mips/lasat/pcivue_proc.c.
> > > 
> > > This is due to:
> > > 10760dde9be3 ("MIPS: Remove support for LASAT") preceeding
> > > b13fecb1c3a6 ("treewide: Replace DECLARE_TASKLET() with DECLARE_TASKLET_OLD()")
> > > upstream and the former not being present in 5.4.y.
> > > 
> > > I rolled a revert/re-apply with fixes in the attached mbox,
> > > however maybe just a revert makes more sense?  Up to you.
> > > 
> > > I have yet to try building this on mips, just did this by inspection.
> > 
> > I've taken your patches, let's see how that works...
> > 
> 
> Ugh, It didn't go well.  I now see a problem.  The change to DECLARE_TASKLET_OLD also
> removed the last parameter.  I missed that.  I'll spin-up a mips build.

Ick, ok, let me go drop both of these patches from the tree and we can
try again the next round of releases...

thanks,

greg k-h
