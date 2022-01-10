Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A9248912C
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239856AbiAJHaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:30:01 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57688 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239896AbiAJH1g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:27:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87868B8120C;
        Mon, 10 Jan 2022 07:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA01C36AE9;
        Mon, 10 Jan 2022 07:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799653;
        bh=/275k3NQs3rCN7zLFL6qyXr2y6x2wVhE8XDWgRNAVbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G+j90eIaq4+DmYIqSxn1c+njhSIyyBws7DuWi7SxbotgVelp6GwXMc+aK/VuG6mIG
         V4a4NDgfmBMhgw7j0t2u8drXj8RioHmRSjDZ5f7INWGlbQ0Ux/qgG9tJrtBEER/3Jd
         DNjb/lshUjT0dyQTLQmcZPFhRgXsT7rLYaH38d4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kirill Tkhai <ktkhai@virtuozzo.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 4.19 11/21] xfs: map unwritten blocks in XFS_IOC_{ALLOC,FREE}SP just like fallocate
Date:   Mon, 10 Jan 2022 08:23:12 +0100
Message-Id: <20220110071814.327260155@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071813.967414697@linuxfoundation.org>
References: <20220110071813.967414697@linuxfoundation.org>
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
@@ -701,7 +701,8 @@ xfs_ioc_space(
 		flags |= XFS_PREALLOC_CLEAR;
 		if (bf->l_start > XFS_ISIZE(ip)) {
 			error = xfs_alloc_file_space(ip, XFS_ISIZE(ip),
-					bf->l_start - XFS_ISIZE(ip), 0);
+					bf->l_start - XFS_ISIZE(ip),
+					XFS_BMAPI_PREALLOC);
 			if (error)
 				goto out_unlock;
 		}


