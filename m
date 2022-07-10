Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1EB256CF44
	for <lists+stable@lfdr.de>; Sun, 10 Jul 2022 15:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiGJNXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jul 2022 09:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGJNXW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jul 2022 09:23:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E76412D18
        for <stable@vger.kernel.org>; Sun, 10 Jul 2022 06:23:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25A0861228
        for <stable@vger.kernel.org>; Sun, 10 Jul 2022 13:23:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261FDC3411E;
        Sun, 10 Jul 2022 13:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657459400;
        bh=E8diCNsgLQd7mgXPlOH9YJYO0Dmiu891KPdX6bsPspE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bg0Xnlrgef6b6idam0zNYJ8qKPmlMLwnQ2+gdW+6LCKyQbu8I9AbT6Fxd/9fchqMP
         +0/qZhki2UhF+zUPn2jmPwWh2Y3pLAKHHr7Gkh/y9aHGvcAfkgjYwdh+ifvju5mxu2
         hIxksVwFZQuErMeDlZqdv9pzEYsdSnkVKhW8LKLc=
Date:   Sun, 10 Jul 2022 15:23:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Grund <theflamefire89@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: [GIT 4.9] LSM,security,selinux,smack: Backport of LSM changes
Message-ID: <YsrSxQQB82eDdn0+@kroah.com>
References: <4230dd79-b64f-14e6-3614-02e4acb3f284@gmail.com>
 <YslxiluWV9YnPPAY@kroah.com>
 <81f96354-cbed-26e4-9f3f-5287095ccece@gmail.com>
 <YsqyxydY1kbufgng@kroah.com>
 <1c9e8498-0621-4466-bfbc-4f166c633727@gmail.com>
 <YsrKlIEV2ytKcWb8@kroah.com>
 <077a6d7d-e0a0-fab1-12df-871baa9be765@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <077a6d7d-e0a0-fab1-12df-871baa9be765@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 10, 2022 at 03:02:52PM +0200, Alexander Grund wrote:
> On 10.07.22 14:48, Greg KH wrote:
> >>> What 4.4.y Android devices are still supported by their vendors?  And
> >>> are they still getting kernel updates?
> >>
> >> Actually the issue is that those devices are not supported by their vendors anymore, so they may only get updates through LineageOS.
> >> That is a third-party Android build where maintainers rely on proprietary binaries from the original phone which are tied to a specific kernel.
> >> Hence when the device falls out of support having a 4.4 kernel in the last release there is no way for those maintainers to switch to a newer kernel.
> >> That's the situation e.g. I am in right now: Providing (mostly) security updates for a good phone that fell out of vendor support
> >> by using LineageOS for an updated Android system and e.g. the CIP maintained SLTS 4.4 kernel.
> >> And I know of at least 2 other devices using the same kernel as they share the platform.
> > 
> > All of those devices that wish to keep working should just forward port
> > their tree to newer kernel versions so that they can stay secure and
> > working properly.  It is far easier to do that than to attempt to keep
> > older kernel trees alive over time.  I've done both in the past and it's
> > always simpler to move forward.
> > 
> > So why not just do that instead of attempting to keep these old kernels
> > alive?  Do the effort once and then you can rely on the community's
> > help.  Otherwise you are stuck on your own for forever.
> 
> Because forward porting is not possible.
> As mentioned the original device vendor does no longer support those devices
> so what the community has is a blob of binaries compiled against a specific
> kernel version with no access to their sources.

That's a lovely GPL violation that I am sure those vendors would be glad
to fix up and provide the source for.  Especially if those vendors are
wanting to use newer kernel versions in newer devices :)

> As those binaries (mostly hardware "drivers") are required to use the device,
> recompilation isn't possible and they are likely coupled to the kernel version
> specific API/ABI "we" (me and maintainers of similar devices) have to stick to that kernel.

If you do not know what sources those blobs are built from, then trying
to keep a stable abi is very very difficult, as I know from experience.

Good luck!

greg k-h
