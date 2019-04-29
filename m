Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAD4E1BB
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 14:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbfD2MAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 08:00:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727913AbfD2MAF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Apr 2019 08:00:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 789042053B;
        Mon, 29 Apr 2019 12:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556539205;
        bh=AKtDYXlDfRMxnBC8B/0HjTPdu7wY64ukkDJUsWeUAmk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OpDyPXL+SYEW3azJd5oEcVsD5GPLzZ3iupfzviujL1JqDP/23FdsQTNitl98bTHo7
         8KJy6+hdLJ6HWgkXe5O69/KD/GC18iXeTyKs8Pd41tuqJgpTe1QZxVMkgMsl9O0+3B
         YHQaJawvOu1IKmNX/yYWAujmJ0H2uqKiQ15mSRws=
Date:   Mon, 29 Apr 2019 14:00:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Todd Kjos <tkjos@android.com>
Cc:     tkjos@google.com, arve@android.com, stable@vger.kernel.org,
        maco@google.com, joel@joelfernandes.org, kernel-team@android.com
Subject: Re: [PATCH stable] binder: fix race between munmap() and direct
 reclaim
Message-ID: <20190429120002.GA19611@kroah.com>
References: <20190424173556.85545-1-tkjos@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190424173556.85545-1-tkjos@google.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 24, 2019 at 10:35:56AM -0700, Todd Kjos wrote:
> From: Todd Kjos <tkjos@android.com>
> 
> commit 5cec2d2e5839f9c0fec319c523a911e0a7fd299f upstream.
> 
> An munmap() on a binder device causes binder_vma_close() to be called
> which clears the alloc->vma pointer.
> 
> If direct reclaim causes binder_alloc_free_page() to be called, there
> is a race where alloc->vma is read into a local vma pointer and then
> used later after the mm->mmap_sem is acquired. This can result in
> calling zap_page_range() with an invalid vma which manifests as a
> use-after-free in zap_page_range().
> 
> The fix is to check alloc->vma after acquiring the mmap_sem (which we
> were acquiring anyway) and skip zap_page_range() if it has changed
> to NULL.
> 
> Signed-off-by: Todd Kjos <tkjos@google.com>
> Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> Cc: stable <stable@vger.kernel.org> # 5.0, 4.19, 4.14
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> Greg: This applies to 5.0, 4.19, 4.14. Not needed before 4.12.

Thanks, now queued up.

greg k-h
