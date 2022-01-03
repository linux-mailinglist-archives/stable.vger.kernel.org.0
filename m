Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBFCF4833A3
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233898AbiACOkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:40:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233962AbiACOih (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:38:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C862C07E5DC;
        Mon,  3 Jan 2022 06:34:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A72C61126;
        Mon,  3 Jan 2022 14:34:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0F3C36AED;
        Mon,  3 Jan 2022 14:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220465;
        bh=WPLmlQqOR7SkKcUjHuJ4sFpR5uksz7Q9+HJ4UudbmCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rmZfwXIvA6MBHuQW8FrE3LHDgWVeiBFxL0zAiSs+zSQDm4i3D1j3v9duDSYOg66or
         +0BRxREolgWGguBXRMWdvF6tul0oFZ39WIkve83ZqnnngxI8SlEe4cbNACR1pxFVpy
         jjtTBxnFXhXgM6+egG4dk9XgEVwYkYyWUN5yCmGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 70/73] fs/mount_setattr: always cleanup mount_kattr
Date:   Mon,  3 Jan 2022 15:24:31 +0100
Message-Id: <20220103142059.188665953@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

commit 012e332286e2bb9f6ac77d195f17e74b2963d663 upstream.

Make sure that finish_mount_kattr() is called after mount_kattr was
succesfully built in both the success and failure case to prevent
leaking any references we took when we built it.  We returned early if
path lookup failed thereby risking to leak an additional reference we
took when building mount_kattr when an idmapped mount was requested.

Cc: linux-fsdevel@vger.kernel.org
Cc: stable@vger.kernel.org
Fixes: 9caccd41541a ("fs: introduce MOUNT_ATTR_IDMAP")
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4263,12 +4263,11 @@ SYSCALL_DEFINE5(mount_setattr, int, dfd,
 		return err;
 
 	err = user_path_at(dfd, path, kattr.lookup_flags, &target);
-	if (err)
-		return err;
-
-	err = do_mount_setattr(&target, &kattr);
+	if (!err) {
+		err = do_mount_setattr(&target, &kattr);
+		path_put(&target);
+	}
 	finish_mount_kattr(&kattr);
-	path_put(&target);
 	return err;
 }
 


