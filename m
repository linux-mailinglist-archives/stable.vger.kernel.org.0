Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70FB6177FA2
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732071AbgCCRwB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:52:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:60254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732081AbgCCRwA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:52:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93D41206D5;
        Tue,  3 Mar 2020 17:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257920;
        bh=ala5iqwtAVhgx3k4LxKBFPyVmpRQnPLjInTzeG/NRUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kYmCMggwHSbDhcQhfiVFFiy3lXHwk8po2xKI7ivkWntDM6E05A+gXz/JW/z/Q6aP7
         b8VXEQRHiGd2oOWrm4Gv7fsPumG18PHvReXSyhdJP+bwCzV2b935UF/Rsm480oqZbh
         d13YJiCtLNMQjIagT/DijLhjZHbCqT5qj1IDSB50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 5.5 168/176] xfs: clear kernel only flags in XFS_IOC_ATTRMULTI_BY_HANDLE
Date:   Tue,  3 Mar 2020 18:43:52 +0100
Message-Id: <20200303174323.478185167@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 953aa9d136f53e226448dbd801a905c28f8071bf upstream.

Don't allow passing arbitrary flags as they change behavior including
memory allocation that the call stack is not prepared for.

Fixes: ddbca70cc45c ("xfs: allocate xattr buffer on demand")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/xfs/libxfs/xfs_attr.h |    7 +++++--
 fs/xfs/xfs_ioctl.c       |    2 ++
 fs/xfs/xfs_ioctl32.c     |    2 ++
 3 files changed, 9 insertions(+), 2 deletions(-)

--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -26,7 +26,7 @@ struct xfs_attr_list_context;
  *========================================================================*/
 
 
-#define ATTR_DONTFOLLOW	0x0001	/* -- unused, from IRIX -- */
+#define ATTR_DONTFOLLOW	0x0001	/* -- ignored, from IRIX -- */
 #define ATTR_ROOT	0x0002	/* use attrs in root (trusted) namespace */
 #define ATTR_TRUST	0x0004	/* -- unused, from IRIX -- */
 #define ATTR_SECURE	0x0008	/* use attrs in security namespace */
@@ -37,7 +37,10 @@ struct xfs_attr_list_context;
 #define ATTR_KERNOVAL	0x2000	/* [kernel] get attr size only, not value */
 
 #define ATTR_INCOMPLETE	0x4000	/* [kernel] return INCOMPLETE attr keys */
-#define ATTR_ALLOC	0x8000	/* allocate xattr buffer on demand */
+#define ATTR_ALLOC	0x8000	/* [kernel] allocate xattr buffer on demand */
+
+#define ATTR_KERNEL_FLAGS \
+	(ATTR_KERNOTIME | ATTR_KERNOVAL | ATTR_INCOMPLETE | ATTR_ALLOC)
 
 #define XFS_ATTR_FLAGS \
 	{ ATTR_DONTFOLLOW, 	"DONTFOLLOW" }, \
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -462,6 +462,8 @@ xfs_attrmulti_by_handle(
 
 	error = 0;
 	for (i = 0; i < am_hreq.opcount; i++) {
+		ops[i].am_flags &= ~ATTR_KERNEL_FLAGS;
+
 		ops[i].am_error = strncpy_from_user((char *)attr_name,
 				ops[i].am_attrname, MAXNAMELEN);
 		if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -450,6 +450,8 @@ xfs_compat_attrmulti_by_handle(
 
 	error = 0;
 	for (i = 0; i < am_hreq.opcount; i++) {
+		ops[i].am_flags &= ~ATTR_KERNEL_FLAGS;
+
 		ops[i].am_error = strncpy_from_user((char *)attr_name,
 				compat_ptr(ops[i].am_attrname),
 				MAXNAMELEN);


