Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478884891E3
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240105AbiAJHhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241022AbiAJHec (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:34:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA54DC025246;
        Sun,  9 Jan 2022 23:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B25B611E2;
        Mon, 10 Jan 2022 07:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30349C36AE9;
        Mon, 10 Jan 2022 07:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799819;
        bh=2KlE26ZJLolX3C57NOq5F8IXmQohsH+1VYKtkYusRfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2W+qcuduYfIf14j9Hr9Lyl1r/w45Fzo/OrpuufpetDbNnQjna8WmeB11kkx/CzFO1
         2Wnop2iryJ4IRIPjkdrPqjDDx37UMR0ErP+3VgEqKqDhFzWbBd25FKh8+WUJHFRlc+
         6R4djoDlLvFcTNFkMUkLTpl2x2eimGgSlB0imyp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kirill Tkhai <ktkhai@virtuozzo.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 5.10 26/43] xfs: map unwritten blocks in XFS_IOC_{ALLOC,FREE}SP just like fallocate
Date:   Mon, 10 Jan 2022 08:23:23 +0100
Message-Id: <20220110071818.227285059@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071817.337619922@linuxfoundation.org>
References: <20220110071817.337619922@linuxfoundation.org>
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
@@ -686,7 +686,8 @@ xfs_ioc_space(
 
 	if (bf->l_start > XFS_ISIZE(ip)) {
 		error = xfs_alloc_file_space(ip, XFS_ISIZE(ip),
-				bf->l_start - XFS_ISIZE(ip), 0);
+				bf->l_start - XFS_ISIZE(ip),
+				XFS_BMAPI_PREALLOC);
 		if (error)
 			goto out_unlock;
 	}


