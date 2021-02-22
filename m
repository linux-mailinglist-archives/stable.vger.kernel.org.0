Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC58D3215EC
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhBVMOn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:14:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:44826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230135AbhBVMOe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:14:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D155064E4B;
        Mon, 22 Feb 2021 12:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996007;
        bh=P8dOsg/8lT9BVQdxiQW7fh17THd0WtL4GaIUw8wy3m8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t7svRfeFF6hrTnwvvplgmrXplhnry8hZqlJYVgLx269AKBfK3vDptfN4+mofcUEu5
         onAEkaYp8hPHpIFklbC3G5dtO0OqmM+fD/IO4a49aoKaqtx2A0kx6KZWiGLdV9TIMa
         21vQrsjhNZzk6bb5Jkr6aAzaoyieKW2xuPygEwWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.11 04/12] Xen/gntdev: correct error checking in gntdev_map_grant_pages()
Date:   Mon, 22 Feb 2021 13:12:56 +0100
Message-Id: <20210222121017.861311432@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121013.586597942@linuxfoundation.org>
References: <20210222121013.586597942@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

commit ebee0eab08594b2bd5db716288a4f1ae5936e9bc upstream.

Failure of the kernel part of the mapping operation should also be
indicated as an error to the caller, or else it may assume the
respective kernel VA is okay to access.

Furthermore gnttab_map_refs() failing still requires recording
successfully mapped handles, so they can be unmapped subsequently. This
in turn requires there to be a way to tell full hypercall failure from
partial success - preset map_op status fields such that they won't
"happen" to look as if the operation succeeded.

Also again use GNTST_okay instead of implying its value (zero).

This is part of XSA-361.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: stable@vger.kernel.org
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/gntdev.c      |   17 +++++++++--------
 include/xen/grant_table.h |    1 +
 2 files changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -334,21 +334,22 @@ int gntdev_map_grant_pages(struct gntdev
 	pr_debug("map %d+%d\n", map->index, map->count);
 	err = gnttab_map_refs(map->map_ops, use_ptemod ? map->kmap_ops : NULL,
 			map->pages, map->count);
-	if (err)
-		return err;
 
 	for (i = 0; i < map->count; i++) {
-		if (map->map_ops[i].status) {
+		if (map->map_ops[i].status == GNTST_okay)
+			map->unmap_ops[i].handle = map->map_ops[i].handle;
+		else if (!err)
 			err = -EINVAL;
-			continue;
-		}
 
 		if (map->flags & GNTMAP_device_map)
 			map->unmap_ops[i].dev_bus_addr = map->map_ops[i].dev_bus_addr;
 
-		map->unmap_ops[i].handle = map->map_ops[i].handle;
-		if (use_ptemod)
-			map->kunmap_ops[i].handle = map->kmap_ops[i].handle;
+		if (use_ptemod) {
+			if (map->kmap_ops[i].status == GNTST_okay)
+				map->kunmap_ops[i].handle = map->kmap_ops[i].handle;
+			else if (!err)
+				err = -EINVAL;
+		}
 	}
 	return err;
 }
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -157,6 +157,7 @@ gnttab_set_map_op(struct gnttab_map_gran
 	map->flags = flags;
 	map->ref = ref;
 	map->dom = domid;
+	map->status = 1; /* arbitrary positive value */
 }
 
 static inline void


