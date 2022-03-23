Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C44FF4E4D04
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 08:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241341AbiCWHDR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 03:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234794AbiCWHDP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 03:03:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC36186F1
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 00:01:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98E23615FF
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 07:01:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973D7C340E8;
        Wed, 23 Mar 2022 07:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648018906;
        bh=IzRr8RVMFPZ/ZmMBDyGreq5dE7rnsbOWYxadNDVXUFY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k2cXhugXbS3IVWD6EK4n/oLK27S0XcqQvdFFaK1b2Umd3ac0ys4F1Q/to+MDVGAXh
         qqwZcNIM5vhlS23Q7ZHe2F/pdhXPyulVyPv2/atwXcuGCxRI7/PTsgK2AbL9GVH9OS
         cPyvBffgf+YdSrlAyrM8jYpHQUf9bjNHQDxshsCM=
Date:   Wed, 23 Mar 2022 08:01:42 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vaibhav Rustagi <vaibhavrustagi@google.com>
Cc:     "# 3.4.x" <stable@vger.kernel.org>, steffen.klassert@secunet.com
Subject: Re: Cherry-pick request to fix CVE-2022-0886 in v5.10 and v5.4
Message-ID: <YjrF1nMHPzAuL2qq@kroah.com>
References: <CAMVonLjSP4cxtfahDORXG-b6K=ps+wN652hcrxgo70YU+eP5iA@mail.gmail.com>
 <YjmCh1SPUOJjM7Rf@kroah.com>
 <CAMVonLh6_puoNcOEU3XRHRf1Pa1iCjcQ1H8GGvbmTccHjys6vQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMVonLh6_puoNcOEU3XRHRf1Pa1iCjcQ1H8GGvbmTccHjys6vQ@mail.gmail.com>
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 22, 2022 at 09:53:09AM -0700, Vaibhav Rustagi wrote:
> On Tue, Mar 22, 2022 at 2:04 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, Mar 21, 2022 at 06:49:02PM -0700, Vaibhav Rustagi wrote:
> > > Hi Greg,
> > >
> > > To fix CVE-2022-0886 in v5.10 and v5.4, we need to cherry-pick the
> > > commit "esp: Fix possible buffer overflow in ESP transformation"
> > > (ebe48d368e97d007bfeb76fcb065d6cfc4c96645). The commit didn't apply
> > > cleanly in v5.10 and v5.4 and therefore, patches for both the kernel
> > > versions are attached.
> > >
> > > In order to backport the original commit, following changes are done:
> > >
> > >  - v5.10:
> > >     - "SKB_FRAG_PAGE_ORDER" declaration is moved from
> > > "net/core/sock.c" to "include/net/sock.c"
> >
> > Did you see that this is already in the 5.10 queue and out for review
> > right now?  Can you verify that the backport there matches yours?
> >
> 
> I was not aware that I could check that. Thanks for the hint.
> 
> The change is not exactly identical. In addition to the change
> mentioned in https://www.spinics.net/lists/stable/msg542796.html, I
> have also removed following from "net/core/sock.c":

Please use lore.kernel.org for mailing list links.

> 
> -#define SKB_FRAG_PAGE_ORDER get_order(32768)
> 
> This is done because "net/core/sock.c" includes "include/net/sock.h"
> which defined the MACRO.

So is the backport correct?  Or just different?

thanks,

greg k-h
