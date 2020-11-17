Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469692B609E
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729563AbgKQNLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:11:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:40600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729566AbgKQNLB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:11:01 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A53282468F;
        Tue, 17 Nov 2020 13:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618661;
        bh=FMe3+cidUXwh7oU0VJ8FO/Sh9sI6b1E2WHCLQB+w8Qs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c/5KwFoXVROIes3zIf/SoWouGoMNXpCXjnlBjqR392vTohcWqLQHLVnHs5bZDtgDH
         Cip1f1ta3FOYqk+Pfvt5rJ7Ni4P0P2nRdNMB8TtNAoynGMSgudH+zTBp0TX6TU6oFZ
         B5bugXcTBxIW8gL2PJjftTHlcgKOgNPpFeMjpdzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Tao Ma <boyu.mt@taobao.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Andreas Dilger <adilger@dilger.ca>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 4.9 44/78] ext4: unlock xattr_sem properly in ext4_inline_data_truncate()
Date:   Tue, 17 Nov 2020 14:05:10 +0100
Message-Id: <20201117122111.257308617@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122109.116890262@linuxfoundation.org>
References: <20201117122109.116890262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joseph Qi <joseph.qi@linux.alibaba.com>

commit 7067b2619017d51e71686ca9756b454de0e5826a upstream.

It takes xattr_sem to check inline data again but without unlock it
in case not have. So unlock it before return.

Fixes: aef1c8513c1f ("ext4: let ext4_truncate handle inline data correctly")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Tao Ma <boyu.mt@taobao.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Link: https://lore.kernel.org/r/1604370542-124630-1-git-send-email-joseph.qi@linux.alibaba.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inline.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1890,6 +1890,7 @@ void ext4_inline_data_truncate(struct in
 
 	ext4_write_lock_xattr(inode, &no_expand);
 	if (!ext4_has_inline_data(inode)) {
+		ext4_write_unlock_xattr(inode, &no_expand);
 		*has_inline = 0;
 		ext4_journal_stop(handle);
 		return;


