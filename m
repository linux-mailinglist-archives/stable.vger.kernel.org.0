Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C166869E885
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 20:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjBUTrq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 14:47:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjBUTrp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 14:47:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D37303CC;
        Tue, 21 Feb 2023 11:47:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEC7DB810A4;
        Tue, 21 Feb 2023 19:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C49C433D2;
        Tue, 21 Feb 2023 19:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677008861;
        bh=dFJujgGhJc0Dq/uIoVccF/BUH6VHAfRXVK8D80Q1u9o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BuXIklKN1RYioLhEdFwc1TLkN7Ze0a91qLkRJqC2nS0ajD6OOo3JVLcM1qjTTp+bR
         DEhU61Ly5DcqyH8zNJeFZEZCb1w8GVsQFdsw8zkGdtkaa6+pciB5Do01CqSRU7Yo9r
         AQvC6fxZQYUajmrA8G6qQkjXVuSA3qo7jVIXAF10=
Date:   Tue, 21 Feb 2023 20:47:38 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     KP Singh <kpsingh@kernel.org>
Cc:     linux-kernel@vger.kernel.org, pjt@google.com, evn@google.com,
        jpoimboe@kernel.org, tglx@linutronix.de, x86@kernel.org,
        hpa@zytor.com, peterz@infradead.org,
        pawan.kumar.gupta@linux.intel.com, kim.phillips@amd.com,
        alexandre.chartre@oracle.com, daniel.sneddon@linux.intel.com,
        corbet@lwn.net, bp@suse.de, linyujun809@huawei.com,
        jmattson@google.com,
        =?iso-8859-1?Q?Jos=E9?= Oliveira <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] x86/speculation: Allow enabling STIBP with legacy
 IBRS
Message-ID: <Y/Uf2lnU/VcsFs1O@kroah.com>
References: <20230221184908.2349578-1-kpsingh@kernel.org>
 <Y/UbqiHQ2/aczPzg@kroah.com>
 <CACYkzJ7pLhJ+NfUq36PaMxadkgv-cPtO60TW=g_Nh7vU1vEWqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACYkzJ7pLhJ+NfUq36PaMxadkgv-cPtO60TW=g_Nh7vU1vEWqA@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 21, 2023 at 11:35:29AM -0800, KP Singh wrote:
> On Tue, Feb 21, 2023 at 11:29 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Feb 21, 2023 at 07:49:07PM +0100, KP Singh wrote:
> > > Setting the IBRS bit implicitly enables STIBP to protect against
> > > cross-thread branch target injection. With enhanced IBRS, the bit it set
> > > once and is not cleared again. However, on CPUs with just legacy IBRS,
> > > IBRS bit set on user -> kernel and cleared on kernel -> user (a.k.a
> > > KERNEL_IBRS). Clearing this bit also disables the implicitly enabled
> > > STIBP, thus requiring some form of cross-thread protection in userspace.
> > >
> > > Enable STIBP, either opt-in via prctl or seccomp, or always on depending
> > > on the choice of mitigation selected via spectre_v2_user.
> > >
> > > Reported-by: José Oliveira <joseloliveira11@gmail.com>
> > > Reported-by: Rodrigo Branco <rodrigo@kernelhacking.com>
> > > Reviewed-by: Alexandra Sandulescu <aesa@google.com>
> > > Fixes: 7c693f54c873 ("x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: KP Singh <kpsingh@kernel.org>
> > > ---
> > >  arch/x86/kernel/cpu/bugs.c | 33 ++++++++++++++++++++++-----------
> > >  1 file changed, 22 insertions(+), 11 deletions(-)
> >
> > Why isn't patch 2/2 for stable as well?
> 
> It should be. I actually forgot to remove stable from the first one as
> there are still ongoing discussions and people kept having to "drop
> stable".  I can send a v3 with stable Cc'ed. Should it have a fixes
> tag too?

Why does anyone need to "drop stable" from a patch discussion?  That's
not a problem, we _WANT_ to see the patch review and discussion also
copied there to be aware of what is coming down the pipeline.  So
whomever said that is not correct, sorry.

And yes, a fixes: tag would be nice.

thanks,

greg k-h
