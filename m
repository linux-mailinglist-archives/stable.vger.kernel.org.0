Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB86134021
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 12:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgAHLRm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 06:17:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:55716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728045AbgAHLRl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jan 2020 06:17:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BDBB2072A;
        Wed,  8 Jan 2020 11:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578482260;
        bh=ioOKvnobadRKGl98r6pmbN1f/3RtAZ7P8SY4kAowiP0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iUqJ1nIUDQ0rT9Yvt8dvDDVLXlVAZuTxmKFC+RN79X4vfPYepLhX+ZdNA7r7ZUZJT
         cBmAu4gkIgHw7D8hrNH32yHIgcf2+WorjhVhZxIUaNycnJZJuCPEgVYwgoakQMBhda
         mfvLk3KoMUoQmEKJEbJ6QyMZfKOYmKT2qDN3Dtns=
Date:   Wed, 8 Jan 2020 07:42:06 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chris Mason <clm@fb.com>, Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 5.4 100/191] block: fix splitting segments on boundary
 masks
Message-ID: <20200108064206.GB2278146@kroah.com>
References: <20200107205332.984228665@linuxfoundation.org>
 <20200107205338.341621494@linuxfoundation.org>
 <1fc351dd-a213-3310-7611-6b8c60c209cf@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1fc351dd-a213-3310-7611-6b8c60c209cf@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 07, 2020 at 02:00:56PM -0700, Jens Axboe wrote:
> On 1/7/20 1:53 PM, Greg Kroah-Hartman wrote:
> > From: Ming Lei <ming.lei@redhat.com>
> > 
> > commit 429120f3df2dba2bf3a4a19f4212a53ecefc7102 upstream.
> > 
> > We ran into a problem with a mpt3sas based controller, where we would
> > see random (and hard to reproduce) file corruption). The issue seemed
> > specific to this controller, but wasn't specific to the file system.
> > After a lot of debugging, we find out that it's caused by segments
> > spanning a 4G memory boundary. This shouldn't happen, as the default
> > setting for segment boundary masks is 4G.
> > 
> > Turns out there are two issues in get_max_segment_size():
> > 
> > 1) The default segment boundary mask is bypassed
> > 
> > 2) The segment start address isn't taken into account when checking
> >    segment boundary limit
> > 
> > Fix these two issues by removing the bypass of the segment boundary
> > check even if the mask is set to the default value, and taking into
> > account the actual start address of the request when checking if a
> > segment needs splitting.
> 
> Greg, there's a problem with this one on ARM. Should be resolved
> shortly, but probably best to defer this one until the next 5.4
> stable release.
> 
> I'll ping you with both patches once the dust has settled.

Thanks for letting me know, I've now dropped this from the queue.

greg k-h
