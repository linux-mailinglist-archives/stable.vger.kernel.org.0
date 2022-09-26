Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 569C75EA026
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235788AbiIZKfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235978AbiIZKdp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:33:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A664F6BC;
        Mon, 26 Sep 2022 03:20:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 947CAB80835;
        Mon, 26 Sep 2022 10:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066B5C433C1;
        Mon, 26 Sep 2022 10:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187643;
        bh=/qy+wl376VZ2Qn1ipDOjXipIVOsRHSCbVcNW+nRvVyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KUWNpBeXVweOCgruM9wZuLLJXtZcErx7fl91quTFbHo+8RB6+qVlM0EQR6QL8Ycwz
         n/jXZTrVnPGBFfGbhYgiCGgz2YbNOvQcHlu9ixuP7b108a0jqAVPtp3hEQsfT2Zk2t
         KwOVUSdOwS67XLderFVYJcXiRbSxmhcwcDmllpLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 015/120] iomap: iomap that extends beyond EOF should be marked dirty
Date:   Mon, 26 Sep 2022 12:10:48 +0200
Message-Id: <20220926100751.145723992@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
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

From: Chandan Babu R <chandan.babu@oracle.com>

From: Dave Chinner <dchinner@redhat.com>

commit 7684e2c4384d5d1f884b01ab8bff2369e4db0bff upstream.

When doing a direct IO that spans the current EOF, and there are
written blocks beyond EOF that extend beyond the current write, the
only metadata update that needs to be done is a file size extension.

However, we don't mark such iomaps as IOMAP_F_DIRTY to indicate that
there is IO completion metadata updates required, and hence we may
fail to correctly sync file size extensions made in IO completion
when O_DSYNC writes are being used and the hardware supports FUA.

Hence when setting IOMAP_F_DIRTY, we need to also take into account
whether the iomap spans the current EOF. If it does, then we need to
mark it dirty so that IO completion will call generic_write_sync()
to flush the inode size update to stable storage correctly.

Fixes: 3460cac1ca76 ("iomap: Use FUA for pure data O_DSYNC DIO writes")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: removed the ext4 part; they'll handle it separately]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_iomap.c    |    7 +++++++
 include/linux/iomap.h |    2 ++
 2 files changed, 9 insertions(+)

--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1055,6 +1055,13 @@ xfs_file_iomap_begin(
 	trace_xfs_iomap_alloc(ip, offset, length, XFS_DATA_FORK, &imap);
 
 out_finish:
+	/*
+	 * Writes that span EOF might trigger an IO size update on completion,
+	 * so consider them to be dirty for the purposes of O_DSYNC even if
+	 * there is no other metadata changes pending or have been made here.
+	 */
+	if ((flags & IOMAP_WRITE) && offset + length > i_size_read(inode))
+		iomap->flags |= IOMAP_F_DIRTY;
 	return xfs_bmbt_to_iomap(ip, iomap, &imap, shared);
 
 out_found:
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -32,6 +32,8 @@ struct vm_fault;
  *
  * IOMAP_F_DIRTY indicates the inode has uncommitted metadata needed to access
  * written data and requires fdatasync to commit them to persistent storage.
+ * This needs to take into account metadata changes that *may* be made at IO
+ * completion, such as file size updates from direct IO.
  */
 #define IOMAP_F_NEW		0x01	/* blocks have been newly allocated */
 #define IOMAP_F_DIRTY		0x02	/* uncommitted metadata */


