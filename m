Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 846C22850A5
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 19:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgJFRUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 13:20:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725902AbgJFRUq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Oct 2020 13:20:46 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B991F20760;
        Tue,  6 Oct 2020 17:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602004845;
        bh=4Foc+jU1k/rvfrsLBs93aOS5mcxlAz0t1W5dlS01hRo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=yfq1ofdv7rZJ5+ORDfeANL1fIsq8QvuchUDnxEjqXkiwUkrM7f+jjDjX5qOtiLO5H
         KgoJQ7KK3SEr6FYxnD9spCEDZHYO6JW2VHKg3xA8vU0tmZENoeSzu13L85e+BVMqfp
         TIMjQvJyW9M69GHv5p0s87KXy50U736GRLHqcUY8=
Message-ID: <f10381885b6e3ea8af828f1b7be5c2f7035e82df.camel@kernel.org>
Subject: Re: [PATCH 3/7] ceph: Promote to unsigned long long before shifting
From:   Jeff Layton <jlayton@kernel.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-fsdevel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>
Cc:     ericvh@gmail.com, lucho@ionkov.net, viro@zeniv.linux.org.uk,
        idryomov@gmail.com, mark@fasheh.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, v9fs-developer@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, linux-btrfs@vger.kernel.org,
        clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        stable@vger.kernel.org
Date:   Tue, 06 Oct 2020 13:20:42 -0400
In-Reply-To: <20201004180428.14494-4-willy@infradead.org>
References: <20201004180428.14494-1-willy@infradead.org>
         <20201004180428.14494-4-willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 2020-10-04 at 19:04 +0100, Matthew Wilcox (Oracle) wrote:
> On 32-bit systems, this shift will overflow for files larger than 4GB.
> 
> Cc: stable@vger.kernel.org
> Fixes: 61f68816211e ("ceph: check caps in filemap_fault and page_mkwrite")
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/ceph/addr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 6ea761c84494..970e5a094035 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -1522,7 +1522,7 @@ static vm_fault_t ceph_filemap_fault(struct vm_fault *vmf)
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	struct ceph_file_info *fi = vma->vm_file->private_data;
>  	struct page *pinned_page = NULL;
> -	loff_t off = vmf->pgoff << PAGE_SHIFT;
> +	loff_t off = (loff_t)vmf->pgoff << PAGE_SHIFT;
>  	int want, got, err;
>  	sigset_t oldset;
>  	vm_fault_t ret = VM_FAULT_SIGBUS;


I went ahead and merged this into the ceph-client/testing branch. Given
how old this bug is, I don't see a real need to rush this into v5.9, but
if we have any other patches going in before that ships, then it might
be good to send this one along too.
-- 
Jeff Layton <jlayton@kernel.org>

