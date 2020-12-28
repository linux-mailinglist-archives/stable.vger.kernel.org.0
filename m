Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80FD72E37A5
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 13:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbgL1M6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:58:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:55070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729244AbgL1M6s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:58:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F268B22AAD;
        Mon, 28 Dec 2020 12:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160287;
        bh=CEl+1ESaSoBIrIofVwhgvL92q+5GbtH7VRLy0yOgss0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KPAiUIO0mJq0QPDh3YfL1z8lGa3ZX/SQkklnv6qvitJj9HVg2y0QZH9L/DuNMEclF
         5SBBPkoznbufVQ1H1ca2VGVDbA4fDgad6xG2OOoB+IcUBn1POAQmRxAu8rC80yCtVX
         0j3t1IwgldMEiVwkVV/2zlzNmZcDN83QXNPt891M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhe Li <lizhe67@huawei.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 4.4 121/132] jffs2: Fix GC exit abnormally
Date:   Mon, 28 Dec 2020 13:50:05 +0100
Message-Id: <20201228124852.262096210@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
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
 
 	fd->nhash = full_name_hash(fd->name, rd->nsize);


