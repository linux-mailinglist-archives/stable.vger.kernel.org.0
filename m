Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7A621800EC
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 16:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgCJPAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 11:00:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:40060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726295AbgCJPAV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 11:00:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A2F220675;
        Tue, 10 Mar 2020 15:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583852420;
        bh=ZpRiK700ytCqOtThoOQJp9K5Om8yOMIGQvUgGlknOZ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1C655yRsms1Qq+UvfBiB5mm2hrYmJDHBSPY3JffYYQzCowUUdIKQa5bOhgrVDSg1q
         jCt854OfLwWcqzqVcs5J+MQcx9W4QGUEyWtPxcQ5fSUimduPhMsJus+HB0cggRMWoi
         ynC1msnNu1AZS1uRYgPsqrTRs+/rPitMajSjQquM=
Date:   Tue, 10 Mar 2020 16:00:18 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>
Cc:     linux-kernel@vger.kernel.org, linux@roeck-us.net, shuah@kernel.org,
        stable@vger.kernel.org, Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCH 5.4 000/168] 5.4.25-stable review
Message-ID: <20200310150018.GA3422873@kroah.com>
References: <20200310123635.322799692@linuxfoundation.org>
 <d97347d3-4eea-f5e1-8a3c-a12410e9ad5f@applied-asynchrony.com>
 <20200310143527.GB3376131@kroah.com>
 <daf30758-fe28-0709-7908-91bb99ee5e39@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <daf30758-fe28-0709-7908-91bb99ee5e39@applied-asynchrony.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 03:51:01PM +0100, Holger Hoffstätte wrote:
> On 3/10/20 3:35 PM, Greg Kroah-Hartman wrote:
> > On Tue, Mar 10, 2020 at 03:02:37PM +0100, Holger Hoffstätte wrote:
> > > On 3/10/20 1:37 PM, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 5.4.25 release.
> > > 
> > > This fails to compile due to broken patch 001/168:
> > > "block, bfq: get a ref to a group when adding it to a service tree":
> > > 
> > > ..
> > > block/bfq-wf2q.c: In function 'bfq_get_entity':
> > > ./include/linux/kernel.h:994:51: error: 'struct bfq_group' has no member named 'entity'
> > > ..
> > > 
> > > The calls to bfq_get_entity::bfqg_and_blkg_get and bfq_forget_entity::bfqg_and_blkg_put
> > > in bfq-wf2q.c need to be wrapped in #ifdef CONFIG_BFQ_GROUP_IOSCHED, otherwise
> > > the build will fail when CONFIG_BFQ_GROUP_IOSCHED is not enabled.
> > > This horribly error-prone #ifdef mess was finally removed in upstream commit
> > > 4d8340d0d4d9. For 5.4 we'll either need that as well or add them back.
> > 
> > Ick, that's a mess.
> > 
> > I'll go drop that patch now, odd that it passed my build tests...
> 
> Uh, please no? It fixes a rather nasty UAF when cgroups are in use.
> Please just add the other upstream commit as well, I confirmed it applies
> cleanly and fixes the problem.

I didn't get that from your email at all, sorry.

So, what commits, and in what order, should be applied to 5.4.y at the
moment to resolve this issue?

thanks,

greg k-h
