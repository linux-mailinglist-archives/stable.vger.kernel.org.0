Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B728F5EA164
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbiIZKur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236755AbiIZKtO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:49:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E2757E0E;
        Mon, 26 Sep 2022 03:26:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3645B80682;
        Mon, 26 Sep 2022 10:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5453BC433D6;
        Mon, 26 Sep 2022 10:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187991;
        bh=7OG+ozUgsljxL0mxgfSztPkfWo2U65pN0r3LGQwhvuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IRO785qBPfGSoyioUe9Jy3tc0zfyBxHwYvJ0SaA7hsA775PquJb7j6EZmHeITBFE2
         G+XVTVPHrsODhiVrfKLROZfpB5zDk0KY1peSvjWBqo8xiyRpWOwd2e4/EjZak4MU8S
         hUTNfq7zBeFCvmN0u2lPwZ/WLm/XZG3V0/gSdudI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 111/120] xfs: constify the buffer pointer arguments to error functions
Date:   Mon, 26 Sep 2022 12:12:24 +0200
Message-Id: <20220926100754.992590269@linuxfoundation.org>
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

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit d243b89a611e83dc97ce7102419360677a664076 upstream.

Some of the xfs error message functions take a pointer to a buffer that
will be dumped to the system log.  The logging functions don't change
the contents, so constify all the parameters.  This enables the next
patch to ensure that we log bad metadata when we encounter it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_error.c   |    6 +++---
 fs/xfs/xfs_error.h   |    6 +++---
 fs/xfs/xfs_message.c |    2 +-
 fs/xfs/xfs_message.h |    2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -329,7 +329,7 @@ xfs_corruption_error(
 	const char		*tag,
 	int			level,
 	struct xfs_mount	*mp,
-	void			*buf,
+	const void		*buf,
 	size_t			bufsize,
 	const char		*filename,
 	int			linenum,
@@ -350,7 +350,7 @@ xfs_buf_verifier_error(
 	struct xfs_buf		*bp,
 	int			error,
 	const char		*name,
-	void			*buf,
+	const void		*buf,
 	size_t			bufsz,
 	xfs_failaddr_t		failaddr)
 {
@@ -402,7 +402,7 @@ xfs_inode_verifier_error(
 	struct xfs_inode	*ip,
 	int			error,
 	const char		*name,
-	void			*buf,
+	const void		*buf,
 	size_t			bufsz,
 	xfs_failaddr_t		failaddr)
 {
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -12,16 +12,16 @@ extern void xfs_error_report(const char
 			const char *filename, int linenum,
 			xfs_failaddr_t failaddr);
 extern void xfs_corruption_error(const char *tag, int level,
-			struct xfs_mount *mp, void *buf, size_t bufsize,
+			struct xfs_mount *mp, const void *buf, size_t bufsize,
 			const char *filename, int linenum,
 			xfs_failaddr_t failaddr);
 extern void xfs_buf_verifier_error(struct xfs_buf *bp, int error,
-			const char *name, void *buf, size_t bufsz,
+			const char *name, const void *buf, size_t bufsz,
 			xfs_failaddr_t failaddr);
 extern void xfs_verifier_error(struct xfs_buf *bp, int error,
 			xfs_failaddr_t failaddr);
 extern void xfs_inode_verifier_error(struct xfs_inode *ip, int error,
-			const char *name, void *buf, size_t bufsz,
+			const char *name, const void *buf, size_t bufsz,
 			xfs_failaddr_t failaddr);
 
 #define	XFS_ERROR_REPORT(e, lvl, mp)	\
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -105,7 +105,7 @@ assfail(char *expr, char *file, int line
 }
 
 void
-xfs_hex_dump(void *p, int length)
+xfs_hex_dump(const void *p, int length)
 {
 	print_hex_dump(KERN_ALERT, "", DUMP_PREFIX_OFFSET, 16, 1, p, length, 1);
 }
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -60,6 +60,6 @@ do {									\
 extern void assfail(char *expr, char *f, int l);
 extern void asswarn(char *expr, char *f, int l);
 
-extern void xfs_hex_dump(void *p, int length);
+extern void xfs_hex_dump(const void *p, int length);
 
 #endif	/* __XFS_MESSAGE_H */


