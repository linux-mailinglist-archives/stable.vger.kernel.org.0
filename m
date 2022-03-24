Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2494E64FF
	for <lists+stable@lfdr.de>; Thu, 24 Mar 2022 15:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242049AbiCXOXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 10:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234728AbiCXOXt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 10:23:49 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA1A11C0B
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 07:22:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 98D14CE2492
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 14:22:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD1CC340EC;
        Thu, 24 Mar 2022 14:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648131733;
        bh=t4cqoySkUqt0eR+s90nemgGM5m4kxBbm2CynR+bHwt4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vzmPs3zTwG4gYlPGCDpNdFiBY3G9D3jmnI6sy1Xd3uc7u0WBdAWb/xC2WyAhZZFUt
         rkC2LqAb7osCFqNqGzoUfXLiQlBzFHCxUivY17g82idzkSqROMvFBCKHoHzpURNYVl
         PD1lJAl1Dgazfl+OoLwGWEgKDgAaLFwtnNs1VtdE=
Date:   Thu, 24 Mar 2022 15:22:10 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vaibhav Rustagi <vaibhavrustagi@google.com>
Cc:     "# 3.4.x" <stable@vger.kernel.org>, steffen.klassert@secunet.com
Subject: Re: Cherry-pick request to fix CVE-2022-0886 in v5.10 and v5.4
Message-ID: <Yjx+klCGiAWDSu/i@kroah.com>
References: <CAMVonLjSP4cxtfahDORXG-b6K=ps+wN652hcrxgo70YU+eP5iA@mail.gmail.com>
 <YjmCh1SPUOJjM7Rf@kroah.com>
 <CAMVonLh6_puoNcOEU3XRHRf1Pa1iCjcQ1H8GGvbmTccHjys6vQ@mail.gmail.com>
 <CAMVonLjPRNMGHW10JOTS2LuEtQ3ZeoYzRTibPyeUg05Rq3pg8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMVonLjPRNMGHW10JOTS2LuEtQ3ZeoYzRTibPyeUg05Rq3pg8A@mail.gmail.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 22, 2022 at 01:42:50PM -0700, Vaibhav Rustagi wrote:
> On Tue, Mar 22, 2022 at 9:53 AM Vaibhav Rustagi
> <vaibhavrustagi@google.com> wrote:
> >
> > On Tue, Mar 22, 2022 at 2:04 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Mon, Mar 21, 2022 at 06:49:02PM -0700, Vaibhav Rustagi wrote:
> > > > Hi Greg,
> > > >
> > > > To fix CVE-2022-0886 in v5.10 and v5.4, we need to cherry-pick the
> > > > commit "esp: Fix possible buffer overflow in ESP transformation"
> > > > (ebe48d368e97d007bfeb76fcb065d6cfc4c96645). The commit didn't apply
> > > > cleanly in v5.10 and v5.4 and therefore, patches for both the kernel
> > > > versions are attached.
> > > >
> > > > In order to backport the original commit, following changes are done:
> > > >
> > > >  - v5.10:
> > > >     - "SKB_FRAG_PAGE_ORDER" declaration is moved from
> > > > "net/core/sock.c" to "include/net/sock.c"
> > >
> > > Did you see that this is already in the 5.10 queue and out for review
> > > right now?  Can you verify that the backport there matches yours?
> > >
> >
> > I was not aware that I could check that. Thanks for the hint.
> >
> > The change is not exactly identical. In addition to the change
> > mentioned in https://www.spinics.net/lists/stable/msg542796.html, I
> > have also removed following from "net/core/sock.c":
> >
> > -#define SKB_FRAG_PAGE_ORDER get_order(32768)
> >
> > This is done because "net/core/sock.c" includes "include/net/sock.h"
> > which defined the MACRO.
> >
> > > >  - v5.4:
> > > >     - "SKB_FRAG_PAGE_ORDER" declaration is moved from
> > > > "net/core/sock.c" to "include/net/sock.c"
> > > >     - Ignore changes introduced due to `xfrm: add support for UDPv6
> > > > encapsulation of ESP` in esp6_output_head()
> > >
> > > Thanks for this one, I'll queue it up after this next round of releases.
> > > What about 4.14 and 4.19?  Will this backport work there?  If not, can
> > > you provide a working one?
> > >
> >
> > I haven't tested the change in v4.14 and v4.19. I will check out those
> > trees and check whether the current patch will work or not.
> >
> 
> The changes for v4.14 and v4.19 are the same as what is sent for v5.4.
> However, the v5.4 patch didn't apply cleanly and I have attached
> patches for v4.14 (tested build on v4.14.272) and v4.19 (tested build
> on v4.19.235).

Thank you for all of these, all now queued up.

greg k-h
