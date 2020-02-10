Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0C3157561
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729759AbgBJMke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:40:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:40858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728405AbgBJMkd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:33 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC50524681;
        Mon, 10 Feb 2020 12:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338432;
        bh=CpLcdBXpLAY7Mi1THkNhFo1NTC21A9vtFyD/9QcbqPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DtR8ih9DI6b/VIwJJkU4Dljspfp/wGmCW2TkNc4pEKOrvycx0Wudd4FOkgfld93Yv
         fcagLAsP63doQ+cfewxKQP5HWg5mCr3pIQmVt6ncnqWg0LtvVkPvrT7QJnIx22/UIb
         eX41usujT+cw44+7OGKbS0zIzoC3FeKTfBRSjXm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.5 121/367] fs: allow deduplication of eof block into the end of the destination file
Date:   Mon, 10 Feb 2020 04:30:34 -0800
Message-Id: <20200210122435.924713146@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit a5e6ea18e3d132be4716eb5fdd520c2c234e3003 upstream.

We always round down, to a multiple of the filesystem's block size, the
length to deduplicate at generic_remap_check_len().  However this is only
needed if an attempt to deduplicate the last block into the middle of the
destination file is requested, since that leads into a corruption if the
length of the source file is not block size aligned.  When an attempt to
deduplicate the last block into the end of the destination file is
requested, we should allow it because it is safe to do it - there's no
stale data exposure and we are prepared to compare the data ranges for
a length not aligned to the block (or page) size - in fact we even do
the data compare before adjusting the deduplication length.

After btrfs was updated to use the generic helpers from VFS (by commit
34a28e3d77535e ("Btrfs: use generic_remap_file_range_prep() for cloning
and deduplication")) we started to have user reports of deduplication
not reflinking the last block anymore, and whence users getting lower
deduplication scores.  The main use case is deduplication of entire
files that have a size not aligned to the block size of the filesystem.

We already allow cloning the last block to the end (and beyond) of the
destination file, so allow for deduplication as well.

Link: https://lore.kernel.org/linux-btrfs/2019-1576167349.500456@svIo.N5dq.dFFD/
CC: stable@vger.kernel.org # 5.1+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/read_write.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1777,10 +1777,9 @@ static int remap_verify_area(struct file
  * else.  Assume that the offsets have already been checked for block
  * alignment.
  *
- * For deduplication we always scale down to the previous block because we
- * can't meaningfully compare post-EOF contents.
- *
- * For clone we only link a partial EOF block above the destination file's EOF.
+ * For clone we only link a partial EOF block above or at the destination file's
+ * EOF.  For deduplication we accept a partial EOF block only if it ends at the
+ * destination file's EOF (can not link it into the middle of a file).
  *
  * Shorten the request if possible.
  */
@@ -1796,8 +1795,7 @@ static int generic_remap_check_len(struc
 	if ((*len & blkmask) == 0)
 		return 0;
 
-	if ((remap_flags & REMAP_FILE_DEDUP) ||
-	    pos_out + *len < i_size_read(inode_out))
+	if (pos_out + *len < i_size_read(inode_out))
 		new_len &= ~blkmask;
 
 	if (new_len == *len)


