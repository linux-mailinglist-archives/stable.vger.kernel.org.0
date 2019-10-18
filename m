Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01763DCEC5
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 20:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394764AbfJRSzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 14:55:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbfJRSzQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 14:55:16 -0400
Received: from localhost (unknown [38.98.37.137])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F60220640;
        Fri, 18 Oct 2019 18:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571424915;
        bh=K/12HBOLREs70oPt0BZw/4JhTqL9elo+MXR7+xUsZpc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lSZOPZ5s+y6I0QKlrMUyTBW6wCcQf+ClsnwoUbqkZ0ShgPjqSHXIqLI1ZUmD9voHo
         yVeGB/LPOjtZuCbmteO7cUk+fNre3cNoksos3d9qDvait1oTrFbG1ewzJq71c+lmx1
         STz8i25nWbFnfehNscC5vHfMSPlSsNncz7Sd001g=
Date:   Fri, 18 Oct 2019 11:54:58 -0700
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH RFC v2 2/2] USB: ldusb: fix ring-buffer locking
Message-ID: <20191018185458.GA1191145@kroah.com>
References: <20191018151955.25135-1-johan@kernel.org>
 <20191018151955.25135-3-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018151955.25135-3-johan@kernel.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 18, 2019 at 05:19:55PM +0200, Johan Hovold wrote:
> The custom ring-buffer implementation was merged without any locking
> whatsoever, but a spinlock was later added by commit 9d33efd9a791
> ("USB: ldusb bugfix").
> 
> The lock did not cover the loads from the ring-buffer entry after
> determining the buffer was non-empty, nor the update of the tail index
> once the entry had been processed. The former could lead to stale data
> being returned, while the latter could lead to memory corruption on
> sufficiently weakly ordered architectures.

Ugh.

This almost looks sane, but what's the odds there is some other issue in
here as well?  Would it make sense to just convert the code to use the
"standard" ring buffer code instead?

thanks,

greg k-h
