Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB87824BAB7
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730271AbgHTJ5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:57:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730267AbgHTJ45 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:56:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 515B92067C;
        Thu, 20 Aug 2020 09:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917413;
        bh=OaT3fz4TOia5W0ucvvmAPTLlSe+2mKY5qoePCnvDDcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=op0nDSqYVGd+JjjGheO1clVPsDEbzH0SnPjfrztuvWol51GveSa4q5GMfA4Wlz8xH
         uHzfR9HGmfmSOWGXvaISbXfESgspJ01GW88qSnrX4iWJKaqukuPTX0BuaEjLJ/K5Xr
         xgBIL64grWS2unw6b6sDrvxWP9BfKR8+7m8SaU3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Rolf Eike Beer <eb@emlix.com>
Subject: [PATCH 4.9 022/212] uapi: includes linux/types.h before exporting files
Date:   Thu, 20 Aug 2020 11:19:55 +0200
Message-Id: <20200820091603.459161619@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit 9078b4eea119c13d633d45af0397c821a517b522 upstream.

Some files will be exported after a following patch. 0-day tests report the
following warning/error:
./usr/include/linux/bcache.h:8: include of <linux/types.h> is preferred over <asm/types.h>
./usr/include/linux/bcache.h:11: found __[us]{8,16,32,64} type without #include <linux/types.h>
./usr/include/linux/qrtr.h:8: found __[us]{8,16,32,64} type without #include <linux/types.h>
./usr/include/linux/cryptouser.h:39: found __[us]{8,16,32,64} type without #include <linux/types.h>
./usr/include/linux/pr.h:14: found __[us]{8,16,32,64} type without #include <linux/types.h>
./usr/include/linux/btrfs_tree.h:337: found __[us]{8,16,32,64} type without #include <linux/types.h>
./usr/include/rdma/bnxt_re-abi.h:45: found __[us]{8,16,32,64} type without #include <linux/types.h>

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
reb: left out include/uapi/rdma/bnxt_re-abi.h as it's not in this kernel version
Signed-off-by: Rolf Eike Beer <eb@emlix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/linux/bcache.h     |    2 +-
 include/uapi/linux/btrfs_tree.h |    2 ++
 include/uapi/linux/cryptouser.h |    2 ++
 include/uapi/linux/pr.h         |    2 ++
 include/uapi/linux/qrtr.h       |    1 +
 5 files changed, 8 insertions(+), 1 deletion(-)

--- a/include/uapi/linux/bcache.h
+++ b/include/uapi/linux/bcache.h
@@ -5,7 +5,7 @@
  * Bcache on disk data structures
  */
 
-#include <asm/types.h>
+#include <linux/types.h>
 
 #define BITMASK(name, type, field, offset, size)		\
 static inline __u64 name(const type *k)				\
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -1,6 +1,8 @@
 #ifndef _BTRFS_CTREE_H_
 #define _BTRFS_CTREE_H_
 
+#include <linux/types.h>
+
 /*
  * This header contains the structure definitions and constants used
  * by file system objects that can be retrieved using
--- a/include/uapi/linux/cryptouser.h
+++ b/include/uapi/linux/cryptouser.h
@@ -18,6 +18,8 @@
  * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
  */
 
+#include <linux/types.h>
+
 /* Netlink configuration messages.  */
 enum {
 	CRYPTO_MSG_BASE = 0x10,
--- a/include/uapi/linux/pr.h
+++ b/include/uapi/linux/pr.h
@@ -1,6 +1,8 @@
 #ifndef _UAPI_PR_H
 #define _UAPI_PR_H
 
+#include <linux/types.h>
+
 enum pr_type {
 	PR_WRITE_EXCLUSIVE		= 1,
 	PR_EXCLUSIVE_ACCESS		= 2,
--- a/include/uapi/linux/qrtr.h
+++ b/include/uapi/linux/qrtr.h
@@ -2,6 +2,7 @@
 #define _LINUX_QRTR_H
 
 #include <linux/socket.h>
+#include <linux/types.h>
 
 struct sockaddr_qrtr {
 	__kernel_sa_family_t sq_family;


