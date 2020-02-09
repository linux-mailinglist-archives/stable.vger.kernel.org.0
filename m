Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A23BE156C12
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 19:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbgBISdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 13:33:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:54722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727413AbgBISdq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 13:33:46 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 414F1207FF;
        Sun,  9 Feb 2020 18:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581273226;
        bh=M0K7xZf5ZP6IT40OVPb1SuMawHOKgFxVfbcOd7V97rE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lPoUd2Tug+7Uq9XHiq8RTbec/zyuBOjkXP3NtMLzRdXlkXFOOdXR/TsG8UmJmFxA9
         eIoDKh9MvsPKliIcBywNxDH7uI9PnDuL59Ano24tJzlbvA2/MTqVbup2kQPDDoWnsj
         vSm552S2L5iDwHQNZCSUO7WulQO+6tJjML1WvxV8=
Date:   Sun, 9 Feb 2020 13:33:45 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     axboe@kernel.dk, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: prevent potential eventfd
 recursion on poll" failed to apply to 5.5-stable tree
Message-ID: <20200209183345.GP3584@sasha-vm>
References: <158124917113830@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158124917113830@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 12:52:51PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.5-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From f0b493e6b9a8959356983f57112229e69c2f7b8c Mon Sep 17 00:00:00 2001
>From: Jens Axboe <axboe@kernel.dk>
>Date: Sat, 1 Feb 2020 21:30:11 -0700
>Subject: [PATCH] io_uring: prevent potential eventfd recursion on poll
>
>If we have nested or circular eventfd wakeups, then we can deadlock if
>we run them inline from our poll waitqueue wakeup handler. It's also
>possible to have very long chains of notifications, to the extent where
>we could risk blowing the stack.
>
>Check the eventfd recursion count before calling eventfd_signal(). If
>it's non-zero, then punt the signaling to async context. This is always
>safe, as it takes us out-of-line in terms of stack and locking context.
>
>Cc: stable@vger.kernel.org # 5.1+
>Signed-off-by: Jens Axboe <axboe@kernel.dk>

I queued it back to 5.5 by taking f2842ab5b72d ("io_uring: enable option
to only trigger eventfd for async completions") and working around
missing commit 69b3e546139a ("io_uring: change io_ring_ctx bool fields
into bit fields"). However, 5.4 is a bit more complex than what I can
tackle without a test suite.

Jens, is there something I can run to validate io_uring on older
kernels?

-- 
Thanks,
Sasha
