Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E47926A580E
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 12:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbjB1L33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 06:29:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbjB1L32 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 06:29:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD80DBD8;
        Tue, 28 Feb 2023 03:29:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06FA3B80D40;
        Tue, 28 Feb 2023 11:28:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36047C433D2;
        Tue, 28 Feb 2023 11:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677583706;
        bh=fly9As6GdVCTUqgbpab6YGsoobdtJj0Pf4jduB5lum4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Za9T8pS4JY3UpLRtCY7ZTKND8MfxWnDRghK9ujx7+vDSbc3kuJkro9sZZvBUEIBlv
         BGdYxMZv2Mo7JceS30VE4b8ps3IeuElUHZOc/Ll8zQCQgdmg9HQByjdmnTgBojsf22
         FPGzYv9RajAbZN6tuA4tEepI0Brytz7QVM1Un0o0=
Date:   Tue, 28 Feb 2023 12:28:23 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <Y/3lV0P9h+FxmjyF@kroah.com>
References: <Y/y70zJj4kjOVfXa@sashalap>
 <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <Y/0U8tpNkgePu00M@sashalap>
 <Y/0i5pGYjrVw59Kk@gmail.com>
 <Y/0wMiOwoeLcFefc@sashalap>
 <Y/1LlA5WogOAPBNv@gmail.com>
 <Y/1em4ygHgSjIYau@sashalap>
 <Y/136zpJSWx96YEe@sol.localdomain>
 <CAOQ4uxietbePiWgw8aOZiZ+YT=5vYVdPH=ChnBkU_KCaHGv+1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxietbePiWgw8aOZiZ+YT=5vYVdPH=ChnBkU_KCaHGv+1w@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 28, 2023 at 12:41:07PM +0200, Amir Goldstein wrote:
> > > I'm not sure how feedback in the form of "this sucks but I'm sure it
> > > could be much better" is useful.
> >
> > I've already given you some specific suggestions.
> >
> > I can't force you to listen to them, of course.
> >
> 
> Eric,
> 
> As you probably know, this is not the first time that the subject of the
> AUTOSEL process has been discussed.
> Here is one example from fsdevel with a few other suggestions [1].
> 
> But just so you know, as a maintainer, you have the option to request that
> patches to your subsystem will not be selected by AUTOSEL and run your
> own process to select, test and submit fixes to stable trees.

Yes, and simply put, that's the answer for any subsystem or maintainer
that does not want their patches picked using the AUTOSEL tool.

The problem that the AUTOSEL tool is solving is real, we have whole
major subsystems where no patches are ever marked as "for stable" and so
real bugfixes are never backported properly.

In an ideal world, all maintainers would properly mark their patches for
stable backporting (as documented for the past 15+ years, with a cc:
stable tag, NOT a Fixes: tag), but we do not live in that world, and
hence, the need for the AUTOSEL work.

thanks,

greg k-h
