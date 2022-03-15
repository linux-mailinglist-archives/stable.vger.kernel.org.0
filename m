Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 869CE4D9B39
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 13:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239994AbiCOMbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 08:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237425AbiCOMa7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 08:30:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D622D53701;
        Tue, 15 Mar 2022 05:29:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85EF7B8122D;
        Tue, 15 Mar 2022 12:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4292C340ED;
        Tue, 15 Mar 2022 12:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647347385;
        bh=yu1IZzfDQbWy54cvNCINeIZqwhUe63idE+YJeXm73Og=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CapuCZmc1rLoomDXg3av9VkLre/R2z5lX0fJTda4v0qGKzMzg6oYxa2CZHmEw6dhH
         VGnWzMHRQ7Wf6Xklg0oTYY6S/vFvu9Q5yJlHrk3LCOVGQyVL6Vy7NebX3NpZqSW05K
         vF7Snkt4Ds/0fTMir4PXsuymBxWKEBj4YNXWoXlY=
Date:   Tue, 15 Mar 2022 13:29:40 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     James Morse <james.morse@arm.com>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 5.10 38/58] KVM: arm64: Allow indirect vectors to be used
 without SPECTRE_V3A
Message-ID: <YjCGtM8INuLORSNb@kroah.com>
References: <20220310140812.869208747@linuxfoundation.org>
 <20220310140813.956533242@linuxfoundation.org>
 <20220310234858.GB16308@amd>
 <YirvObKn0ADrEOk+@kroah.com>
 <ef538a31-5f73-dfc5-12a9-f5222514035c@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef538a31-5f73-dfc5-12a9-f5222514035c@arm.com>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 15, 2022 at 12:20:31PM +0000, James Morse wrote:
> Hi guys,
> 
> On 3/11/22 6:42 AM, Greg Kroah-Hartman wrote:
> > On Fri, Mar 11, 2022 at 12:48:59AM +0100, Pavel Machek wrote:
> > > What is going on here?
> > > 
> > > > commit 5bdf3437603d4af87f9c7f424b0c8aeed2420745 upstream.
> > > 
> > > Upstream commit 5bdf is very different from this. In particular,
> > > 
> > > >   arch/arm64/kvm/hyp/smccc_wa.S    |   66 +++++++++++++++++++++++++++++++++++++++
> > > 
> > > I can't find smccc_wa.S, neither in mainline, nor in -next. And it
> > > looks buggy. I suspect loop_k24 should loop 24 times, but it does 8
> > > loops AFAICT. Same problem with loop_k32.
> 
> Yup, that's a bug. Thanks for spotting it!
> I'll post a replacement for this patch.

That's going to be hard as this is now in a merged tree :(

Can you just send a fixup?

thanks,

greg k-h
