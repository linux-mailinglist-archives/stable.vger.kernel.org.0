Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89BEA12C8D6
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387423AbfL2R5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:57:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:48750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732946AbfL2R5x (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:57:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCE35206DB;
        Sun, 29 Dec 2019 17:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642273;
        bh=i6RWq8MAUqRQwT6Hv4u28DExcfMhvAHzQe96GrJ3VB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yr/Np4Zt+bL/8tUuPv/YxpCa8ztV+p4S+9aPH2V2gajjLr9oH4Y1k/BdB1ZlczdDv
         sdHsH9ebep9w1OJo5DAndI8URa4uEfJx5DshZIKtsVvsiudUIVpz8BZUdB/tJSY2dk
         qami01Ef4zJdxNeiyfo0TLXCd4InGeoAd0PBlnUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.4 412/434] ext4: unlock on error in ext4_expand_extra_isize()
Date:   Sun, 29 Dec 2019 18:27:45 +0100
Message-Id: <20191229172730.122152887@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 7f420d64a08c1dcd65b27be82a27cf2bdb2e7847 upstream.

We need to unlock the xattr before returning on this error path.

Cc: stable@kernel.org # 4.13
Fixes: c03b45b853f5 ("ext4, project: expand inode extra size if possible")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20191213185010.6k7yl2tck3wlsdkt@kili.mountain
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6035,7 +6035,7 @@ int ext4_expand_extra_isize(struct inode
 	error = ext4_journal_get_write_access(handle, iloc->bh);
 	if (error) {
 		brelse(iloc->bh);
-		goto out_stop;
+		goto out_unlock;
 	}
 
 	error = __ext4_expand_extra_isize(inode, new_extra_isize, iloc,
@@ -6045,8 +6045,8 @@ int ext4_expand_extra_isize(struct inode
 	if (!error)
 		error = rc;
 
+out_unlock:
 	ext4_write_unlock_xattr(inode, &no_expand);
-out_stop:
 	ext4_journal_stop(handle);
 	return error;
 }


