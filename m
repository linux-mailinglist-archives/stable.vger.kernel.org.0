Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2072E3EC
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 19:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbfE2Rwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 13:52:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbfE2Rwn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 13:52:43 -0400
Received: from localhost (unknown [207.225.69.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8938A23FF8;
        Wed, 29 May 2019 17:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559152362;
        bh=ZVcwYAEmaICNJkA5b/qdXnxBrlJWkMpDjry+SBbhcc8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=olMngbpl2JJbGLxKwc99PDY+b+3wUSzgXlzgsqnHt2tdEOC93QYWH2szS4zssh4+2
         eDEBWeVEcc45eQsFtK9gB/BqKLgAypMqAubCyQvpThmaC0H+Hsggn9C7MxidYXXGAp
         syDbU8TLtdABKrBxuORtoj0Y35dn+5cdFscqOwu0=
Date:   Wed, 29 May 2019 10:52:42 -0700
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     ocfs2-devel@oss.oracle.com, gechangwei@live.cn,
        daniel.sobe@nxp.com, akpm@linux-foundation.org,
        stable@vger.kernel.org, jiangqi903@gmail.com
Subject: Re: [PATCH v4] fs/ocfs2: fix race in ocfs2_dentry_attach_lock
Message-ID: <20190529175242.GA4431@kroah.com>
References: <20190529174636.22364-1-wen.gang.wang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529174636.22364-1-wen.gang.wang@oracle.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 29, 2019 at 10:46:36AM -0700, Wengang Wang wrote:
> ocfs2_dentry_attach_lock() can be executed in parallel threads against the
> same dentry. Make that race safe.
> The race is like this:
> 
>             thread A                               thread B
> 
> (A1) enter ocfs2_dentry_attach_lock,
> seeing dentry->d_fsdata is NULL,
> and no alias found by
> ocfs2_find_local_alias, so kmalloc
> a new ocfs2_dentry_lock structure
> to local variable "dl", dl1
> 
>                .....
> 
>                                     (B1) enter ocfs2_dentry_attach_lock,
>                                     seeing dentry->d_fsdata is NULL,
>                                     and no alias found by
>                                     ocfs2_find_local_alias so kmalloc
>                                     a new ocfs2_dentry_lock structure
>                                     to local variable "dl", dl2.
> 
>                                                    ......
> 
> (A2) set dentry->d_fsdata with dl1,
> call ocfs2_dentry_lock() and increase
> dl1->dl_lockres.l_ro_holders to 1 on
> success.
>               ......
> 
>                                     (B2) set dentry->d_fsdata with dl2
>                                     call ocfs2_dentry_lock() and increase
> 				    dl2->dl_lockres.l_ro_holders to 1 on
> 				    success.
> 
>                                                   ......
> 
> (A3) call ocfs2_dentry_unlock()
> and decrease
> dl2->dl_lockres.l_ro_holders to 0
> on success.
>              ....
> 
>                                     (B3) call ocfs2_dentry_unlock(),
>                                     decreasing
> 				    dl2->dl_lockres.l_ro_holders, but
> 				    see it's zero now, panic
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> Reported-by: Daniel Sobe <daniel.sobe@nxp.com>
> Tested-by: Daniel Sobe <daniel.sobe@nxp.com>
> Reviewed-by: Changwei Ge <gechangwei@live.cn>
> ---
> v4: return in place on race detection.
> 
> v3: add Reviewed-by, Reported-by and Tested-by only
> 
> v2: 1) removed lock on dentry_attach_lock at the first access of
>        dentry->d_fsdata since it helps very little.
>     2) do cleanups before freeing the duplicated dl
>     3) return after freeing the duplicated dl found.
> ---
> 
>  fs/ocfs2/dcache.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
