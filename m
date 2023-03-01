Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38FAD6A67EF
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 08:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjCAHF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 02:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjCAHF6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 02:05:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED1236FEC;
        Tue, 28 Feb 2023 23:05:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CAAB61234;
        Wed,  1 Mar 2023 07:05:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5701C433EF;
        Wed,  1 Mar 2023 07:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677654356;
        bh=U20fHsgDBwYWBqlRAoN9Rw5KpY0JsVFD3imwT1PLO5E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ErHxEQvlVmd65N8KaKxYpyFQleh2D9NQXQFL1qCAGqfEiaEYvDvuKZdjzDU23FZHM
         pDm1yqrWNupLVB99IZAF4AKcCystid8PL2SvVMpEtP/GmoObC6j2eZejhT62KjCoNa
         xYICkwfoV+5fJOFVyW/5iJER9fmG6kgMXTjWzqO2PyV+/iTIYX2no6bCgyn3/jOaV3
         YNGslpfLwSB+p+nLwXY2sxtgS4TcVoPwV1xCctYbKMkWu5biAG+D5tjxXYJxdyPadi
         ZhFaWJFMlZvJ4Ju/hHfTRStHtUi/+K0TBQgK3AgLr5Zr8DLv0CbU2i8id7dfL3b5Zl
         75TWAEj5T6wwA==
Date:   Tue, 28 Feb 2023 23:05:54 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Slade Watkins <srw@sladewatkins.net>,
        Sasha Levin <sashal@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <Y/75Ut/OgYabIm9p@sol.localdomain>
References: <Y/0U8tpNkgePu00M@sashalap>
 <Y/0i5pGYjrVw59Kk@gmail.com>
 <Y/0wMiOwoeLcFefc@sashalap>
 <Y/1LlA5WogOAPBNv@gmail.com>
 <Y/1em4ygHgSjIYau@sashalap>
 <Y/136zpJSWx96YEe@sol.localdomain>
 <CAOQ4uxietbePiWgw8aOZiZ+YT=5vYVdPH=ChnBkU_KCaHGv+1w@mail.gmail.com>
 <Y/3lV0P9h+FxmjyF@kroah.com>
 <8caf1c23-54e7-6357-29b0-4f7ddf8f16d2@sladewatkins.net>
 <Y/7rYr92A2BNEyZ2@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/7rYr92A2BNEyZ2@kroah.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 01, 2023 at 07:06:26AM +0100, Greg KH wrote:
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
> 
> I don't know, maybe?  Note that determining a patch's "subsystem" at
> many times is difficult in an automated fashion, have any idea how to do
> that reliably that doesn't just hit lkml all the time?

As I said, it seems Sasha already does this for AUTOSEL (but not other stable
emails).  I assume he uses either get_maintainer.pl, or the lists the original
patch is sent to (retrievable from lore).  This is *not* a hard problem.

> But again, how is that going to help much, the people who should be
> saying "no" are the ones on the signed-off-by and cc: lines in the patch
> itself.

So that if one person does not respond, other people can help.

You're basically arguing that mailing lists shouldn't exist at all...

- Eric
