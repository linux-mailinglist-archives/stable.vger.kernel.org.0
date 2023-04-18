Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69ECB6E625A
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjDRMcD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbjDRMcC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:32:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2ABC1025B
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:31:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C180D63219
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:31:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E51C433EF;
        Tue, 18 Apr 2023 12:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821093;
        bh=g8R+N0EwuY4l9XfGazsLo6eXfchN0NVnfB19zBVpxvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qnWa0/sg0WSdht7k/gCQvAY/eGx3MANWb8QLsb6/Zf295p1RzTSBNcpsw4n+l1mWi
         mux/wuXfLiyycVGUmwwmgt++58E9W22DE4K3hbdOb6xw82jEQDw6N+VAotHzLM91Dj
         GNdIzrIYgXkgTZkR/hHUmvlqDFNUc0Ht+XcMdLfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.4 88/92] xfs: report corruption only as a regular error
Date:   Tue, 18 Apr 2023 14:22:03 +0200
Message-Id: <20230418120307.865257087@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 6519f708cc355c4834edbe1885c8542c0e7ef907 uptream.

[ Slightly modify fs/xfs/xfs_linux.h to resolve merge conflicts ]

Redefine XFS_IS_CORRUPT so that it reports corruptions only via
xfs_corruption_report.  Since these are on-disk contents (and not checks
of internal state), we don't ever want to panic the kernel.  This also
amends the corruption report to recommend unmounting and running
xfs_repair.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_error.c |    2 +-
 fs/xfs/xfs_linux.h |    6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -335,7 +335,7 @@ xfs_corruption_error(
 	int			linenum,
 	xfs_failaddr_t		failaddr)
 {
-	if (level <= xfs_error_level)
+	if (buf && level <= xfs_error_level)
 		xfs_hex_dump(buf, bufsize);
 	xfs_error_report(tag, level, mp, filename, linenum, failaddr);
 	xfs_alert(mp, "Corruption detected. Unmount and run xfs_repair");
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -217,6 +217,12 @@ int xfs_rw_bdev(struct block_device *bde
 #endif /* XFS_WARN */
 #endif /* DEBUG */
 
+#define XFS_IS_CORRUPT(mp, expr)	\
+	(unlikely(expr) ? xfs_corruption_error(#expr, XFS_ERRLEVEL_LOW, (mp), \
+					       NULL, 0, __FILE__, __LINE__, \
+					       __this_address), \
+			  true : false)
+
 #define STATIC static noinline
 
 #ifdef CONFIG_XFS_RT


