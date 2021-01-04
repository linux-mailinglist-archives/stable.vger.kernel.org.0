Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 348442E93B8
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 11:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbhADKwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 05:52:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:56132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726832AbhADKwe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 05:52:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE38E21D93;
        Mon,  4 Jan 2021 10:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609757514;
        bh=Qludl3mW9cikrzdwm6uafrBjf7B0gur26jtO6SGSl7Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y9LY9u3rodCDdUSza/UxJltgPXg4tAhyYe3GAAwFGhU+Ue3KtH3Zi551NWIrVx+cs
         iCMciq0tb6WjnNWLooweAZ9q70VvwDpSjluxQWkmO2uRLH7cmSLubZejN7eAnEkLfv
         TjR1EWJ9+2M52GHDWUGlCYGfI5P83OSK8zKKx658=
Date:   Mon, 4 Jan 2021 11:53:20 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] null_blk: Fix zone size initialization
Message-ID: <X/LzoKkYXJMdfhlJ@kroah.com>
References: <160915617623242@kroah.com>
 <20210104061044.664481-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104061044.664481-1-damien.lemoal@wdc.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 04, 2021 at 03:10:44PM +0900, Damien Le Moal wrote:
> commit 0ebcdd702f49aeb0ad2e2d894f8c124a0acc6e23 upstream.
> 
> For a null_blk device with zoned mode enabled is currently initialized
> with a number of zones equal to the device capacity divided by the zone
> size, without considering if the device capacity is a multiple of the
> zone size. If the zone size is not a divisor of the capacity, the zones
> end up not covering the entire capacity, potentially resulting is out
> of bounds accesses to the zone array.
> 
> Fix this by adding one last smaller zone with a size equal to the
> remainder of the disk capacity divided by the zone size if the capacity
> is not a multiple of the zone size. For such smaller last zone, the zone
> capacity is also checked so that it does not exceed the smaller zone
> size.

Now queued up, thanks.

greg k-h
