Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3E441858EF
	for <lists+stable@lfdr.de>; Sun, 15 Mar 2020 03:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbgCOCY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Mar 2020 22:24:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727923AbgCOCYN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 14 Mar 2020 22:24:13 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EC762082D;
        Sat, 14 Mar 2020 21:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584221808;
        bh=b6MuOpiS2xvMFw14CDhCFUowRT5zjT0d4DxRNwi5BuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fWV8HZeeCoTyeew/nQtxVFj+FOH7LTGMjRB5BeNfEtvSl96zaOVgU807U3sp12O5F
         +qlQvfrBjX/Q0YX0KeZ1JRgtWQsLIl7xRBMCdd4bCv0ZLEmxwCgEVH6XH6WLShQXQc
         hyx3SNr+OfmXJYFcUN1Eil+iyH+Gj5MM5N3OT0hw=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Vander Stoep <jeffv@google.com>,
        Jessica Yu <jeyu@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        NeilBrown <neilb@suse.com>, stable@vger.kernel.org
Subject: [PATCH v3 2/5] fs/filesystems.c: downgrade user-reachable WARN_ONCE() to pr_warn_once()
Date:   Sat, 14 Mar 2020 14:34:23 -0700
Message-Id: <20200314213426.134866-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200314213426.134866-1-ebiggers@kernel.org>
References: <20200314213426.134866-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

After request_module(), nothing is stopping the module from being
unloaded until someone takes a reference to it via try_get_module().

The WARN_ONCE() in get_fs_type() is thus user-reachable, via userspace
running 'rmmod' concurrently.

Since WARN_ONCE() is for kernel bugs only, not for user-reachable
situations, downgrade this warning to pr_warn_once().

Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: stable@vger.kernel.org
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jeff Vander Stoep <jeffv@google.com>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: NeilBrown <neilb@suse.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/filesystems.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/filesystems.c b/fs/filesystems.c
index 77bf5f95362da..90b8d879fbaf3 100644
--- a/fs/filesystems.c
+++ b/fs/filesystems.c
@@ -272,7 +272,9 @@ struct file_system_type *get_fs_type(const char *name)
 	fs = __get_fs_type(name, len);
 	if (!fs && (request_module("fs-%.*s", len, name) == 0)) {
 		fs = __get_fs_type(name, len);
-		WARN_ONCE(!fs, "request_module fs-%.*s succeeded, but still no fs?\n", len, name);
+		if (!fs)
+			pr_warn_once("request_module fs-%.*s succeeded, but still no fs?\n",
+				     len, name);
 	}
 
 	if (dot && fs && !(fs->fs_flags & FS_HAS_SUBTYPE)) {
-- 
2.25.1

