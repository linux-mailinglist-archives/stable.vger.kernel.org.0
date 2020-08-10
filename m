Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7CF2240568
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 13:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgHJLho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 07:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbgHJLhn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 07:37:43 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83886C061756;
        Mon, 10 Aug 2020 04:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SpAnL7Dzx5NA9cRHb9ub/hZ7RJOAb31HmriPOz891hY=; b=Uhq/jcFvuOLSR6NqZFTWAj58/E
        iZtZVtu9rJUZ5Aj8in2Ut4mYBFtgZxxNatu+yxCxxSlErdwz7IRw63p15K1SWTvhxXlQ99x618EtI
        BSU486p6AhsJUitbUfQkPRZSLxo5VpoJzj1k0OeEq2kI1DA0ehTfkrzJrDD8Ez+0VO3VPNU/MVuEC
        JfbbkUKynoFOqegvgDmtxIZC/kdiHaWUe9s9wUDFx9cMnFJXc0J0VSzmh3DTMyA7yz6z49WmxAVIB
        dWlPpapuXPnvU/Wc7D+XLb4rLsd61TepL2BbRPt4etgNreWQj+bBc87jdVpV4IqMagiwtKnIN+7Uz
        YqZPFVAg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k567Z-00050d-LV; Mon, 10 Aug 2020 11:37:41 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 7B3F5301A7A;
        Mon, 10 Aug 2020 13:37:40 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 57BBD23D39366; Mon, 10 Aug 2020 13:37:40 +0200 (CEST)
Date:   Mon, 10 Aug 2020 13:37:40 +0200
From:   peterz@infradead.org
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] kernel: split task_work_add() into two separate
 helpers
Message-ID: <20200810113740.GR2674@hirez.programming.kicks-ass.net>
References: <20200808183439.342243-1-axboe@kernel.dk>
 <20200808183439.342243-2-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200808183439.342243-2-axboe@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 08, 2020 at 12:34:38PM -0600, Jens Axboe wrote:
> Some callers may need to make signaling decisions based on the state
> of the targeted task, and that can only safely be done post adding
> the task_work to the task. Split task_work_add() into:
> 
> __task_work_add()	- adds the work item
> __task_work_notify()	- sends the notification
> 
> No functional changes in this patch.

Might be nice to mention __task_work_add() is now inline.

> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: stable@vger.kernel.org # v5.7+
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  include/linux/task_work.h | 19 ++++++++++++++++
>  kernel/task_work.c        | 48 +++++++++++++++++++++------------------
>  2 files changed, 45 insertions(+), 22 deletions(-)



> +struct callback_head work_exited = {
> +	.next = NULL	/* all we need is ->next == NULL */
> +};

Would it make sense to make this const ? Esp. with the thing exposed,
sticking it in R/O memory might avoid a mistake somewhere.
