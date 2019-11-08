Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E243F52A9
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 18:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727862AbfKHRgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 12:36:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:56064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726446AbfKHRgt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 12:36:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B601206C3;
        Fri,  8 Nov 2019 17:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573234606;
        bh=Z5PC9TyEJyhxYOxCrC1Zax/Nk+Czo1m2ho8nUruVkNU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xguf2wJbyG57vD6nZvUAZcr+NFro9D5/SmEP6fi4HIyRvdpOPq0Qp9dO246oSAqvi
         MWFjkK7uOldPAhVi74u9QN+dtnoCAvgKBIDNz/4IkjTsDylnK/SQbCGDD0X9jTHdRm
         V063nd/XVbYpItqoWQ+Yr3ZDiTrr60cOI1XJzBdw=
Date:   Fri, 8 Nov 2019 18:36:44 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "zhangyi (F)" <yi.zhang@huawei.com>
Cc:     stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH for linux 4.4.y/3.16.y] fs/dcache: move
 security_d_instantiate() behind attaching dentry to inode
Message-ID: <20191108173644.GA1210939@kroah.com>
References: <20191106094352.9665-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106094352.9665-1-yi.zhang@huawei.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 06, 2019 at 05:43:52PM +0800, zhangyi (F) wrote:
> During backport 1e2e547a93a "do d_instantiate/unlock_new_inode
> combinations safely", there was a error instantiating sequence of
> attaching dentry to inode and calling security_d_instantiate().
> 
> Before commit ce23e640133 "->getxattr(): pass dentry and inode as
> separate arguments" and b96809173e9 "security_d_instantiate(): move to
> the point prior to attaching dentry to inode", security_d_instantiate()
> should be called beind __d_instantiate(), otherwise it will trigger
> below problem when CONFIG_SECURITY_SMACK on ext4 was enabled because
> d_inode(dentry) used by ->getxattr() is NULL before __d_instantiate()
> instantiate inode.
> 
> [   31.858026] BUG: unable to handle kernel paging request at ffffffffffffff70
> ...
> [   31.882024] Call Trace:
> [   31.882378]  [<ffffffffa347f75c>] ext4_xattr_get+0x8c/0x3e0
> [   31.883195]  [<ffffffffa3489454>] ext4_xattr_security_get+0x24/0x40
> [   31.884086]  [<ffffffffa336a56b>] generic_getxattr+0x5b/0x90
> [   31.884907]  [<ffffffffa3700514>] smk_fetch+0xb4/0x150
> [   31.885634]  [<ffffffffa3700772>] smack_d_instantiate+0x1c2/0x550
> [   31.886508]  [<ffffffffa36f9a5a>] security_d_instantiate+0x3a/0x80
> [   31.887389]  [<ffffffffa3353b26>] d_instantiate_new+0x36/0x130
> [   31.888223]  [<ffffffffa342b1ef>] ext4_mkdir+0x4af/0x6a0
> [   31.888928]  [<ffffffffa3343470>] vfs_mkdir+0x100/0x280
> [   31.889536]  [<ffffffffa334b086>] SyS_mkdir+0xb6/0x170
> [   31.890255]  [<ffffffffa307c855>] ? trace_do_page_fault+0x95/0x2b0
> [   31.891134]  [<ffffffffa3c5e078>] entry_SYSCALL_64_fastpath+0x18/0x73
> 
> Cc: <stable@vger.kernel.org> # 3.16, 4.4
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> ---
>  fs/dcache.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Now queued up for 4.4.y, thanks.

greg k-h
