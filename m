Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 531988D793
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 18:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbfHNQDD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 12:03:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:58598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbfHNQDD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 12:03:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1D6A2083B;
        Wed, 14 Aug 2019 16:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565798582;
        bh=Zz23p4lEGrVE32BuJjlO5gztoMONPBASem+J1rR05U4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qFNO82ppI7D0tq92TaZmyKhowzFVhpa9lbf3L8iaBNFasSg4rYnBTJA0BoxhjC1tq
         daQ9bBG6xAUX2ER08ZRRUn48zL3jk7BH3rtFOB6QFD/RGHV0MoeMZoFyRnxqLa2T8I
         Sgvoasb95luMFeiomCXzaIbpp87UxMZ1N+74ONjQ=
Date:   Wed, 14 Aug 2019 18:02:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Monthero Ronald <rhmcruiser@gmail.com>
Cc:     viro@zeniv.linux.org.uk, stable@vger.kernel.org
Subject: Re: [PATCH] fs: buffer: Check to avoid NULL pointer dereference of
 returned buffer_head for a private page
Message-ID: <20190814160259.GA11018@kroah.com>
References: <1565795351-10543-1-git-send-email-rhmcruiser@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1565795351-10543-1-git-send-email-rhmcruiser@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 15, 2019 at 01:09:11AM +1000, Monthero Ronald wrote:
> The patch checks for this condition of NULL pointer for the buffer_head returned from page_buffers()
> and also a check placed within the list traversal loop for next buffer_head structs.
> 
> crash scenario:
> The buffer_head returned from page_buffers() is not checked in block_invalidatepage_range function.
> The struct buffer_head* pointer returned by page_buffers(page) was 0x0, although this page had its
> private flag PG_private bit set and was expected to have buffer_head structs attached.The NULL pointer
> buffer_head was dereferenced in block_invalidatepage_range function at bh->b_size, where bh returned by
> page_buffers(page) was 0x0.
> 
> The stack frames were  truncate_inode_page() => do_invalidatepage_range() => xfs_vm_invalidatepage() =>
>           [exception RIP: block_invalidatepage_range+132]
> 
> The inode for truncate in this case was valid and had  proper inode.i_state = 0x20 - FREEING and had
> a valid mapped address space to xfs. And the struct page in context of block_invalidatepage_range()
> had its page flag PG_private set but the page.private was 0x0. So page_buffers(page) returned 0x0
> and hence the crash.
> This patch performs NULL pointer check for returned buffer_head. Applies to 3.16 and later kernels.
> 
> Signed-off-by: Monthero Ronald <rhmcruiser@gmail.com>
> ---
>  fs/buffer.c | 2 ++
>  1 file changed, 2 insertions(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
