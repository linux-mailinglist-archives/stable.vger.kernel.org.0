Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14C275F5398
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 13:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiJELg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 07:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiJELgc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 07:36:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4718878BCA;
        Wed,  5 Oct 2022 04:34:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA0E7B81D88;
        Wed,  5 Oct 2022 11:34:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38049C433D6;
        Wed,  5 Oct 2022 11:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664969665;
        bh=qacnJnwtsB+NvtpaVE0cc0ElSXFbbpAHrbEIXpu35cU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=craXUsE7+IUOPMQzyR9ImJOL4u75daPHJOjzHN4F73vtKyjOokZIUz+68bvIWz5ip
         wqEu2JchD7AbZyGO8TUtXO9RyUoh8J6DnrZ2tdjLsQjqS9SDQTYHViNl2TwnlIpNsc
         5XijlIq4S4y1DLbpMI2iNgAZPDD7Z2xZqT6/cNao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 42/51] xfs: fix IOCB_NOWAIT handling in xfs_file_dio_aio_read
Date:   Wed,  5 Oct 2022 13:32:30 +0200
Message-Id: <20221005113212.237973105@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221005113210.255710920@linuxfoundation.org>
References: <20221005113210.255710920@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 7b53b868a1812a9a6ab5e69249394bd37f29ce2c upstream.

Direct I/O reads can also be used with RWF_NOWAIT & co.  Fix the inode
locking in xfs_file_dio_aio_read to take IOCB_NOWAIT into account.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_file.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -187,7 +187,12 @@ xfs_file_dio_aio_read(
 
 	file_accessed(iocb->ki_filp);
 
-	xfs_ilock(ip, XFS_IOLOCK_SHARED);
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED))
+			return -EAGAIN;
+	} else {
+		xfs_ilock(ip, XFS_IOLOCK_SHARED);
+	}
 	ret = iomap_dio_rw(iocb, to, &xfs_iomap_ops, NULL);
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 


