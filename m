Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A15E4A965A
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357922AbiBDJYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:24:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357739AbiBDJYG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:24:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BEC8C061765;
        Fri,  4 Feb 2022 01:24:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8F4E616A4;
        Fri,  4 Feb 2022 09:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58669C340F2;
        Fri,  4 Feb 2022 09:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966645;
        bh=b1aaZmEkpsr6AC1Fgfj2kfSj0T+Vlhtiyi8ifmsfxa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JkPjMjphaouZ7UspvUnrxeEHO23gP8L5r9o+LXz5C2eU9DpIgA3NXMUb2XGG6zrk0
         VKsdJkjhCNXhkRsTWYnVZiv7gYag1NrYgI5OILSJGDtVr9/d3aYqRz8ULrUsVDRtLW
         SOfDrpx3WYGMlj/h9cQg3cGA0plBXoGKgXGUOVt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Woithe <jwoithe@just42.net>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 09/32] lockd: fix server crash on reboot of client holding lock
Date:   Fri,  4 Feb 2022 10:22:19 +0100
Message-Id: <20220204091915.567321545@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091915.247906930@linuxfoundation.org>
References: <20220204091915.247906930@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

commit 6e7f90d163afa8fc2efd6ae318e7c20156a5621f upstream.

I thought I was iterating over the array when actually the iteration is
over the values contained in the array?

Ugh, keep it simple.

Symptoms were a null deference in vfs_lock_file() when an NFSv3 client
that previously held a lock came back up and sent a notify.

Reported-by: Jonathan Woithe <jwoithe@just42.net>
Fixes: 7f024fcd5c97 ("Keep read and write fds with each nlm_file")
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/lockd/svcsubs.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -179,19 +179,20 @@ nlm_delete_file(struct nlm_file *file)
 static int nlm_unlock_files(struct nlm_file *file)
 {
 	struct file_lock lock;
-	struct file *f;
 
 	lock.fl_type  = F_UNLCK;
 	lock.fl_start = 0;
 	lock.fl_end   = OFFSET_MAX;
-	for (f = file->f_file[0]; f <= file->f_file[1]; f++) {
-		if (f && vfs_lock_file(f, F_SETLK, &lock, NULL) < 0) {
-			pr_warn("lockd: unlock failure in %s:%d\n",
-				__FILE__, __LINE__);
-			return 1;
-		}
-	}
+	if (file->f_file[O_RDONLY] &&
+	    vfs_lock_file(file->f_file[O_RDONLY], F_SETLK, &lock, NULL))
+		goto out_err;
+	if (file->f_file[O_WRONLY] &&
+	    vfs_lock_file(file->f_file[O_WRONLY], F_SETLK, &lock, NULL))
+		goto out_err;
 	return 0;
+out_err:
+	pr_warn("lockd: unlock failure in %s:%d\n", __FILE__, __LINE__);
+	return 1;
 }
 
 /*


