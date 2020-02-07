Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDA50155003
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 02:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgBGBVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 20:21:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:45258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726597AbgBGBVm (ORCPT <rfc822;Stable@vger.kernel.org>);
        Thu, 6 Feb 2020 20:21:42 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D13522082E;
        Fri,  7 Feb 2020 01:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581038502;
        bh=LurDkaUhAuwghfmvIVFYwS/cdvisXh7A5RtdByIAI5U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U7hXUfAyEjaOHWeO4iNcTgTWXpyQX3FtK9c6FuKc8hHLqz5t48ZO6JwAgf+5kcZGs
         mFaex2bNMhb5I/xw00ManYMYQk++PSXQ0+GzMAhk5+LX5E8f49QjWueaQGoP+qZHlb
         +e5U+cRQFqV55bPEiPuCmONZsviYkgMZYqE53W/w=
Date:   Thu, 6 Feb 2020 20:21:40 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     chengzhihao1@huawei.com, Stable@vger.kernel.org, richard@nod.at,
        yi.zhang@huawei.com
Subject: Re: FAILED: patch "[PATCH] ubifs: Fix deadlock in concurrent
 bulk-read and writepage" failed to apply to 4.9-stable tree
Message-ID: <20200207012140.GS31482@sasha-vm>
References: <1581016848106213@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1581016848106213@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 06, 2020 at 08:20:48PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.9-stable tree.
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
>From f5de5b83303e61b1f3fb09bd77ce3ac2d7a475f2 Mon Sep 17 00:00:00 2001
>From: Zhihao Cheng <chengzhihao1@huawei.com>
>Date: Sat, 11 Jan 2020 17:50:36 +0800
>Subject: [PATCH] ubifs: Fix deadlock in concurrent bulk-read and writepage
>MIME-Version: 1.0
>Content-Type: text/plain; charset=UTF-8
>Content-Transfer-Encoding: 8bit
>
>In ubifs, concurrent execution of writepage and bulk read on the same file
>may cause ABBA deadlock, for example (Reproduce method see Link):
>
>Process A(Bulk-read starts from page4)         Process B(write page4 back)
>  vfs_read                                       wb_workfn or fsync
>  ...                                            ...
>  generic_file_buffered_read                     write_cache_pages
>    ubifs_readpage                                 LOCK(page4)
>
>      ubifs_bulk_read                              ubifs_writepage
>        LOCK(ui->ui_mutex)                           ubifs_write_inode
>
>	  ubifs_do_bulk_read                           LOCK(ui->ui_mutex)
>	    find_or_create_page(alloc page4)                  ↑
>	      LOCK(page4)                   <--     ABBA deadlock occurs!
>
>In order to ensure the serialization execution of bulk read, we can't
>remove the big lock 'ui->ui_mutex' in ubifs_bulk_read(). Instead, we
>allow ubifs_do_bulk_read() to lock page failed by replacing
>find_or_create_page(FGP_LOCK) with
>pagecache_get_page(FGP_LOCK | FGP_NOWAIT).
>
>Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
>Suggested-by: zhangyi (F) <yi.zhang@huawei.com>
>Cc: <Stable@vger.kernel.org>
>Fixes: 4793e7c5e1c ("UBIFS: add bulk-read facility")
>Link: https://bugzilla.kernel.org/show_bug.cgi?id=206153
>Signed-off-by: Richard Weinberger <richard@nod.at>

I took in 480a1a6a3ef6 ("ubifs: Change gfp flags in page allocation for
bulk read") as dependency and queued both for 4.9 and 4.4.

-- 
Thanks,
Sasha
