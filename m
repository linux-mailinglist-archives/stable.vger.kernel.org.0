Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD5063AFAD
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbiK1RoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:44:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233380AbiK1Rn0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:43:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D4E2B61E;
        Mon, 28 Nov 2022 09:40:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF810B80E9F;
        Mon, 28 Nov 2022 17:40:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC37C433C1;
        Mon, 28 Nov 2022 17:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657242;
        bh=sRmXIU9LXGrBYUAP7upYR+hqxJxpmyF8dsccJeW+ZIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ut8n/MlyVdqPgf+6ZSlaIYeg7vrfhNCQ8jGZWXAogV5+EuVsGpqVG63s+YUrGJKre
         eyIVVdr9B/101XkbjwKK5El/JvMLjgCcyItQRyHT0Mr2Gd1mNRRWfheHAA75MDS3Ew
         LYE5dd77C1Lv+xz1fv3A1vh0Fu6AN028RVlo8sJ9T+ghQZK5LP0J8xn4rFf6SC3iun
         AfhYIWdDIUvZNPdPi1t/ETqz6rqKH1Qxdj3lVlo70uLKdTRsGbmFUd1LQXJEg7EJQ4
         v8bP9AR7rdkdJXXk1MctiBvHOI3sbllXJSN4SixgVIwLmWr+U48DXZ0kztNM8mv6t1
         qlC4aR8pTG0/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jann Horn <jannh@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 07/24] fs: use acquire ordering in __fget_light()
Date:   Mon, 28 Nov 2022 12:40:07 -0500
Message-Id: <20221128174027.1441921-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128174027.1441921-1-sashal@kernel.org>
References: <20221128174027.1441921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

[ Upstream commit 7ee47dcfff1835ff75a794d1075b6b5f5462cfed ]

We must prevent the CPU from reordering the files->count read with the
FD table access like this, on architectures where read-read reordering is
possible:

    files_lookup_fd_raw()
                                  close_fd()
                                  put_files_struct()
    atomic_read(&files->count)

I would like to mark this for stable, but the stable rules explicitly say
"no theoretical races", and given that the FD table pointer and
files->count are explicitly stored in the same cacheline, this sort of
reordering seems quite unlikely in practice...

Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/file.c b/fs/file.c
index ee9317346702..214364e19d76 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -1029,7 +1029,16 @@ static unsigned long __fget_light(unsigned int fd, fmode_t mask)
 	struct files_struct *files = current->files;
 	struct file *file;
 
-	if (atomic_read(&files->count) == 1) {
+	/*
+	 * If another thread is concurrently calling close_fd() followed
+	 * by put_files_struct(), we must not observe the old table
+	 * entry combined with the new refcount - otherwise we could
+	 * return a file that is concurrently being freed.
+	 *
+	 * atomic_read_acquire() pairs with atomic_dec_and_test() in
+	 * put_files_struct().
+	 */
+	if (atomic_read_acquire(&files->count) == 1) {
 		file = files_lookup_fd_raw(files, fd);
 		if (!file || unlikely(file->f_mode & mask))
 			return 0;
-- 
2.35.1

