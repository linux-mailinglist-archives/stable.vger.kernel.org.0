Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3276A678B
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 07:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbjCAGJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 01:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCAGJz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 01:09:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A07CB30E98;
        Tue, 28 Feb 2023 22:09:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43D8D6121D;
        Wed,  1 Mar 2023 06:09:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A428C433EF;
        Wed,  1 Mar 2023 06:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677650993;
        bh=S1ZirGpI37xBGuZwi4BX7JFkx7eXgxT1V3RkaY3afKk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D7JOM68zhxfSKBWtz/aCqoWD8i7dWe1RxsqTzwVcIuojhiQIWnZ9QILCq91p9v1ok
         7KS86Cp6iQBxCIUFDlblXkUD7ODL77fZ6uAUuMCGVadjsDzMnMAELVFyE+gCEfH3l1
         qbapBlN2xe339A08LzZ+R4gFDIk7xNIaI+PeE+Xw=
Date:   Wed, 1 Mar 2023 07:09:49 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Slade Watkins <srw@sladewatkins.net>,
        Sasha Levin <sashal@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <Y/7sLcCtsk9oqZH0@kroah.com>
References: <Y/0U8tpNkgePu00M@sashalap>
 <Y/0i5pGYjrVw59Kk@gmail.com>
 <Y/0wMiOwoeLcFefc@sashalap>
 <Y/1LlA5WogOAPBNv@gmail.com>
 <Y/1em4ygHgSjIYau@sashalap>
 <Y/136zpJSWx96YEe@sol.localdomain>
 <CAOQ4uxietbePiWgw8aOZiZ+YT=5vYVdPH=ChnBkU_KCaHGv+1w@mail.gmail.com>
 <Y/3lV0P9h+FxmjyF@kroah.com>
 <8caf1c23-54e7-6357-29b0-4f7ddf8f16d2@sladewatkins.net>
 <Y/7fFHv3dU6osd6x@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/7fFHv3dU6osd6x@sol.localdomain>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 28, 2023 at 09:13:56PM -0800, Eric Biggers wrote:
> On Tue, Feb 28, 2023 at 09:05:16PM -0500, Slade Watkins wrote:
> > On 2/28/23 06:28, Greg KH wrote:
> > >> But just so you know, as a maintainer, you have the option to request that
> > >> patches to your subsystem will not be selected by AUTOSEL and run your
> > >> own process to select, test and submit fixes to stable trees.
> > > 
> > > Yes, and simply put, that's the answer for any subsystem or maintainer
> > > that does not want their patches picked using the AUTOSEL tool.
> > > 
> > > The problem that the AUTOSEL tool is solving is real, we have whole
> > > major subsystems where no patches are ever marked as "for stable" and so
> > > real bugfixes are never backported properly.
> > 
> > Yeah, I agree.
> > 
> > And I'm throwing this out here [after having time to think about it due to an
> > internet outage], but, would Cc'ing the patch's relevant subsystems on AUTOSEL
> > emails help? This was sort of mentioned in this email[1] from Eric, and I
> > think it _could_ help? I don't know, just something that crossed my mind earlier.
> > 
> 
> AFAICT, that's already being done now, which is good.  What I was talking about
> is that the subsystem lists aren't included on the *other* stable emails.  Most
> importantly, the "FAILED: patch failed to apply to stable tree" emails.

Why would the FAILED emails want to go to a mailing list?  If the people
that were part of making the patch don't want to respond to a FAILED
email, why would anyone on the mailing list?

But hey, I'll be glad to take a change to my script to add that
functionality if you want to make it, it's here:
	https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/scripts/bad_stable

thanks,

greg k-h
