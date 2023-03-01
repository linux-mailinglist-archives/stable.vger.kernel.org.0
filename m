Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34ACE6A6788
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 07:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjCAGGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 01:06:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjCAGGb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 01:06:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A283C3801E;
        Tue, 28 Feb 2023 22:06:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B9226121D;
        Wed,  1 Mar 2023 06:06:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3ADC433EF;
        Wed,  1 Mar 2023 06:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677650789;
        bh=v4ngIPWTmyKxBQ+mBH/MakzVx1o7ktoIPGmhZoIjVy4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AVaFzsEkBneyHwpqKBAkUEaTKoWCukX5hduEEK1YPynLFC/1khHLRDnTmaqNL6c8d
         2AXe7U+4sfFwRD5g+g0Cl/9NDe04f6Cdml1Ww9O07ijDktJjQ4niLHd0Xlx6jfFEaY
         UXUIPMnA2Ozx8GewEnMUrAo8n2bfZsvZC8JxnAR4=
Date:   Wed, 1 Mar 2023 07:06:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Slade Watkins <srw@sladewatkins.net>
Cc:     Sasha Levin <sashal@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <Y/7rYr92A2BNEyZ2@kroah.com>
References: <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <Y/0U8tpNkgePu00M@sashalap>
 <Y/0i5pGYjrVw59Kk@gmail.com>
 <Y/0wMiOwoeLcFefc@sashalap>
 <Y/1LlA5WogOAPBNv@gmail.com>
 <Y/1em4ygHgSjIYau@sashalap>
 <Y/136zpJSWx96YEe@sol.localdomain>
 <CAOQ4uxietbePiWgw8aOZiZ+YT=5vYVdPH=ChnBkU_KCaHGv+1w@mail.gmail.com>
 <Y/3lV0P9h+FxmjyF@kroah.com>
 <8caf1c23-54e7-6357-29b0-4f7ddf8f16d2@sladewatkins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8caf1c23-54e7-6357-29b0-4f7ddf8f16d2@sladewatkins.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 28, 2023 at 09:05:16PM -0500, Slade Watkins wrote:
> On 2/28/23 06:28, Greg KH wrote:
> >> But just so you know, as a maintainer, you have the option to request that
> >> patches to your subsystem will not be selected by AUTOSEL and run your
> >> own process to select, test and submit fixes to stable trees.
> > 
> > Yes, and simply put, that's the answer for any subsystem or maintainer
> > that does not want their patches picked using the AUTOSEL tool.
> > 
> > The problem that the AUTOSEL tool is solving is real, we have whole
> > major subsystems where no patches are ever marked as "for stable" and so
> > real bugfixes are never backported properly.
> 
> Yeah, I agree.
> 
> And I'm throwing this out here [after having time to think about it due to an
> internet outage], but, would Cc'ing the patch's relevant subsystems on AUTOSEL
> emails help? This was sort of mentioned in this email[1] from Eric, and I
> think it _could_ help? I don't know, just something that crossed my mind earlier.

I don't know, maybe?  Note that determining a patch's "subsystem" at
many times is difficult in an automated fashion, have any idea how to do
that reliably that doesn't just hit lkml all the time?

But again, how is that going to help much, the people who should be
saying "no" are the ones on the signed-off-by and cc: lines in the patch
itself.

thanks,

greg k-h
