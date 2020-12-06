Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A62742D0484
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729183AbgLFLqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:46:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:46658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728900AbgLFLqR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:46:17 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Ira Weiny <ira.weiny@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.9 45/46] uapi: fix statx attribute value overlap for DAX & MOUNT_ROOT
Date:   Sun,  6 Dec 2020 12:17:53 +0100
Message-Id: <20201206111558.632024362@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111556.455533723@linuxfoundation.org>
References: <20201206111556.455533723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

commit 72d1249e2ffdbc344e465031ec5335fa3489d62e upstream.

STATX_ATTR_MOUNT_ROOT and STATX_ATTR_DAX got merged with the same value,
so one of them needs fixing.  Move STATX_ATTR_DAX.

While we're in here, clarify the value-matching scheme for some of the
attributes, and explain why the value for DAX does not match.

Fixes: 80340fe3605c ("statx: add mount_root")
Fixes: 712b2698e4c0 ("fs/stat: Define DAX statx attribute")
Link: https://lore.kernel.org/linux-fsdevel/7027520f-7c79-087e-1d00-743bdefa1a1e@redhat.com/
Link: https://lore.kernel.org/lkml/20201202214629.1563760-1-ira.weiny@intel.com/
Reported-by: David Howells <dhowells@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Cc: <stable@vger.kernel.org> # 5.8
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/linux/stat.h |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/include/uapi/linux/stat.h
+++ b/include/uapi/linux/stat.h
@@ -171,9 +171,12 @@ struct statx {
  * be of use to ordinary userspace programs such as GUIs or ls rather than
  * specialised tools.
  *
- * Note that the flags marked [I] correspond to generic FS_IOC_FLAGS
+ * Note that the flags marked [I] correspond to the FS_IOC_SETFLAGS flags
  * semantically.  Where possible, the numerical value is picked to correspond
- * also.
+ * also.  Note that the DAX attribute indicates that the file is in the CPU
+ * direct access state.  It does not correspond to the per-inode flag that
+ * some filesystems support.
+ *
  */
 #define STATX_ATTR_COMPRESSED		0x00000004 /* [I] File is compressed by the fs */
 #define STATX_ATTR_IMMUTABLE		0x00000010 /* [I] File is marked immutable */
@@ -183,7 +186,7 @@ struct statx {
 #define STATX_ATTR_AUTOMOUNT		0x00001000 /* Dir: Automount trigger */
 #define STATX_ATTR_MOUNT_ROOT		0x00002000 /* Root of a mount */
 #define STATX_ATTR_VERITY		0x00100000 /* [I] Verity protected file */
-#define STATX_ATTR_DAX			0x00002000 /* [I] File is DAX */
+#define STATX_ATTR_DAX			0x00200000 /* File is currently in DAX state */
 
 
 #endif /* _UAPI_LINUX_STAT_H */


