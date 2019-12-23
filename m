Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A093E129A7B
	for <lists+stable@lfdr.de>; Mon, 23 Dec 2019 20:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbfLWTnP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Dec 2019 14:43:15 -0500
Received: from [66.170.99.2] ([66.170.99.2]:12320 "EHLO
        sid-build-box.eng.vmware.com" rhost-flags-FAIL-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726934AbfLWTm5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Dec 2019 14:42:57 -0500
Received: by sid-build-box.eng.vmware.com (Postfix, from userid 1000)
        id 10F2ABA17BE; Tue, 24 Dec 2019 01:07:15 +0530 (IST)
From:   Siddharth Chandrasekaran <csiddharth@vmware.com>
To:     torvalds@linux-foundation.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org, jannh@google.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        siddharth@embedjournal.com,
        Siddharth Chandrasekaran <csiddharth@vmware.com>
Subject: [PATCH 4.4 2/2] filldir[64]: remove WARN_ON_ONCE() for bad directory entries
Date:   Tue, 24 Dec 2019 01:06:33 +0530
Message-Id: <a8c33067f36778068cc82be311d5df7adceec27a.1577129050.git.csiddharth@vmware.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1577128778.git.csiddharth@vmware.com>
References: <cover.1577128778.git.csiddharth@vmware.com>
In-Reply-To: <cover.1577129050.git.csiddharth@vmware.com>
References: <cover.1577129050.git.csiddharth@vmware.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit b9959c7a347d6adbb558fba7e36e9fef3cba3b07 ]

This was always meant to be a temporary thing, just for testing and to
see if it actually ever triggered.

The only thing that reported it was syzbot doing disk image fuzzing, and
then that warning is expected.  So let's just remove it before -rc4,
because the extra sanity testing should probably go to -stable, but we
don't want the warning to do so.

Reported-by: syzbot+3031f712c7ad5dd4d926@syzkaller.appspotmail.com
Fixes: 8a23eb804ca4 ("Make filldir[64]() verify the directory entry filename is valid")
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Siddharth Chandrasekaran <csiddharth@vmware.com>
---
 fs/readdir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/readdir.c b/fs/readdir.c
index 4c6ffe3..3494d7a 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -77,9 +77,9 @@ EXPORT_SYMBOL(iterate_dir);
  */
 static int verify_dirent_name(const char *name, int len)
 {
-	if (WARN_ON_ONCE(!len))
+	if (!len)
 		return -EIO;
-	if (WARN_ON_ONCE(memchr(name, '/', len)))
+	if (memchr(name, '/', len))
 		return -EIO;
 	return 0;
 }
-- 
2.7.4

