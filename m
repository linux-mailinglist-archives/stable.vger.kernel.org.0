Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0C3017824A
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729299AbgCCSSE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:18:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:59570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727070AbgCCSSE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:18:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72B2C20656;
        Tue,  3 Mar 2020 18:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583259483;
        bh=IHuMRzU8QqFclZ7mXjFHOkuflL21f3jh8l3Cb/uFw0Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qB+bjdCN5BHLotWc7ReR3ShmY6tWCv+P6jh55Yx4PMegMHKe6juo+BpIi/o7VurUQ
         ovB+OjIzYeCObvo+fyr3tqoYmFpNH6EehdPpW+d/lZ2bX8hffGCcgoc4WNLtD90aXm
         clCH4fCLeUnZhgyZ6dsrBB3/MRDs/s8/s2QPNC5c=
Date:   Tue, 3 Mar 2020 19:12:28 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Coly Li <colyli@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 062/152] bcache: ignore pending signals when creating
 gc and allocator thread
Message-ID: <20200303181228.GA1014382@kroah.com>
References: <20200303174302.523080016@linuxfoundation.org>
 <20200303174309.501274295@linuxfoundation.org>
 <db776832-64ff-6757-de09-ced1ea8b368f@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db776832-64ff-6757-de09-ced1ea8b368f@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 03, 2020 at 10:55:04AM -0700, Jens Axboe wrote:
> On 3/3/20 10:42 AM, Greg Kroah-Hartman wrote:
> > From: Coly Li <colyli@suse.de>
> > 
> > [ Upstream commit 0b96da639a4874311e9b5156405f69ef9fc3bef8 ]
> > 
> > When run a cache set, all the bcache btree node of this cache set will
> > be checked by bch_btree_check(). If the bcache btree is very large,
> > iterating all the btree nodes will occupy too much system memory and
> > the bcache registering process might be selected and killed by system
> > OOM killer. kthread_run() will fail if current process has pending
> > signal, therefore the kthread creating in run_cache_set() for gc and
> > allocator kernel threads are very probably failed for a very large
> > bcache btree.
> > 
> > Indeed such OOM is safe and the registering process will exit after
> > the registration done. Therefore this patch flushes pending signals
> > during the cache set start up, specificly in bch_cache_allocator_start()
> > and bch_gc_thread_start(), to make sure run_cache_set() won't fail for
> > large cahced data set.
> 
> Please drop this one, it's being reverted in mainline.

Dropped from all trees now, thanks.

greg k-h
