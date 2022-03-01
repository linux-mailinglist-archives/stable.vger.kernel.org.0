Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 007F14C9474
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 20:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236998AbiCATjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 14:39:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236991AbiCATjL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 14:39:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1C26548D
        for <stable@vger.kernel.org>; Tue,  1 Mar 2022 11:38:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4453B81CF8
        for <stable@vger.kernel.org>; Tue,  1 Mar 2022 19:38:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9070C340EF;
        Tue,  1 Mar 2022 19:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646163505;
        bh=chohtoLcvrik+AzmJc/xGeOgYWd7+DzT6bAFHrzKJaU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dTuuf6gcEFRr0N5CG1O+x7TRRF5wABVAboiy7WsBTJHZNEomdD4Di7zFDWDP9kUZG
         BvciTxmxse1UsZ1sCiIlzE6BCHhk7/Ta0zCVOoam9WOFf+/CSIygWTQZJapAIEfx+5
         Efs0//h0k6d77ICn98PWNelDnhl4qxCnDotvYbHY=
Date:   Tue, 1 Mar 2022 20:38:21 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kai Lueke <kailueke@linux.microsoft.com>
Cc:     stable@vger.kernel.org
Subject: Re: xfrm regression in 5.10.94
Message-ID: <Yh52LSGjBz+yF/HO@kroah.com>
References: <e2e9e487-1efb-783f-ca5b-7d0c88f8de7b@linux.microsoft.com>
 <Yh0Db4AJA0QBZ3iN@kroah.com>
 <e8d57c20-56f8-f457-1db5-e6d5ed9618b6@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8d57c20-56f8-f457-1db5-e6d5ed9618b6@linux.microsoft.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 01, 2022 at 05:34:00PM +0100, Kai Lueke wrote:
> Hi,
> > Why is 5.10 special and newer kernels are not?  This change shows up for
> > them, right?  Either this is a regression for all kernel releases and
> > needs to be resolved, or it is ok for any kernel release.
> >
> > Please work with the networking developers to either resolve the
> > regression of determine what needs to be done here for userspace to work
> > properly.
> 
> I agree, thanks. I tried it
> (https://marc.info/?t=164607426900002&r=1&w=2) and got this response
> from Steffen Klassert now:
> 
> > In general I agree that the userspace ABI has to be stable, but
> > this never worked. We changed the behaviour from silently broken to
> > notify userspace about a misconfiguration.
> >
> > It is the question what is more annoying for the users. A bug that
> > we can never fix, or changing a broken behaviour to something that
> > tells you at least why it is not working.
> >
> > In such a case we should gauge what's the better solution. Here
> > I tend to keep it as it is.
> (https://marc.info/?l=linux-netdev&m=164615098503579&w=2)
> 
> Given it's unlikely to have this reverted in general I personally think
> that reverting for the LTS kernels makes sense at least...

Again, there is nothing "special" about LTS kernels for stuff like this.
It's fixing a bug that the kernel developers wanted to have fixed, and
so it gets backported everywhere relevant.

If I were to somehow "wait" on taking this, it's only delaying your
fixes from ever happening :)

thanks,

greg k-h
