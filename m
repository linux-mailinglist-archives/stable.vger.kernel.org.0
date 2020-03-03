Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB34617817C
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388264AbgCCSCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:02:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:47364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388261AbgCCSCi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:02:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09A0D20836;
        Tue,  3 Mar 2020 18:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258557;
        bh=UOJy3pLs5Fs1mlGGncBPdJXTbv+3LRVXAKJbhH46Fm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sKN+Pq5mxPNK65EI0L0OLGOiPo9qYlR4909ffLUGv3cQ1BbORAnghyqrbH11Ty1jm
         iyh8hwdUfCFmbdN6AEMZIy2JBFm9lXt0I3hM207IiYa5IlGL7UdzG0ZXtIhCPjkPom
         +SRfeIpOfyGzKMbqpdUypzZkbsXXa8xwQ8NWZS2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH 4.19 67/87] namei: only return -ECHILD from follow_dotdot_rcu()
Date:   Tue,  3 Mar 2020 18:43:58 +0100
Message-Id: <20200303174356.329220763@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
References: <20200303174349.075101355@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aleksa Sarai <cyphar@cyphar.com>

commit 2b98149c2377bff12be5dd3ce02ae0506e2dd613 upstream.

It's over-zealous to return hard errors under RCU-walk here, given that
a REF-walk will be triggered for all other cases handling ".." under
RCU.

The original purpose of this check was to ensure that if a rename occurs
such that a directory is moved outside of the bind-mount which the
resolution started in, it would be detected and blocked to avoid being
able to mess with paths outside of the bind-mount. However, triggering a
new REF-walk is just as effective a solution.

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Fixes: 397d425dc26d ("vfs: Test for and handle paths that are unreachable from their mnt_root")
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1368,7 +1368,7 @@ static int follow_dotdot_rcu(struct name
 			nd->path.dentry = parent;
 			nd->seq = seq;
 			if (unlikely(!path_connected(&nd->path)))
-				return -ENOENT;
+				return -ECHILD;
 			break;
 		} else {
 			struct mount *mnt = real_mount(nd->path.mnt);


