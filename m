Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 112F82B4FB4
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 19:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732435AbgKPSbk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 13:31:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:41826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388671AbgKPSb1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Nov 2020 13:31:27 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AA252231B;
        Mon, 16 Nov 2020 18:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605551486;
        bh=DSyphZecZaJDLhl3SAn5wJ+988r1JkD9wiG/+WmgEVQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A11HhK2hy9ihhEf9vdXQO6XPoFVOKk2oaXr1Z/u+bSRYwPToivMO2QxL73e1Jokcr
         VmweE9rz9yfJX/sUrlUgdiYfZNFES71fmk1HpXQZVOOn2MaZPgtdfcy664RhHwusav
         6hR5v2SMOc7g4sg7h7uyPlAa2HBv73qiv1G7y4Y8=
Date:   Mon, 16 Nov 2020 19:32:16 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Gao Xiang <hsiangkao@aol.com>
Cc:     stable@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        Gao Xiang <hsiangkao@redhat.com>, nl6720 <nl6720@gmail.com>,
        Chao Yu <yuchao0@huawei.com>
Subject: Re: [PATCH 4.19.y] erofs: derive atime instead of leaving it empty
Message-ID: <X7LFsF5+X8nwNhd3@kroah.com>
References: <160554164363107@kroah.com>
 <20201116164737.4184-1-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116164737.4184-1-hsiangkao@aol.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 17, 2020 at 12:47:37AM +0800, Gao Xiang wrote:
> From: Gao Xiang <hsiangkao@redhat.com>
> 
> commit d3938ee23e97bfcac2e0eb6b356875da73d700df upstream.
> 
> EROFS has _only one_ ondisk timestamp (ctime is currently
> documented and recorded, we might also record mtime instead
> with a new compat feature if needed) for each extended inode
> since EROFS isn't mainly for archival purposes so no need to
> keep all timestamps on disk especially for Android scenarios
> due to security concerns. Also, romfs/cramfs don't have their
> own on-disk timestamp, and squashfs only records mtime instead.
> 
> Let's also derive access time from ondisk timestamp rather than
> leaving it empty, and if mtime/atime for each file are really
> needed for specific scenarios as well, we can also use xattrs
> to record them then.
> 
> Link: https://lore.kernel.org/r/20201031195102.21221-1-hsiangkao@aol.com
> [ Gao Xiang: It'd be better to backport for user-friendly concern. ]
> Fixes: 431339ba9042 ("staging: erofs: add inode operations")
> Cc: stable <stable@vger.kernel.org> # 4.19+
> Reported-by: nl6720 <nl6720@gmail.com>
> Reviewed-by: Chao Yu <yuchao0@huawei.com>
> [ Gao Xiang: Manually backport to 4.19.y due to trivial conflicts. ]
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  drivers/staging/erofs/inode.c | 21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)

Now queued up, thanks for the backport!

greg k-h
