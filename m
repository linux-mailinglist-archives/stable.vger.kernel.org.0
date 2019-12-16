Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3CA111FCCB
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 03:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfLPCZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 21:25:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:41972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbfLPCZN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Dec 2019 21:25:13 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91B4D2067C;
        Mon, 16 Dec 2019 02:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576463112;
        bh=o2HQEvr31W65ynaJUSGAkcI56NiGQUNS7LPI+0zKVGc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HCg/JGDmB8U6fSh/gDt3WggXSr1DJA0qLYojgBAbaoGgIeATjtqhQO1TujJ7gS5Lr
         pXTsD897piKM8QnyS8yzyQaTJ6eFilcMo2G+KsX3WLMopifRKw9Aw81B90xkPY6UfG
         JXljTfMhejt7BitGz7fpUILl3aKintjFUM16IlsU=
Date:   Sun, 15 Dec 2019 21:25:11 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     jeffm@suse.com, jack@suse.cz, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] reiserfs: fix extended attributes on the
 root directory" failed to apply to 4.9-stable tree
Message-ID: <20191216022511.GC17708@sasha-vm>
References: <1576430119239212@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1576430119239212@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 15, 2019 at 06:15:19PM +0100, gregkh@linuxfoundation.org wrote:
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
>From 60e4cf67a582d64f07713eda5fcc8ccdaf7833e6 Mon Sep 17 00:00:00 2001
>From: Jeff Mahoney <jeffm@suse.com>
>Date: Thu, 24 Oct 2019 10:31:27 -0400
>Subject: [PATCH] reiserfs: fix extended attributes on the root directory
>
>Since commit d0a5b995a308 (vfs: Add IOP_XATTR inode operations flag)
>extended attributes haven't worked on the root directory in reiserfs.
>
>This is due to reiserfs conditionally setting the sb->s_xattrs handler
>array depending on whether it located or create the internal privroot
>directory.  It necessarily does this after the root inode is already
>read in.  The IOP_XATTR flag is set during inode initialization, so
>it never gets set on the root directory.
>
>This commit unconditionally assigns sb->s_xattrs and clears IOP_XATTR on
>internal inodes.  The old return values due to the conditional assignment
>are handled via open_xa_root, which now returns EOPNOTSUPP as the VFS
>would have done.
>
>Link: https://lore.kernel.org/r/20191024143127.17509-1-jeffm@suse.com
>CC: stable@vger.kernel.org
>Fixes: d0a5b995a308 ("vfs: Add IOP_XATTR inode operations flag")
>Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>Signed-off-by: Jan Kara <jack@suse.cz>

Just a simple conflict due to bc98a42c1f7d ("VFS: Convert sb->s_flags &
MS_RDONLY to sb_rdonly(sb)"). Fixed and queued up. 

-- 
Thanks,
Sasha
