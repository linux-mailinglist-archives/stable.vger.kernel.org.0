Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1640791493
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 06:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbfHREb0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 00:31:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48488 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfHREb0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Aug 2019 00:31:26 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hzCqS-0008Gp-II; Sun, 18 Aug 2019 04:31:13 +0000
Date:   Sun, 18 Aug 2019 05:31:08 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Monthero Ronald <rhmcruiser@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] fs: buffer: Check to avoid NULL pointer dereference of
 returned buffer_head for a private page
Message-ID: <20190818043108.GZ1131@ZenIV.linux.org.uk>
References: <1565795351-10543-1-git-send-email-rhmcruiser@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1565795351-10543-1-git-send-email-rhmcruiser@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
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

... and adds BUG_ON() for that.  The only real difference from an oops is
that it's a bit easier to recognize.  Which may or may not be a good
debugging strategy, but what's the point of having it in -stable?  Or
anywhere other than the build on the boxen you are testing on...

It doesn't fix the underlying bug.  It doesn't tell where the problem
is.  It's definitely *not* a way to fix any bugs.  And while we
are at it, the stuff in -stable ought to be backports from mainline.

Can you reproduce your crashes on mainline?
