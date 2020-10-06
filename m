Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A51284AE6
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 13:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgJFL3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 07:29:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgJFL3D (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Oct 2020 07:29:03 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8ECD62078E;
        Tue,  6 Oct 2020 11:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601983743;
        bh=vV/cWTk5oZ3xCfPmOW1JyTYnqQAJ5XkLf+0bV/y1Ito=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Jlhl4S6lFeJYtGWHmUA4l515wPAaDd/izhoqUtrYXjms0ElqbF3M1ArUgFO1ky40k
         zer6Zj9SWbb2ipxs05ptZWJ6MDYoZRPh+rtKtTZ8YbwdQuR8Z44fKxafme5xp9Yxo5
         ryw9iFW4AEoas3dmsQFu+N/Z05Z69uSV6dPaytRg=
Message-ID: <c00f08a9891c878ee9483aa9d05b4e28c2a5791a.camel@kernel.org>
Subject: Re: [PATCH 3/7] ceph: Promote to unsigned long long before shifting
From:   Jeff Layton <jlayton@kernel.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-fsdevel@vger.kernel.org
Cc:     ericvh@gmail.com, lucho@ionkov.net, viro@zeniv.linux.org.uk,
        idryomov@gmail.com, mark@fasheh.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, v9fs-developer@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, linux-btrfs@vger.kernel.org,
        clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        stable@vger.kernel.org
Date:   Tue, 06 Oct 2020 07:29:00 -0400
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

Good catch! Would you like us to take this in via the ceph tree, or are
you planning to submit altogether upstream? Either way:

Reviewed-by: Jeff Layton <jlayton@kernel.org>

