Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25AE0170EA7
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 03:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbgB0Crk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 21:47:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:41694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728220AbgB0Crj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Feb 2020 21:47:39 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6611222C2;
        Thu, 27 Feb 2020 02:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582771659;
        bh=4i7aNElgKb2KvKCQy1HtZ07hqhyKQxtLJ54PtxdBYvI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c+dzYbUhFf9IUWEFHY8cGb+4FHG2ZDqI6899K3FBYJCLNJjxKtx+MPpIQn5ipbuer
         6wi37OvUp2koF0Vqo5p/qKmqMgVf+V3QlUOAnNY5hDL2yZn5YZyLA+3sl8DGfEgthn
         snY3FD0kcL4/94DQXz/CArnUGVu9h++z8ySedJFA=
Date:   Wed, 26 Feb 2020 21:47:35 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     glider@google.com, akpm@linux-foundation.org, dvyukov@google.com,
        jpoimboe@redhat.com, kstewart@linuxfoundation.org,
        matthias.bgg@gmail.com, stable@vger.kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, walter-zh.wu@mediatek.com
Subject: Re: FAILED: patch "[PATCH] lib/stackdepot.c: fix global
 out-of-bounds in stack_slabs" failed to apply to 4.19-stable tree
Message-ID: <20200227024735.GE22178@sasha-vm>
References: <1582714182242120@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1582714182242120@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 26, 2020 at 11:49:42AM +0100, gregkh@linuxfoundation.org wrote:
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
>From 305e519ce48e935702c32241f07d393c3c8fed3e Mon Sep 17 00:00:00 2001
>From: Alexander Potapenko <glider@google.com>
>Date: Thu, 20 Feb 2020 20:04:30 -0800
>Subject: [PATCH] lib/stackdepot.c: fix global out-of-bounds in stack_slabs
>
>Walter Wu has reported a potential case in which init_stack_slab() is
>called after stack_slabs[STACK_ALLOC_MAX_SLABS - 1] has already been
>initialized.  In that case init_stack_slab() will overwrite
>stack_slabs[STACK_ALLOC_MAX_SLABS], which may result in a memory
>corruption.
>
>Link: http://lkml.kernel.org/r/20200218102950.260263-1-glider@google.com
>Fixes: cd11016e5f521 ("mm, kasan: stackdepot implementation. Enable stackdepot for SLAB")
>Signed-off-by: Alexander Potapenko <glider@google.com>
>Reported-by: Walter Wu <walter-zh.wu@mediatek.com>
>Cc: Dmitry Vyukov <dvyukov@google.com>
>Cc: Matthias Brugger <matthias.bgg@gmail.com>
>Cc: Thomas Gleixner <tglx@linutronix.de>
>Cc: Josh Poimboeuf <jpoimboe@redhat.com>
>Cc: Kate Stewart <kstewart@linuxfoundation.org>
>Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>Cc: <stable@vger.kernel.org>
>Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

I've grabbed ee050dc83bc3 ("lib/stackdepot: Fix outdated comments") as a
dependency and queued for 4.19-4.9.

Technically the comment change is wrong as the commit it addresses is
older, but no one should be coding against the stable tree, and doing it
by changing 305e519ce48e would cause merge conflicts in the future.

-- 
Thanks,
Sasha
