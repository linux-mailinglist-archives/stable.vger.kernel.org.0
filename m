Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF7C937F507
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 11:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbhEMJtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 05:49:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230338AbhEMJth (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 05:49:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9FC1613D6;
        Thu, 13 May 2021 09:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620899308;
        bh=ZdufSwHQhI6UqGmsnop72bTBK3b9KB9yklyAwI+MobQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PtIs6Vd3YiZ3ikcQVWaY1c/EN4Qm+dANzcM79dwtMTdnKz8S5EdPEs2kwRaTWXKue
         82umZ2oCxobcgz6danlIVuX5RXrIbuQ8cwny0XGsst99B1iAYK60YcbKvDv3uIbI1f
         zFy1dNqLKjLBYb5eeajJwphaeEvpiWspzitc6EWY=
Date:   Thu, 13 May 2021 11:48:25 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 050/530] md: md_open returns -EBUSY when entering
 racing area
Message-ID: <YJz16WxZH3sVMatV@kroah.com>
References: <20210512144819.664462530@linuxfoundation.org>
 <20210512144821.386618889@linuxfoundation.org>
 <20210513075940.GA22156@amd>
 <YJz1o17zGaqfCH0X@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJz1o17zGaqfCH0X@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 13, 2021 at 11:47:15AM +0200, Greg Kroah-Hartman wrote:
> On Thu, May 13, 2021 at 09:59:41AM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > commit 6a4db2a60306eb65bfb14ccc9fde035b74a4b4e7 upstream.
> > > 
> > > commit d3374825ce57 ("md: make devices disappear when they are no longer
> > > needed.") introduced protection between mddev creating & removing. The
> > > md_open shouldn't create mddev when all_mddevs list doesn't contain
> > > mddev. With currently code logic, there will be very easy to trigger
> > > soft lockup in non-preempt env.
> > > 
> > > This patch changes md_open returning from -ERESTARTSYS to -EBUSY, which
> > > will break the infinitely retry when md_open enter racing area.
> > > 
> > > This patch is partly fix soft lockup issue, full fix needs mddev_find
> > > is split into two functions: mddev_find & mddev_find_or_alloc. And
> > > md_open should call new mddev_find (it only does searching job).
> > > 
> > > For more detail, please refer with Christoph's "split mddev_find" patch
> > > in later commits.
> > 
> > Something went wrong here; changelog is truncated, in particular it
> > does not contain required sign-offs.
> 
> That's really odd, let me figure out what went wrong there, might be a
> quilt thing...

Yup, it's a bug in quilt, the header is just dropped for some reason.
Will dig further, thanks for pointing this out.

greg k-h
