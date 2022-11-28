Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A8263AF20
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233152AbiK1Ri4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:38:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233113AbiK1Rif (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:38:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D6EA450;
        Mon, 28 Nov 2022 09:38:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1B88B80E9C;
        Mon, 28 Nov 2022 17:38:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20452C433B5;
        Mon, 28 Nov 2022 17:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657102;
        bh=OvIH+/rzbE4iIJMXArCK3MshVpQL1tOZGfQMHYX+yj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eoDM5jRpjsRGljFg1j/wCGiD9sFLtLYvIJP93yp/3FFe7nSl9UPBKQZMCf8mQ+H5w
         gfG11N2r7PoZ6exOGtBCy6Cv2Ve0DPlTr4PrnQxotYf1fSHQnKACvU3MNKhEp19c/x
         CXfvDspgV2yGBITOzP3ydHOLknDJVrr7LpNRwnWgidkAqxXdLSFF9TSDY6IiQIUxHQ
         kgePVySZhpVcaagdi5dYNprq1tmKYEipib0VC/+YetGFITiIv/xMsjtNx1cB8X1EJQ
         lr77ax3e2RPnQGMs1ZkuOfFnOZrFFVgaRaNnW/kSi7FvEsANyPj2nI+GbU4XaCPFO6
         LLtAU6oOoMk5g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jann Horn <jannh@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 13/39] fs: use acquire ordering in __fget_light()
Date:   Mon, 28 Nov 2022 12:35:53 -0500
Message-Id: <20221128173642.1441232-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128173642.1441232-1-sashal@kernel.org>
References: <20221128173642.1441232-1-sashal@kernel.org>
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
index 3bcc1ecc314a..57af5f8375fd 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -1002,7 +1002,16 @@ static unsigned long __fget_light(unsigned int fd, fmode_t mask)
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

