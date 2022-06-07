Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F86F5407D4
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347648AbiFGRwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349702AbiFGRv3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:51:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0DE713C35C;
        Tue,  7 Jun 2022 10:38:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 203266155F;
        Tue,  7 Jun 2022 17:38:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2787DC34115;
        Tue,  7 Jun 2022 17:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623480;
        bh=84J9qXdJDC7rUknfVU8U8l21hj/ztR4jR9pW95tvWUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mKGdnCOBQSao/yFvmwvlUv1Lv7iIhMEoq6llXorvvO6lfD4dCwSZ2rXPTmmiWXtnm
         KAxsGEmTtuEmwoKk+zTFnH/DaqJN7agipRw/zyTcgSwQcNN+jLV+VLLmnc86ebAa/P
         Qo43rpfgewEUZv0oX5Qtchq12C+CWbeKNnoci2hY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 434/452] xfs: restore shutdown check in mapped write fault path
Date:   Tue,  7 Jun 2022 19:04:51 +0200
Message-Id: <20220607164921.491238199@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit e4826691cc7e5458bcb659935d0092bcf3f08c20 upstream.

XFS triggers an iomap warning in the write fault path due to a
!PageUptodate() page if a write fault happens to occur on a page
that recently failed writeback. The iomap writeback error handling
code can clear the Uptodate flag if no portion of the page is
submitted for I/O. This is reproduced by fstest generic/019, which
combines various forms of I/O with simulated disk failures that
inevitably lead to filesystem shutdown (which then unconditionally
fails page writeback).

This is a regression introduced by commit f150b4234397 ("xfs: split
the iomap ops for buffered vs direct writes") due to the removal of
a shutdown check and explicit error return in the ->iomap_begin()
path used by the write fault path. The explicit error return
historically translated to a SIGBUS, but now carries on with iomap
processing where it complains about the unexpected state. Restore
the shutdown check to xfs_buffered_write_iomap_begin() to restore
historical behavior.

Fixes: f150b4234397 ("xfs: split the iomap ops for buffered vs direct writes")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_iomap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -870,6 +870,9 @@ xfs_buffered_write_iomap_begin(
 	int			allocfork = XFS_DATA_FORK;
 	int			error = 0;
 
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -EIO;
+
 	/* we can't use delayed allocations when using extent size hints */
 	if (xfs_get_extsz_hint(ip))
 		return xfs_direct_write_iomap_begin(inode, offset, count,


