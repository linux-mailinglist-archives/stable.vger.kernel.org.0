Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9F905EA298
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237514AbiIZLL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234739AbiIZLJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:09:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9989C520AD;
        Mon, 26 Sep 2022 03:35:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8A2DB80691;
        Mon, 26 Sep 2022 10:33:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F6BC433D6;
        Mon, 26 Sep 2022 10:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188409;
        bh=un+fMfDkfKr7GlPinYtqsWpS83xYwTGg7yXUxWNg6xE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BxvWdiC40Z5rSLmGriPpCIjSV0mY/6eYXODSfn3cc3Qp07fRngm14dj/VRlOgVhsA
         AHRqBcxt6n0GkPQ/JkUTkylzAz8vFMIlgD0cVI5ixCK+3dJsNWhjinIEvsJkC3JLXJ
         a63C+tlCjBA21DeES49gETWt+dffQmT7CZDzWKls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org
Subject: [PATCH 5.10 140/141] ext4: limit the number of retries after discarding preallocations blocks
Date:   Mon, 26 Sep 2022 12:12:46 +0200
Message-Id: <20220926100759.536419723@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

commit 80fa46d6b9e7b1527bfd2197d75431fd9c382161 upstream.

This patch avoids threads live-locking for hours when a large number
threads are competing over the last few free extents as they blocks
getting added and removed from preallocation pools.  From our bug
reporter:

   A reliable way for triggering this has multiple writers
   continuously write() to files when the filesystem is full, while
   small amounts of space are freed (e.g. by truncating a large file
   -1MiB at a time). In the local filesystem, this can be done by
   simply not checking the return code of write (0) and/or the error
   (ENOSPACE) that is set. Over NFS with an async mount, even clients
   with proper error checking will behave this way since the linux NFS
   client implementation will not propagate the server errors [the
   write syscalls immediately return success] until the file handle is
   closed. This leads to a situation where NFS clients send a
   continuous stream of WRITE rpcs which result in ERRNOSPACE -- but
   since the client isn't seeing this, the stream of writes continues
   at maximum network speed.

   When some space does appear, multiple writers will all attempt to
   claim it for their current write. For NFS, we may see dozens to
   hundreds of threads that do this.

   The real-world scenario of this is database backup tooling (in
   particular, github.com/mdkent/percona-xtrabackup) which may write
   large files (>1TiB) to NFS for safe keeping. Some temporary files
   are written, rewound, and read back -- all before closing the file
   handle (the temp file is actually unlinked, to trigger automatic
   deletion on close/crash.) An application like this operating on an
   async NFS mount will not see an error code until TiB have been
   written/read.

   The lockup was observed when running this database backup on large
   filesystems (64 TiB in this case) with a high number of block
   groups and no free space. Fragmentation is generally not a factor
   in this filesystem (~thousands of large files, mostly contiguous
   except for the parts written while the filesystem is at capacity.)

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4959,6 +4959,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t
 	ext4_fsblk_t block = 0;
 	unsigned int inquota = 0;
 	unsigned int reserv_clstrs = 0;
+	int retries = 0;
 	u64 seq;
 
 	might_sleep();
@@ -5061,7 +5062,8 @@ repeat:
 			ar->len = ac->ac_b_ex.fe_len;
 		}
 	} else {
-		if (ext4_mb_discard_preallocations_should_retry(sb, ac, &seq))
+		if (++retries < 3 &&
+		    ext4_mb_discard_preallocations_should_retry(sb, ac, &seq))
 			goto repeat;
 		/*
 		 * If block allocation fails then the pa allocated above


