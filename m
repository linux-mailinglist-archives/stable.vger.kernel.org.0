Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67BC560F692
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 13:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235440AbiJ0Lxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 07:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235425AbiJ0Lxo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 07:53:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6902BDDB51
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 04:53:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1858EB825E5
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 11:53:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72868C433D6;
        Thu, 27 Oct 2022 11:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666871616;
        bh=cUlBoydPjf7RCYrRBO7iZZTvtaLancq/hA8PQhTmWng=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tiZy1nH4kd0FSyXj8BDTkra9/qxgVuKgpT4GO86b3+TDLm6SXutHSy6Ctz2itwvYc
         40O5E5FTencUO+4sRcIHoTqw83d5yCcJO3BsYbgjCfRsURu7R8FMoLpkjAqLkS4nlW
         aiq5UV1kszkShomRTXXCYkswk340+8wOUc1t6fY4=
Date:   Thu, 27 Oct 2022 13:53:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     stable@vger.kernel.org
Subject: Re: backport of patches 8238b4579866b7c1bb99883cfe102a43db5506ff and
 d6ffe6067a54972564552ea45d320fb98db1ac5e
Message-ID: <Y1pxPsFAOVQf140J@kroah.com>
References: <alpine.LRH.2.02.2209301128030.23900@file01.intranet.prod.int.rdu2.redhat.com>
 <YzflXQMdGLsjPb70@kroah.com>
 <alpine.LRH.2.02.2210030459050.10514@file01.intranet.prod.int.rdu2.redhat.com>
 <Yz21dn2vJPOVOffr@kroah.com>
 <Y0Rtkk7hA4CBwp16@kroah.com>
 <alpine.LRH.2.02.2210110531260.30193@file01.intranet.prod.int.rdu2.redhat.com>
 <Y0U+UkLYiRzvgoF8@kroah.com>
 <alpine.LRH.2.02.2210180733360.5835@file01.intranet.prod.int.rdu2.redhat.com>
 <Y1lnzkSUjuH7acSf@kroah.com>
 <alpine.LRH.2.21.2210270733280.3240@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.21.2210270733280.3240@file01.intranet.prod.int.rdu2.redhat.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 27, 2022 at 07:45:52AM -0400, Mikulas Patocka wrote:
> 
> 
> On Wed, 26 Oct 2022, Greg KH wrote:
> 
> > On Tue, Oct 18, 2022 at 07:36:22AM -0400, Mikulas Patocka wrote:
> > > 
> > > 
> > > On Tue, 11 Oct 2022, Greg KH wrote:
> > > 
> > > > On Tue, Oct 11, 2022 at 05:48:26AM -0400, Mikulas Patocka wrote:
> > > > > 
> > > > > 
> > > > > On Mon, 10 Oct 2022, Greg KH wrote:
> > > > > 
> > > > > > Nope, these cause loads of breakages.  See
> > > > > > https://lore.kernel.org/r/09eca44e-4d91-a060-d48c-d0aa41ac5045@roeck-us.net
> > > > > > for one such example, and I know kbuild sent you other build problems.
> > > > > > I'll drop all of these from the stable trees now.  Please feel free to
> > > > > > resend them when you have the build issues worked out.
> > > > > > 
> > > > > > thanks,
> > > > > > 
> > > > > > greg k-h
> > > > > 
> > > > > I don't have cross compilers for all the architectures that Linux 
> > > > > supports. Is there some way how to have the patch compile-tested before I 
> > > > > send it to you?
> > > > 
> > > > You can download those compilers from kernel.org, they are all available
> > > > there.
> > > 
> > > OK. I downloaded cross compilers from 
> > > https://mirrors.edge.kernel.org/pub/tools/crosstool/ and compile-tested 
> > > the patches with all possible architectures.
> > > 
> > > Here I'm sending new versions.
> > 
> > But don't you need 2 patches, not just 1, to be applied?
> 
> Just one patch is sufficient.
> 
> The upstream patch 8238b4579866b7c1bb99883cfe102a43db5506ff fixes a bug 
> and the patch d6ffe6067a54972564552ea45d320fb98db1ac5e fixes compile 
> failures triggered by 8238b4579866b7c1bb99883cfe102a43db5506ff on some 
> architectures.
> 
> For simplicity of making and testing the stable branch patches I folded 
> these changes into just one patch - that fixes the bug and fixes compile 
> failures as well.

No, please do not do that.  We want both commits at once, not a "fixed
up" change, right?  Otherwise our tools will want to apply the second
one as it is insisting that a fix is still needed.

> > Please resend a set of series, one series per stable kernel branch, to
> > make it more obvious what to do.  Your thread here is very confusing.
> 
> I'll resend it, but except for the subject line I don't know what have I 
> done wrong.

Subject line is everything :)

As is the text in the body, I would have had to remove that from your
last one.  See the examples on the list for how to make this easy for us
to apply.

thanks,

greg k-h
