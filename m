Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70BA748915C
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239364AbiAJHb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:31:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58728 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239870AbiAJH3Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:29:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DA5AB81213;
        Mon, 10 Jan 2022 07:29:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87B6C36AED;
        Mon, 10 Jan 2022 07:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799763;
        bh=MMf2f0vu4IA7Jv+sYOUZISp3xfdeyBIn8UYYq1OeSGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dWBTCVrV0RPIdZUhrT/ja8gHJiaC6gXreZlfAGXAZYTaeB76SesMk6+Egn+qwJtCd
         Zg8onD5cJTsu4Y/YXcHO+unG7H+8RRggxhuwMKic4HDzOf6zBQpD/TXboa2wHitdFN
         cZcCS2xIgaM5cQbfL9iG6mZOTb9uskZqsDqlbueM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kirill Tkhai <ktkhai@virtuozzo.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 5.4 22/34] xfs: map unwritten blocks in XFS_IOC_{ALLOC,FREE}SP just like fallocate
Date:   Mon, 10 Jan 2022 08:23:17 +0100
Message-Id: <20220110071816.398154419@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071815.647309738@linuxfoundation.org>
References: <20220110071815.647309738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

commit 983d8e60f50806f90534cc5373d0ce867e5aaf79 upstream.

The old ALLOCSP/FREESP ioctls in XFS can be used to preallocate space at
the end of files, just like fallocate and RESVSP.  Make the behavior
consistent with the other ioctls.

Reported-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_ioctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -714,7 +714,8 @@ xfs_ioc_space(
 		flags |= XFS_PREALLOC_CLEAR;
 		if (bf->l_start > XFS_ISIZE(ip)) {
 			error = xfs_alloc_file_space(ip, XFS_ISIZE(ip),
-					bf->l_start - XFS_ISIZE(ip), 0);
+					bf->l_start - XFS_ISIZE(ip),
+					XFS_BMAPI_PREALLOC);
 			if (error)
 				goto out_unlock;
 		}


