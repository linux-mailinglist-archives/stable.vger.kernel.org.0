Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 910081D8F5F
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 07:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgESFsa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 01:48:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726524AbgESFsa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 May 2020 01:48:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08FD220708;
        Tue, 19 May 2020 05:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589867309;
        bh=KAvlWsPDVRKpaNEURqp3QWPIzLEiQeR7GyhlgXrBnkA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KZ4ayL8lkTfkZsD2JHfGMp0ngBkhhG1ALJ1l1zRtU4nQlGvqo8TKWNtZFpR043r/Z
         x/OHdLYU/iVctTFc+OuEPZu1L3LRtGxdR/A2eGri7m2Zpsr9bGnlAusIINtiImZ1rW
         NNtr7sopwxpoNzI8bQUE6DrTDWhA2QIXN5sGmkFw=
Date:   Tue, 19 May 2020 07:48:27 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Saravana Kannan <saravanak@google.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>, stable@vger.kernel.org,
        kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] driver core: Fix SYNC_STATE_ONLY device link
 implementation
Message-ID: <20200519054827.GA3826326@kroah.com>
References: <20200518080327.GA3126260@kroah.com>
 <20200519030025.99054-1-saravanak@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519030025.99054-1-saravanak@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 18, 2020 at 08:00:25PM -0700, Saravana Kannan wrote:
> When SYNC_STATE_ONLY support was added in commit 05ef983e0d65 ("driver
> core: Add device link support for SYNC_STATE_ONLY flag"),
> device_link_add() incorrectly skipped adding the new SYNC_STATE_ONLY
> device link to the supplier's and consumer's "device link" list.
> 
> This causes multiple issues:
> - The device link is lost forever from driver core if the caller
>   didn't keep track of it (caller typically isn't expected to). This is
>   a memory leak.
> - The device link is also never visible to any other code path after
>   device_link_add() returns.
> 
> If we fix the "device link" list handling, that exposes a bunch of
> issues.
> 
> 1. The device link "status" state management code rightfully doesn't
> handle the case where a DL_FLAG_MANAGED device link exists between a
> supplier and consumer, but the consumer manages to probe successfully
> before the supplier. The addition of DL_FLAG_SYNC_STATE_ONLY links break
> this assumption. This causes device_links_driver_bound() to throw a
> warning when this happens.
> 
> Since DL_FLAG_SYNC_STATE_ONLY device links are mainly used for creating
> proxy device links for child device dependencies and aren't useful once
> the consumer device probes successfully, this patch just deletes
> DL_FLAG_SYNC_STATE_ONLY device links once its consumer device probes.
> This way, we avoid the warning, free up some memory and avoid
> complicating the device links "status" state management code.
> 
> 2. Creating a DL_FLAG_STATELESS device link between two devices that
> already have a DL_FLAG_SYNC_STATE_ONLY device link will result in the
> DL_FLAG_STATELESS flag not getting set correctly. This patch also fixes
> this.
> 
> Lastly, this patch also fixes minor whitespace issues.
> 
> Cc: stable@vger.kernel.org
> Fixes: 05ef983e0d65 ("driver core: Add device link support for SYNC_STATE_ONLY flag")
> Signed-off-by: Saravana Kannan <saravanak@google.com>
> ---
>  drivers/base/core.c | 61 +++++++++++++++++++++++++++++----------------
>  1 file changed, 39 insertions(+), 22 deletions(-)

If this is v2, what changed from v1?

That always goes below the --- line, you know this :)

v3 please?

thanks,

greg k-h
