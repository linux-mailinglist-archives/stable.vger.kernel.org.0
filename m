Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A280233299
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 15:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbgG3NGe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 30 Jul 2020 09:06:34 -0400
Received: from mx1.emlix.com ([188.40.240.192]:55960 "EHLO mx1.emlix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726535AbgG3NGe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 09:06:34 -0400
X-Greylist: delayed 431 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Jul 2020 09:06:33 EDT
Received: from mailer.emlix.com (p5098be52.dip0.t-ipconnect.de [80.152.190.82])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.emlix.com (Postfix) with ESMTPS id A6DCC5FF99
        for <stable@vger.kernel.org>; Thu, 30 Jul 2020 14:59:20 +0200 (CEST)
From:   Rolf Eike Beer <eb@emlix.com>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9.y 1/2] uapi: includes linux/types.h before exporting files
Date:   Thu, 30 Jul 2020 14:59:20 +0200
Message-ID: <2225723.ZPmVZEtQ53@devpool35>
Organization: emlix GmbH
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Mon, 27 Mar 2017 14:20:11 +0200

commit 9078b4eea119c13d633d45af0397c821a517b522 upstream

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
---
 include/uapi/linux/bcache.h     | 2 +-
 include/uapi/linux/btrfs_tree.h | 2 ++
 include/uapi/linux/cryptouser.h | 2 ++
 include/uapi/linux/pr.h         | 2 ++
 include/uapi/linux/qrtr.h       | 1 +
 5 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bcache.h b/include/uapi/linux/bcache.h
index 8562b1cb776b..3b92610502ca 100644
--- a/include/uapi/linux/bcache.h
+++ b/include/uapi/linux/bcache.h
@@ -5,7 +5,7 @@
  * Bcache on disk data structures
  */
 
-#include <asm/types.h>
+#include <linux/types.h>
 
 #define BITMASK(name, type, field, offset, size)		\
 static inline __u64 name(const type *k)				\
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index a1ded2a1bf1d..2abf660e9f65 100644
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
diff --git a/include/uapi/linux/cryptouser.h b/include/uapi/linux/cryptouser.h
index 79b5ded2001a..3d0aa2bc69f3 100644
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
diff --git a/include/uapi/linux/pr.h b/include/uapi/linux/pr.h
index 57d7c0f916b6..645ef3cf3dd0 100644
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
diff --git a/include/uapi/linux/qrtr.h b/include/uapi/linux/qrtr.h
index 66c0748d26e2..9d76c566f66e 100644
--- a/include/uapi/linux/qrtr.h
+++ b/include/uapi/linux/qrtr.h
@@ -2,6 +2,7 @@
 #define _LINUX_QRTR_H
 
 #include <linux/socket.h>
+#include <linux/types.h>
 
 struct sockaddr_qrtr {
 	__kernel_sa_family_t sq_family;
-- 
2.27.0


-- 
Rolf Eike Beer, emlix GmbH, http://www.emlix.com
Fon +49 551 30664-0, Fax +49 551 30664-11
Gothaer Platz 3, 37083 Göttingen, Germany
Sitz der Gesellschaft: Göttingen, Amtsgericht Göttingen HR B 3160
Geschäftsführung: Heike Jordan, Dr. Uwe Kracke – Ust-IdNr.: DE 205 198 055

emlix - smart embedded open source



