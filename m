Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B104CEDC8D
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 11:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbfKDKaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 05:30:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:36516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727322AbfKDKaY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 05:30:24 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44ED021D81;
        Mon,  4 Nov 2019 10:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572863421;
        bh=3qXHhCVJfXJCFkdebFepeZceAENET7VBBd5TLbKSjas=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GlxjCgTI1l+wm1Mwf3X+wjlHzRxxrOOKS3mpaNLWrtxJ11mEQ6f1c+xl5j7/buslF
         Zyg62r/P4UNrAIx1zx0YtHwo2e1LJQjXFzCT8HML6yy4Mw/uQqNGd3dCxvYUXh5fM1
         a6uRN9KVAJa8UQy4f7UtzwMhSX3dix+JGxs/8ioA=
Date:   Mon, 4 Nov 2019 05:30:20 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     tiwai@suse.de, kirill.shutemov@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ALSA: timer: Fix mutex deadlock at
 releasing card" failed to apply to 4.19-stable tree
Message-ID: <20191104103020.GB4787@sasha-vm>
References: <1572802859163107@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1572802859163107@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 03, 2019 at 06:40:59PM +0100, gregkh@linuxfoundation.org wrote:
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
>From a39331867335d4a94b6165e306265c9e24aca073 Mon Sep 17 00:00:00 2001
>From: Takashi Iwai <tiwai@suse.de>
>Date: Wed, 30 Oct 2019 22:42:57 +0100
>Subject: [PATCH] ALSA: timer: Fix mutex deadlock at releasing card
>
>When a card is disconnected while in use, the system waits until all
>opened files are closed then releases the card.  This is done via
>put_device() of the card device in each device release code.
>
>The recently reported mutex deadlock bug happens in this code path;
>snd_timer_close() for the timer device deals with the global
>register_mutex and it calls put_device() there.  When this timer
>device is the last one, the card gets freed and it eventually calls
>snd_timer_free(), which has again the protection with the global
>register_mutex -- boom.
>
>Basically put_device() call itself is race-free, so a relative simple
>workaround is to move this put_device() call out of the mutex.  For
>achieving that, in this patch, snd_timer_close_locked() got a new
>argument to store the card device pointer in return, and each caller
>invokes put_device() with the returned object after the mutex unlock.
>
>Reported-and-tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>Cc: <stable@vger.kernel.org>
>Signed-off-by: Takashi Iwai <tiwai@suse.de>

Looks like this was introduced by 41672c0c24a6 ("ALSA: timer: Simplify
error path in snd_timer_open()"), which means it's not needed on 4.19 or
older.

-- 
Thanks,
Sasha
