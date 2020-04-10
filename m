Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C68751A4429
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 11:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbgDJJDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Apr 2020 05:03:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbgDJJDo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Apr 2020 05:03:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C64E206F7;
        Fri, 10 Apr 2020 09:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586509423;
        bh=DNMnqkpLJrjSpvEfGZLM7KYTuA2yT/WyOb0DhXl1DKk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NgIi/SfvX44q2Y7xaknBC90XGiR0Wx6WbJE9ook/pK2ikfz7pHVM+vFHD5mKKaw8u
         AdD3UdQlJM538Khf0T9UJe5d7yRDAiLMBJVnjaHHxXNZrVHq2BujTBnssB78/hvL91
         mLYlBYyqHkyfjZZctRUWLGYki5q3zkK2FyJnOhGg=
Date:   Fri, 10 Apr 2020 11:03:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Giuliano Procida <gprocida@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/4] block: more locking around delayed work
Message-ID: <20200410090339.GA1691838@kroah.com>
References: <CAGvU0Hn2U88Dy2MEP-ZTNvfrWaKF4XL9EtR+4iF5BZ6_GW3Tvg@mail.gmail.com>
 <20200407165539.161505-2-gprocida@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407165539.161505-2-gprocida@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 07, 2020 at 05:55:36PM +0100, Giuliano Procida wrote:
> commit 287922eb0b186e2a5bf54fdd04b734c25c90035c upstream.
> 
> The upstream commit (block: defer timeouts to a workqueue) included
> various locking changes. The original commit message did not say
> anything about the extra locking. Perhaps this is only needed for
> workqueue callbacks and not timer callbacks. We assume it is needed
> here.
> 
> This patch includes the locking changes but leaves timeouts using a
> timer.
> 
> Both blk_mq_rq_timer and blk_rq_timed_out_timer will return without
> without doing any work if they cannot acquire the queue (without
> waiting).
> 
> Signed-off-by: Giuliano Procida <gprocida@google.com>

Don't write your own changelog text for something that is upstream,
include the original and then add your own later on below, making it
obvious what you are doing differently from the original commit.

And be sure to cc: all of the original people on that commit, and keep
their s-o-b also.

thanks,

greg k-h
