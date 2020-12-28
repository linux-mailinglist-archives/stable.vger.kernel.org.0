Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B66342E383D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730811AbgL1NHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:07:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:35342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730805AbgL1NHk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:07:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBEE022AAA;
        Mon, 28 Dec 2020 13:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160819;
        bh=i7OZ7g5EYwwab0/iT21/W9zFYz9gbkRlmjrjXA+IToU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aR1AhipCDObhlfOnGu0ClVdtgrT7cPn1s3tIA3vH+MGuAzgGiCKn8Z65OiqhSIzc+
         1+qDJLJTYr37BzSGM86doW36GicIX+YNzbzjF+LxrYLWN4S48T2429z7Ky0sCsMUGy
         6jbJ++bByC7+p7qlvkHVth5e8t6F1uhyaptkGe9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhe Li <lizhe67@huawei.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 4.9 159/175] jffs2: Fix GC exit abnormally
Date:   Mon, 28 Dec 2020 13:50:12 +0100
Message-Id: <20201228124900.943466481@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhe Li <lizhe67@huawei.com>

commit 9afc9a8a4909fece0e911e72b1060614ba2f7969 upstream.

The log of this problem is:
jffs2: Error garbage collecting node at 0x***!
jffs2: No space for garbage collection. Aborting GC thread

This is because GC believe that it do nothing, so it abort.

After going over the image of jffs2, I find a scene that
can trigger this problem stably.
The scene is: there is a normal dirent node at summary-area,
but abnormal at corresponding not-summary-area with error
name_crc.

The reason that GC exit abnormally is because it find that
abnormal dirent node to GC, but when it goes to function
jffs2_add_fd_to_list, it cannot meet the condition listed
below:

if ((*prev)->nhash == new->nhash && !strcmp((*prev)->name, new->name))

So no node is marked obsolete, statistical information of
erase_block do not change, which cause GC exit abnormally.

The root cause of this problem is: we do not check the
name_crc of the abnormal dirent node with summary is enabled.

Noticed that in function jffs2_scan_dirent_node, we use
function jffs2_scan_dirty_space to deal with the dirent
node with error name_crc. So this patch add a checking
code in function read_direntry to ensure the correctness
of dirent node. If checked failed, the dirent node will
be marked obsolete so GC will pass this node and this
problem will be fixed.

Cc: <stable@vger.kernel.org>
Signed-off-by: Zhe Li <lizhe67@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/jffs2/readinode.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/fs/jffs2/readinode.c
+++ b/fs/jffs2/readinode.c
@@ -672,6 +672,22 @@ static inline int read_direntry(struct j
 			jffs2_free_full_dirent(fd);
 			return -EIO;
 		}
+
+#ifdef CONFIG_JFFS2_SUMMARY
+		/*
+		 * we use CONFIG_JFFS2_SUMMARY because without it, we
+		 * have checked it while mounting
+		 */
+		crc = crc32(0, fd->name, rd->nsize);
+		if (unlikely(crc != je32_to_cpu(rd->name_crc))) {
+			JFFS2_NOTICE("name CRC failed on dirent node at"
+			   "%#08x: read %#08x,calculated %#08x\n",
+			   ref_offset(ref), je32_to_cpu(rd->node_crc), crc);
+			jffs2_mark_node_obsolete(c, ref);
+			jffs2_free_full_dirent(fd);
+			return 0;
+		}
+#endif
 	}
 
 	fd->nhash = full_name_hash(NULL, fd->name, rd->nsize);


