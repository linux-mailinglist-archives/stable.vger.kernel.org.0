Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67621360B09
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 15:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233136AbhDONvh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 09:51:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232976AbhDONvd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 09:51:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 448BD613C1;
        Thu, 15 Apr 2021 13:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618494670;
        bh=qDateWJ3jYB1jjCGotgt/cil9HX4No0RTFnmdwtuoqI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Iz6SpIOv0+rsfPV0guaiCU0USGgfAGzD5KJ07L/oWMzJ0F+Kutz2vS3MQ5pEAPjjy
         kpk2kBzXz2CsjjCFzBiQuvBhRBMrbU27YCzkp+QFW6CNvTjbCgi0Mazc5aXS/fmf0c
         ZZraDkU7Z1WEIaJb5VbgATT6KS+5er4UEiL8Fn8A=
Date:   Thu, 15 Apr 2021 15:51:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Saravana Kannan <saravanak@google.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>, stable@vger.kernel.org,
        kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver core: Fix locking bug in
 deferred_probe_timeout_work_func()
Message-ID: <YHhEzAbT7ovcpDns@kroah.com>
References: <20210412180907.1980874-1-saravanak@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412180907.1980874-1-saravanak@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 12, 2021 at 11:09:06AM -0700, Saravana Kannan wrote:
> commit eed6e41813deb9ee622cd9242341f21430d7789f upstream.
> 
> list_for_each_entry_safe() is only useful if we are deleting nodes in a
> linked list within the loop. It doesn't protect against other threads
> adding/deleting nodes to the list in parallel. We need to grab
> deferred_probe_mutex when traversing the deferred_probe_pending_list.
> 
> Cc: stable@vger.kernel.org
> Fixes: 25b4e70dcce9 ("driver core: allow stopping deferred probe after init")
> Signed-off-by: Saravana Kannan <saravanak@google.com>
> Link: https://lore.kernel.org/r/20210402040342.2944858-2-saravanak@google.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> Hi Greg,
> 
> This should apply cleanly to 4.19 and 5.4 if you think this should be
> picked up.

thanks, now queued up.

greg k-h
