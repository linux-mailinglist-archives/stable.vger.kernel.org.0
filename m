Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA2AE697DCA
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 14:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjBONt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 08:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBONt1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 08:49:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61934C38
        for <stable@vger.kernel.org>; Wed, 15 Feb 2023 05:49:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5677C61BD9
        for <stable@vger.kernel.org>; Wed, 15 Feb 2023 13:49:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64364C433EF;
        Wed, 15 Feb 2023 13:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676468965;
        bh=dUruGkeTszUTQK0VGmUIsyiYeg97pFXS/wTyHs07al8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uXf3X/6QwZu79hV/U//1WQmIb08Vheqb+UEYVbD/273KNFYUovMGauBQV2/pILLPc
         TEcLrX0ep3fl/o8KO/OGMWrnl0aNtxRNebVRbEvoIZmia+Hha80oy7dHsRp1EitbWQ
         wcJYSReSKg4lEsjr0hcisomym+sj5d/Q04PZ0E+Y=
Date:   Wed, 15 Feb 2023 14:49:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     Sumanth Korikkar <sumanthk@linux.ibm.com>, stable@vger.kernel.org,
        debian-s390@lists.debian.org, debian-kernel@lists.debian.org,
        svens@linux.ibm.com, gor@linux.ibm.com, Ulrich.Weigand@de.ibm.com,
        dipak.zope1@ibm.com
Subject: Re: [PATCH 0/1] s390: fix endless loop in do_signal
Message-ID: <Y+zi4mVr7JftBaXk@kroah.com>
References: <20230215120413.949348-1-sumanthk@linux.ibm.com>
 <Y+zcyBGnQ9BuLwFv@kroah.com>
 <Y+zfnNPp6SZ4lXxe@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+zfnNPp6SZ4lXxe@osiris>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 15, 2023 at 02:35:24PM +0100, Heiko Carstens wrote:
> On Wed, Feb 15, 2023 at 02:23:20PM +0100, Greg KH wrote:
> > On Wed, Feb 15, 2023 at 01:04:12PM +0100, Sumanth Korikkar wrote:
> > > Hi,
> > > 
> > > This patch fixes the issue for s390  stable kernel starting  5.10.162.
> > > The issue was specifically seen after stable version 5.10.162:
> > > Following commits can trigger it:
> > > 1. stable commit id - 788d0824269b ("io_uring: import 5.15-stable
> > > io_uring") can trigger this problem.
> > > 2. upstream commit id - 75309018a24d ("s390: add support for
> > > TIF_NOTIFY_SIGNAL")
> > > 
> > > Problem:
> > > qemu and user processes could stall when TIF_NOTIFY_SIGNAL is set from
> > > io_uring work.
> > > 
> > > Affected users:
> > > The issue was first raised by the debian team, where the s390
> > > bullseye build systems are affected.
> > > 
> > > Upstream commit Id:
> > > * The attached patch has no upstream commit. However, the stable kernel
> > > 5.10.162+ uses upstream commit id - 75309018a24d ("s390: add support for
> > > TIF_NOTIFY_SIGNAL"), which would need this fix
> > > * Starting from v5.12, there are s390 generic entry commits 
> > > 56e62a737028 ("s390: convert to generic entry")  and its relevant fixes,
> > > which are recommended and should address these problems.
> > 
> > I'm sorry, but I do not understand.  What exact commits should be added
> > to the 5.10.y tree to resolve this?
> 
> Only the patch sent by Sumanth as reply to this cover letter should be
> added to the 5.10.y tree.
> 
> The problem that is addressed here is that commit 75309018a24d ("s390: add
> support for TIF_NOTIFY_SIGNAL") was backported to 5.10. This commit is
> broken, but nobody noticed upstream, since shortly after s390 converted to
> generic entry with commit 56e62a737028 ("s390: convert to generic entry"),
> which implicitly fixed that.

Ok, then please say that in the changelog text.

thanks,

greg k-h
