Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69EFF28578
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 19:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731406AbfEWR63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 13:58:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731239AbfEWR63 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 13:58:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A63732186A;
        Thu, 23 May 2019 17:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558634309;
        bh=u6phJYWm95FSm2x2b6aiMhUE3rJLE9VyeatGVqJFFRE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C0fdBNNLcvBMwS+luWqINsPIfrm9dW7Mi0C233BpFQ5HodNqKWLdNSpNJUcUdtQVz
         kB2CupvqcK+j3Zv03dZE258htE/XdIn0CENKRtEVAssK3fpt68XnXax2hdzacN26Rt
         qhKDssN9ZrX+4KaeT66/b7Y1C4SVfx3IbAmK15S4=
Date:   Thu, 23 May 2019 19:58:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     stable@vger.kernel.org, dsterba@suse.cz,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH] btrfs: Honour FITRIM range constraints during free space
 trim
Message-ID: <20190523175826.GH29438@kroah.com>
References: <20190520135138.5594-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520135138.5594-1-nborisov@suse.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 20, 2019 at 04:51:38PM +0300, Nikolay Borisov wrote:
> Up until now trimming the freespace was done irrespective of what the
> arguments of the FITRIM ioctl were. For example fstrim's -o/-l arguments
> will be entirely ignored. Fix it by correctly handling those paramter.
> This requires breaking if the found freespace extent is after the end of
> the passed range as well as completing trim after trimming
> fstrim_range::len bytes.
> 
> Fixes: 499f377f49f0 ("btrfs: iterate over unused chunk space in FITRIM")
> CC: stable@vger.kernel.org # 4.4+
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> Reviewed-by: David Sterba <dsterba@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
> 
> Hello, 
> 
> Here is a backport of upstream commit c2d1b3aae33605a61cbab445d8ae1c708ccd2698
> for 4.14.y. Please apply 
>  fs/btrfs/extent-tree.c | 25 +++++++++++++++++++------
>  1 file changed, 19 insertions(+), 6 deletions(-)

All of these now queued up, thanks.

greg k-h
