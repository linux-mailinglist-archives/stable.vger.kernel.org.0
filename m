Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C79D412C42A
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbfL2R1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:27:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:49032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728360AbfL2R1I (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:27:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E219820409;
        Sun, 29 Dec 2019 17:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640428;
        bh=SQfUem9LKoWiyaPB/LHwDpgLiABk0OZo5aZ6uxWIf8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G2s0Z2eOhQHfjk7Sg+kkWPxWhY7w1qnEfCAzlQQ6ClVughGqHe+aVk/naDJfO/mua
         9glnNuH2Tr+9s/4cfTBAY8Z5MK5IHgZfyTOX8TPFaGJhXr0BB1euIXwou1pQGNHk6m
         W9XKrzdjiQhnOV7dJK0pCRRVB1GxpcN27CtmtDEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 4.14 153/161] ext4: unlock on error in ext4_expand_extra_isize()
Date:   Sun, 29 Dec 2019 18:20:01 +0100
Message-Id: <20191229162448.023040916@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
References: <20191229162355.500086350@linuxfoundation.org>
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
@@ -5874,7 +5874,7 @@ int ext4_expand_extra_isize(struct inode
 	error = ext4_journal_get_write_access(handle, iloc->bh);
 	if (error) {
 		brelse(iloc->bh);
-		goto out_stop;
+		goto out_unlock;
 	}
 
 	error = __ext4_expand_extra_isize(inode, new_extra_isize, iloc,
@@ -5884,8 +5884,8 @@ int ext4_expand_extra_isize(struct inode
 	if (!error)
 		error = rc;
 
+out_unlock:
 	ext4_write_unlock_xattr(inode, &no_expand);
-out_stop:
 	ext4_journal_stop(handle);
 	return error;
 }


