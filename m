Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8E0214CD3
	for <lists+stable@lfdr.de>; Sun,  5 Jul 2020 15:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbgGENtM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jul 2020 09:49:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726804AbgGENtL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Jul 2020 09:49:11 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A93A20723;
        Sun,  5 Jul 2020 13:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593956951;
        bh=mOhwFuNE7Y8r4BEjMNvBLfrbr6AK8CbR3T0QbYY2/UY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NiNaG77yjzqQsFuLwC2XjSdj4tSBQSOolPj3fskkxDsYQK19WCuB+zoOim85hpSUC
         0dFki3VUoiMGqoLzhh3smZm0oj2lfIDOhqjZK4prEoqgnzMgcUpknsI77yBIikyilz
         MCRK4J2HDfSOBtEkDskDs0sehoxBIC9hXlgild8Q=
Date:   Sun, 5 Jul 2020 09:49:10 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     axboe@kernel.dk, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: use signal based task_work
 running" failed to apply to 5.7-stable tree
Message-ID: <20200705134910.GJ2722994@sasha-vm>
References: <15939484161622@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15939484161622@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 05, 2020 at 01:26:56PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.7-stable tree.
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
>From ce593a6c480a22acba08795be313c0c6d49dd35d Mon Sep 17 00:00:00 2001
>From: Jens Axboe <axboe@kernel.dk>
>Date: Tue, 30 Jun 2020 12:39:05 -0600
>Subject: [PATCH] io_uring: use signal based task_work running
>
>Since 5.7, we've been using task_work to trigger async running of
>requests in the context of the original task. This generally works
>great, but there's a case where if the task is currently blocked
>in the kernel waiting on a condition to become true, it won't process
>task_work. Even though the task is woken, it just checks whatever
>condition it's waiting on, and goes back to sleep if it's still false.
>
>This is a problem if that very condition only becomes true when that
>task_work is run. An example of that is the task registering an eventfd
>with io_uring, and it's now blocked waiting on an eventfd read. That
>read could depend on a completion event, and that completion event
>won't get trigged until task_work has been run.
>
>Use the TWA_SIGNAL notification for task_work, so that we ensure that
>the task always runs the work when queued.
>
>Cc: stable@vger.kernel.org # v5.7
>Signed-off-by: Jens Axboe <axboe@kernel.dk>

This patch depends on e91b48162332 ("task_work: teach task_work_add() to
do signal_wake_up()"), I've queued both for 5.7.

-- 
Thanks,
Sasha
