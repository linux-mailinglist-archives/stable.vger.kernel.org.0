Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 203EA90439
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 16:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbfHPOyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 10:54:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbfHPOyj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Aug 2019 10:54:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDE532086C;
        Fri, 16 Aug 2019 14:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565967278;
        bh=Ft48zl3UpgHiHHJcgyXOdAOG45h3Jwm4M7OBOVDUzQY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2dQJ3Sm+ddSE20a5TNWpsq5Dy11EyiF+Y95TKifH6l2vX10/2hi0GEz3IldbHHp9n
         tiDiDIo+3IDpP6giLbSGKXgFnC83gMf9ATaW6zUdPEx8w2q9aAB++5fPQlf937M7Kq
         ge60xI0hDN1CAjnCNq3AgSKDVkj2jggDJ3zkFs7c=
Date:   Fri, 16 Aug 2019 16:54:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        stable@vger.kernel.org, Mark Ray <mark.ray@hpe.com>
Subject: Re: [PATCH] blk-mq: remove blk_mq_hw_sysfs_cpus
Message-ID: <20190816145435.GA3424@kroah.com>
References: <20190816074849.7197-1-ming.lei@redhat.com>
 <5baa0c28-6e12-5a61-0254-de0e49cf1596@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5baa0c28-6e12-5a61-0254-de0e49cf1596@kernel.dk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 16, 2019 at 08:20:42AM -0600, Jens Axboe wrote:
> On 8/16/19 1:48 AM, Ming Lei wrote:
> > It is reported that sysfs buffer overflow can be triggered in case
> > of too many CPU cores(>841 on 4K PAGE_SIZE) when showing CPUs in
> > blk_mq_hw_sysfs_cpus_show().
> > 
> > This info isn't useful, given users may retrieve the CPU list
> > from sw queue entries under same kobject dir, so far not see
> > any active users.
> > 
> > So remove the entry as suggested by Greg.
> 
> I think that's a bit frivolous, there could very well be scripts or
> apps that use it. Let's just fix the overflow.

As no one really knows what the format is (and the patch to fix the
overflow changes the format of the file), I would say that it needs to
just be dropped as it is not an example of what you should be doing in
sysfs.

thanks,

greg k-h
