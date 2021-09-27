Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9845D419B97
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236832AbhI0RUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:20:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237354AbhI0RSX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:18:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC43C61279;
        Mon, 27 Sep 2021 17:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762744;
        bh=vI5hGr6oxnMKKQwLNx99GwcxGhUWSQtXED7E11c5wcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IBICJiMMpbg67FJJa92miarsAnRIMSbm4HIHRNrm0T56bbxOTTo4W5tfC6CqNa+am
         HCrZMWvOjLa2XuumUBVKDLl9PlA/7S2CQnfHaXdDlRRo8Gt5+XziLX6W7I9f4eA4dn
         VjHAJwFpxoof8FVw1LvUHXBSe+/moyFO7iMIAUnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli V <eliventer@gmail.com>,
        Anand Jain <anand.jain@oracle.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.14 036/162] btrfs: prevent __btrfs_dump_space_info() to underflow its free space
Date:   Mon, 27 Sep 2021 19:01:22 +0200
Message-Id: <20210927170234.733557846@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 0619b7901473c380abc05d45cf9c70bee0707db3 upstream.

It's not uncommon where __btrfs_dump_space_info() gets called
under over-commit situations.

In that case free space would underflow as total allocated space is not
enough to handle all the over-committed space.

Such underflow values can sometimes cause confusion for users enabled
enospc_debug mount option, and takes some seconds for developers to
convert the underflow value to signed result.

Just output the free space as s64 to avoid such problem.

Reported-by: Eli V <eliventer@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CAJtFHUSy4zgyhf-4d9T+KdJp9w=UgzC2A0V=VtmaeEpcGgm1-Q@mail.gmail.com/
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/space-info.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -414,9 +414,10 @@ static void __btrfs_dump_space_info(stru
 {
 	lockdep_assert_held(&info->lock);
 
-	btrfs_info(fs_info, "space_info %llu has %llu free, is %sfull",
+	/* The free space could be negative in case of overcommit */
+	btrfs_info(fs_info, "space_info %llu has %lld free, is %sfull",
 		   info->flags,
-		   info->total_bytes - btrfs_space_info_used(info, true),
+		   (s64)(info->total_bytes - btrfs_space_info_used(info, true)),
 		   info->full ? "" : "not ");
 	btrfs_info(fs_info,
 		"space_info total=%llu, used=%llu, pinned=%llu, reserved=%llu, may_use=%llu, readonly=%llu zone_unusable=%llu",


