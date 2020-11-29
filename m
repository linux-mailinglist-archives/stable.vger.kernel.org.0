Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A33E2C7827
	for <lists+stable@lfdr.de>; Sun, 29 Nov 2020 07:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbgK2GFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Nov 2020 01:05:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:47772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726076AbgK2GFs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Nov 2020 01:05:48 -0500
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 044D82076A;
        Sun, 29 Nov 2020 06:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606629907;
        bh=5aWFhJgbKoTM+X/d62wGGVwXdEBsZBjLZrpbYO/sMMM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=btwmUo94iBlYyhWD1fTlXmn98jsamsV6RyJnoykDVKGjXFeVmQzCFPfIwaK7bMCd8
         3RbgANHJlIc7OLY1Rg+wfSBdAjCMASEWnIlHyJAVDd4nOb3TcoKwo28SPXKN2gm9rQ
         bylgmH2XYJfCnW5H3z4RBjDrC43Yaf4NzZPs+o6I=
Date:   Sun, 29 Nov 2020 07:05:03 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Wen Yang <wenyang@linux.alibaba.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>, stable@vger.kernel.org
Subject: Re: [PATCH] exit: fix a race in release_task when flushing the dentry
Message-ID: <X8M6D7M6Rn4f0C9j@kroah.com>
References: <20201128064722.9106-1-wenyang@linux.alibaba.com>
 <X8IFADugB450PHp8@kroah.com>
 <24bd714d-f598-c7c6-6821-38fd9c1f4d2b@linux.alibaba.com>
 <X8JZJGG67tE4jngE@kroah.com>
 <b73daaf0-bd6d-5153-9155-ef3a8568a6f2@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b73daaf0-bd6d-5153-9155-ef3a8568a6f2@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 28, 2020 at 11:28:53PM +0800, Wen Yang wrote:
> 
> 
> 在 2020/11/28 下午10:05, Greg Kroah-Hartman 写道:
> > On Sat, Nov 28, 2020 at 09:59:09PM +0800, Wen Yang wrote:
> > > 
> > > 
> > > 在 2020/11/28 下午4:06, Greg Kroah-Hartman 写道:
> > > > On Sat, Nov 28, 2020 at 02:47:22PM +0800, Wen Yang wrote:
> > > > > [ Upstream commit 7bc3e6e55acf065500a24621f3b313e7e5998acf ]
> > > > 
> > > > No, that is not this commit at all.
> > > > 
> > > > What are you wanting to have happen here?
> > > > 
> > > > confused,
> > > > 
> > > > greg k-h
> > > > 
> > > 
> > > Thanks.
> > > Let's explain it briefly:
> > > 
> > > The dentries such as /proc/<pid>/ns/ipc have the DCACHE_OP_DELETE flag, they
> > > should be deleted when the process exits.
> > > Suppose the following race appears：
> > > 
> > > release_task                dput
> > > -> proc_flush_task
> > >                              ->  dentry->d_op->d_delete(dentry)
> > > -> __exit_signal
> > >                              -> dentry->d_lockref.count--  and return.
> > > 
> > > 
> > > In the proc_flush_task function, because another processe is using this
> > > dentry, it cannot be deleted;
> > > In the dput function, d_delete may be executed before __exit_signal (the pid
> > > has not been unhashed), so that d_delete returns false and the dentry can
> > > not be deleted.
> > > 
> > > So this dentry is still caches (count is 0), and its parent dentries are
> > > also caches, and those dentries can only be deleted when drop_caches is
> > > manually triggered.
> > > 
> > > 
> > > In the release_task function, we should move proc_flush_task after the
> > > tasklist_lock is released（Just like the commit
> > > 7bc3e6e55acf065500a24621f3b313e7e5998acf did).
> > 
> > I do not understand, is this a patch being submitted for the main kernel
> > tree, or for a stable kernel release?
> > 
> > If stable, please read:
> >      https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> > for how to do this properly.
> > 
> > If main kernel tree, you can't have the "Upstream commit" line in the
> > changelog text as that makes no sense at all.
> 
> 
> Hi,
> This patch is submitted to the stable branches (from 4.9.y
> to 5.6.y).
> 
> This problem can also be solved if the following patch could be ported to
> the stable branch:
> 7bc3e6e55acf ("proc: Use a list of inodes to flush from proc")
> 26dbc60f385f ("proc: Generalize proc_sys_prune_dcache into
> proc_prune_siblings_dcache")
> f90f3cafe8d5 ("proc: Use d_invalidate in proc_prune_siblings_dcache")
> 
> However, the above-mentioned patches modify too much code (more than 100
> lines), and there may also be some undiscovered bugs.
> 
> So the safer method may be to apply this small patch（also ported from the
> equivalent fix already exist in Linus’ tree）.
> 
> We will reformat the patch later.

We always prefer to take the original, upstream patches, instead of
one-off changes as almost always, those one-off changes end up being
wrong and hard to work with over time.

So if we need more than one patch to solve this reported problem, that's
fine, can you test the above series of patches and provide a backported
set of them that we can use for this?

thanks,

gre gk-h
