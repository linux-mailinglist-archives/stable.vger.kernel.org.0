Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 397DF10932D
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 18:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727602AbfKYR7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 12:59:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:52800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725823AbfKYR7O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Nov 2019 12:59:14 -0500
Received: from localhost (unknown [104.132.0.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1721720679;
        Mon, 25 Nov 2019 17:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574704754;
        bh=KeQcj2AKHVhcae5ILgNCmFk/tRvBlisVKhy3DFIZA1c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yAhngtwOvHCL1fYdnEEbD3QRzDnSUoSdtwsxjwj6+a1i1oT56fZJhYAeDWOX9pYoJ
         xqaYgcyIFhuTi5dVMgwAvRXZ0wF5ScvW9P8jBQhJVFk86A8Oz0PT3jLdQXlMaD6ayz
         ORtsLGOdmTQelG61JjEYrNOPWeP55O76jyMrx3o4=
Date:   Mon, 25 Nov 2019 09:59:13 -0800
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, stable@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Subject: Re: [PATCH v2] loop: avoid EAGAIN, if offset or block_size are
 changed
Message-ID: <20191125175913.GC71634@jaegeuk-macbookpro.roam.corp.google.com>
References: <20190518004751.18962-1-jaegeuk@kernel.org>
 <20190518005304.GA19446@jaegeuk-macbookpro.roam.corp.google.com>
 <1e1aae74-bd6b-dddb-0c88-660aac33872c@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e1aae74-bd6b-dddb-0c88-660aac33872c@acm.org>
User-Agent: Mutt/1.8.2 (2017-04-18)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/19, Bart Van Assche wrote:
> On 5/17/19 5:53 PM, Jaegeuk Kim wrote:
> > This patch tries to avoid EAGAIN due to nrpages!=0 that was originally trying
> > to drop stale pages resulting in wrong data access.
> > 
> > Report: https://bugs.chromium.org/p/chromium/issues/detail?id=938958#c38
> 
> Please provide a more detailed commit description. What is wrong with the
> current implementation and why is the new behavior considered the correct
> behavior?

Some history would be:

Original bug fix is:
commit 5db470e229e2 ("loop: drop caches if offset or block_size are changed"),
which returns EAGAIN so that user land like Chrome would require enhancing their
error handling routines.

So, this patch tries to avoid EAGAIN while addressing the original bug.

> 
> This patch moves draining code from before the following comment to after
> that comment:
> 
> /* I/O need to be drained during transfer transition */
> 
> Is that comment still correct or should it perhaps be updated?

IMHO, it's still valid.

> 
> Thanks,
> 

> Bart.
