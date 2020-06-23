Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B072046B7
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 03:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731690AbgFWB3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 21:29:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731572AbgFWB3u (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 21:29:50 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CC6520720;
        Tue, 23 Jun 2020 01:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592875789;
        bh=l7bxu7O3X+vmkUuujige1uKZed0ixYTnVS3sz9BaX1U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bRf8yR6aJ4QC5ppZPOtMcaJvDzAOodNrt7U+fXiJuExDk40+ib5u3hsuWesF/PqXD
         7vSa6DypI/D+mmc9N6MBgdvjOnoM3HhgEJIvHUtwMKkmqtn7M9REoPqSUVMWjjWqRw
         QMXSVbNYyY7iQ1Fi5iBI1VwN2HEq2HI6qXzO40Ds=
Date:   Mon, 22 Jun 2020 21:29:48 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     ebiggers@google.com, drosen@google.com, jaegeuk@kernel.org,
        krisman@collabora.co.uk, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk, yuchao0@huawei.com
Subject: Re: FAILED: patch "[PATCH] f2fs: avoid utf8_strncasecmp() with
 unstable name" failed to apply to 5.7-stable tree
Message-ID: <20200623012948.GU1931@sasha-vm>
References: <1592575583131183@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1592575583131183@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 19, 2020 at 04:06:23PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.7-stable tree.
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
>From fc3bb095ab02b9e7d89a069ade2cead15c64c504 Mon Sep 17 00:00:00 2001
>From: Eric Biggers <ebiggers@google.com>
>Date: Mon, 1 Jun 2020 13:08:05 -0700
>Subject: [PATCH] f2fs: avoid utf8_strncasecmp() with unstable name
>
>If the dentry name passed to ->d_compare() fits in dentry::d_iname, then
>it may be concurrently modified by a rename.  This can cause undefined
>behavior (possibly out-of-bounds memory accesses or crashes) in
>utf8_strncasecmp(), since fs/unicode/ isn't written to handle strings
>that may be concurrently modified.
>
>Fix this by first copying the filename to a stack buffer if needed.
>This way we get a stable snapshot of the filename.
>
>Fixes: 2c2eb7a300cd ("f2fs: Support case-insensitive file name lookups")
>Cc: <stable@vger.kernel.org> # v5.4+
>Cc: Al Viro <viro@zeniv.linux.org.uk>
>Cc: Daniel Rosenberg <drosen@google.com>
>Cc: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
>Signed-off-by: Eric Biggers <ebiggers@google.com>
>Reviewed-by: Chao Yu <yuchao0@huawei.com>
>Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

I've grabbed f874fa1c7c79 ("f2fs: split f2fs_d_compare() from
f2fs_match_name()") as a dependency and queued both for 5.7 and 5.4.

-- 
Thanks,
Sasha
