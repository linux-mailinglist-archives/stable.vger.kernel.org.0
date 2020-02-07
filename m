Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC60A15595C
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 15:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbgBGO1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Feb 2020 09:27:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:46718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727562AbgBGO1p (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Feb 2020 09:27:45 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C740120838;
        Fri,  7 Feb 2020 14:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581085665;
        bh=wvewkp4lOzdQHPJ4fY1LxGjlWqcPeMyWbgmFzE14Qfw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AL+mIfPeOqjmj5iv6MkIXuqY8jqLVACjlRgLJ3GxTw59whSwZtvh7DmcpbDvgpFXK
         N8efCwNu/jpkTODSbQmoL7lVwTrW/qu6f6CCcr4++QsZyfog6PF6h0/jx4MSwnx3kK
         4TLmVHnlC7P4ljJiJfZWI8hWGFHV1VsoZkMBCBD8=
Date:   Fri, 7 Feb 2020 09:27:43 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     herbert@gondor.apana.org.au, daniel.m.jordan@oracle.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] padata: Remove broken queue flushing"
 failed to apply to 4.19-stable tree
Message-ID: <20200207142743.GT31482@sasha-vm>
References: <1581065191136112@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1581065191136112@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 07, 2020 at 09:46:31AM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
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
>From 07928d9bfc81640bab36f5190e8725894d93b659 Mon Sep 17 00:00:00 2001
>From: Herbert Xu <herbert@gondor.apana.org.au>
>Date: Tue, 19 Nov 2019 13:17:31 +0800
>Subject: [PATCH] padata: Remove broken queue flushing
>
>The function padata_flush_queues is fundamentally broken because
>it cannot force padata users to complete the request that is
>underway.  IOW padata has to passively wait for the completion
>of any outstanding work.
>
>As it stands flushing is used in two places.  Its use in padata_stop
>is simply unnecessary because nothing depends on the queues to
>be flushed afterwards.
>
>The other use in padata_replace is more substantial as we depend
>on it to free the old pd structure.  This patch instead uses the
>pd->refcnt to dynamically free the pd structure once all requests
>are complete.
>
>Fixes: 2b73b07ab8a4 ("padata: Flush the padata queues actively")
>Cc: <stable@vger.kernel.org>
>Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
>Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Conflicts are due to not having 6fc4dbcf0276 ("padata: Replace delayed
timer with immediate workqueue in padata_reorder") in older kernels.
I've fixed it up and queued for 4.19-4.4.

-- 
Thanks,
Sasha
