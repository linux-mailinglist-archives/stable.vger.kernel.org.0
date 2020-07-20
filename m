Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A55226903
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732893AbgGTQXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:23:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732869AbgGTQEk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:04:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D36CF2064B;
        Mon, 20 Jul 2020 16:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261079;
        bh=AafClQ3XCULb3Pi+0Rkj4mf/rKWsLAfTk+Fa6ONzUOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wHSM4RHc+P4bzKu9fLe81YhDSL91gImn6LV6CcV/1w52SBJc1bUF0CdbL/oqAwJD0
         WqcPW/fhPgEF+7j54ZyzXnuoxkicThWFbMlJZocxMnEAdwFKWtwgim4yR76irkbKO7
         eScScjf/IIiAVw1eoqWTL+guYyo3hIF6HxKZnCLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.4 171/215] ovl: relax WARN_ON() when decoding lower directory file handle
Date:   Mon, 20 Jul 2020 17:37:33 +0200
Message-Id: <20200720152828.308224453@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit 124c2de2c0aee96271e4ddab190083d8aa7aa71a upstream.

Decoding a lower directory file handle to overlay path with cold
inode/dentry cache may go as follows:

1. Decode real lower file handle to lower dir path
2. Check if lower dir is indexed (was copied up)
3. If indexed, get the upper dir path from index
4. Lookup upper dir path in overlay
5. If overlay path found, verify that overlay lower is the lower dir
   from step 1

On failure to verify step 5 above, user will get an ESTALE error and a
WARN_ON will be printed.

A mismatch in step 5 could be a result of lower directory that was renamed
while overlay was offline, after that lower directory has been copied up
and indexed.

This is a scripted reproducer based on xfstest overlay/052:

  # Create lower subdir
  create_dirs
  create_test_files $lower/lowertestdir/subdir
  mount_dirs
  # Copy up lower dir and encode lower subdir file handle
  touch $SCRATCH_MNT/lowertestdir
  test_file_handles $SCRATCH_MNT/lowertestdir/subdir -p -o $tmp.fhandle
  # Rename lower dir offline
  unmount_dirs
  mv $lower/lowertestdir $lower/lowertestdir.new/
  mount_dirs
  # Attempt to decode lower subdir file handle
  test_file_handles $SCRATCH_MNT -p -i $tmp.fhandle

Since this WARN_ON() can be triggered by user we need to relax it.

Fixes: 4b91c30a5a19 ("ovl: lookup connected ancestor of dir in inode cache")
Cc: <stable@vger.kernel.org> # v4.16+
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/overlayfs/export.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -482,7 +482,7 @@ static struct dentry *ovl_lookup_real_in
 	if (IS_ERR_OR_NULL(this))
 		return this;
 
-	if (WARN_ON(ovl_dentry_real_at(this, layer->idx) != real)) {
+	if (ovl_dentry_real_at(this, layer->idx) != real) {
 		dput(this);
 		this = ERR_PTR(-EIO);
 	}


