Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6845160AB9A
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbiJXNy4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233328AbiJXNxh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:53:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9DEBC478;
        Mon, 24 Oct 2022 05:43:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4CE0612DA;
        Mon, 24 Oct 2022 12:35:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D590FC433C1;
        Mon, 24 Oct 2022 12:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614936;
        bh=z1jpo4UkD4Ly2oimtwNpPZSx9SB4oraktF/ZPcHwwwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AlIofQbRWyVKb2nsVzW34iqKu+Y2p75YSMgZW8guoiPc3c52rmOpBRARKserydHRW
         quXoo0LKZ2vra3ZpxONOOoGmzYEgPmYJID5K6KfbXJY+nN2rX1nQ7eJHVcUwXT7SaQ
         +Oqm6mNpJ5VtWIPyz7qh1QSOiFNZehtyY3jP0USw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "M. Vefa Bicakci" <m.v.b@runbox.com>,
        Demi Marie Obenour <demi@invisiblethingslab.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.15 059/530] xen/gntdev: Prevent leaking grants
Date:   Mon, 24 Oct 2022 13:26:43 +0200
Message-Id: <20221024113047.713635097@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: M. Vefa Bicakci <m.v.b@runbox.com>

commit 0991028cd49567d7016d1b224fe0117c35059f86 upstream.

Prior to this commit, if a grant mapping operation failed partially,
some of the entries in the map_ops array would be invalid, whereas all
of the entries in the kmap_ops array would be valid. This in turn would
cause the following logic in gntdev_map_grant_pages to become invalid:

  for (i = 0; i < map->count; i++) {
    if (map->map_ops[i].status == GNTST_okay) {
      map->unmap_ops[i].handle = map->map_ops[i].handle;
      if (!use_ptemod)
        alloced++;
    }
    if (use_ptemod) {
      if (map->kmap_ops[i].status == GNTST_okay) {
        if (map->map_ops[i].status == GNTST_okay)
          alloced++;
        map->kunmap_ops[i].handle = map->kmap_ops[i].handle;
      }
    }
  }
  ...
  atomic_add(alloced, &map->live_grants);

Assume that use_ptemod is true (i.e., the domain mapping the granted
pages is a paravirtualized domain). In the code excerpt above, note that
the "alloced" variable is only incremented when both kmap_ops[i].status
and map_ops[i].status are set to GNTST_okay (i.e., both mapping
operations are successful).  However, as also noted above, there are
cases where a grant mapping operation fails partially, breaking the
assumption of the code excerpt above.

The aforementioned causes map->live_grants to be incorrectly set. In
some cases, all of the map_ops mappings fail, but all of the kmap_ops
mappings succeed, meaning that live_grants may remain zero. This in turn
makes it impossible to unmap the successfully grant-mapped pages pointed
to by kmap_ops, because unmap_grant_pages has the following snippet of
code at its beginning:

  if (atomic_read(&map->live_grants) == 0)
    return; /* Nothing to do */

In other cases where only some of the map_ops mappings fail but all
kmap_ops mappings succeed, live_grants is made positive, but when the
user requests unmapping the grant-mapped pages, __unmap_grant_pages_done
will then make map->live_grants negative, because the latter function
does not check if all of the pages that were requested to be unmapped
were actually unmapped, and the same function unconditionally subtracts
"data->count" (i.e., a value that can be greater than map->live_grants)
from map->live_grants. The side effects of a negative live_grants value
have not been studied.

The net effect of all of this is that grant references are leaked in one
of the above conditions. In Qubes OS v4.1 (which uses Xen's grant
mechanism extensively for X11 GUI isolation), this issue manifests
itself with warning messages like the following to be printed out by the
Linux kernel in the VM that had granted pages (that contain X11 GUI
window data) to dom0: "g.e. 0x1234 still pending", especially after the
user rapidly resizes GUI VM windows (causing some grant-mapping
operations to partially or completely fail, due to the fact that the VM
unshares some of the pages as part of the window resizing, making the
pages impossible to grant-map from dom0).

The fix for this issue involves counting all successful map_ops and
kmap_ops mappings separately, and then adding the sum to live_grants.
During unmapping, only the number of successfully unmapped grants is
subtracted from live_grants. The code is also modified to check for
negative live_grants values after the subtraction and warn the user.

Link: https://github.com/QubesOS/qubes-issues/issues/7631
Fixes: dbe97cff7dd9 ("xen/gntdev: Avoid blocking in unmap_grant_pages()")
Cc: stable@vger.kernel.org
Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
Acked-by: Demi Marie Obenour <demi@invisiblethingslab.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20221002222006.2077-2-m.v.b@runbox.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/gntdev.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -367,8 +367,7 @@ int gntdev_map_grant_pages(struct gntdev
 	for (i = 0; i < map->count; i++) {
 		if (map->map_ops[i].status == GNTST_okay) {
 			map->unmap_ops[i].handle = map->map_ops[i].handle;
-			if (!use_ptemod)
-				alloced++;
+			alloced++;
 		} else if (!err)
 			err = -EINVAL;
 
@@ -377,8 +376,7 @@ int gntdev_map_grant_pages(struct gntdev
 
 		if (use_ptemod) {
 			if (map->kmap_ops[i].status == GNTST_okay) {
-				if (map->map_ops[i].status == GNTST_okay)
-					alloced++;
+				alloced++;
 				map->kunmap_ops[i].handle = map->kmap_ops[i].handle;
 			} else if (!err)
 				err = -EINVAL;
@@ -394,8 +392,14 @@ static void __unmap_grant_pages_done(int
 	unsigned int i;
 	struct gntdev_grant_map *map = data->data;
 	unsigned int offset = data->unmap_ops - map->unmap_ops;
+	int successful_unmaps = 0;
+	int live_grants;
 
 	for (i = 0; i < data->count; i++) {
+		if (map->unmap_ops[offset + i].status == GNTST_okay &&
+		    map->unmap_ops[offset + i].handle != INVALID_GRANT_HANDLE)
+			successful_unmaps++;
+
 		WARN_ON(map->unmap_ops[offset + i].status != GNTST_okay &&
 			map->unmap_ops[offset + i].handle != INVALID_GRANT_HANDLE);
 		pr_debug("unmap handle=%d st=%d\n",
@@ -403,6 +407,10 @@ static void __unmap_grant_pages_done(int
 			map->unmap_ops[offset+i].status);
 		map->unmap_ops[offset+i].handle = INVALID_GRANT_HANDLE;
 		if (use_ptemod) {
+			if (map->kunmap_ops[offset + i].status == GNTST_okay &&
+			    map->kunmap_ops[offset + i].handle != INVALID_GRANT_HANDLE)
+				successful_unmaps++;
+
 			WARN_ON(map->kunmap_ops[offset + i].status != GNTST_okay &&
 				map->kunmap_ops[offset + i].handle != INVALID_GRANT_HANDLE);
 			pr_debug("kunmap handle=%u st=%d\n",
@@ -411,11 +419,15 @@ static void __unmap_grant_pages_done(int
 			map->kunmap_ops[offset+i].handle = INVALID_GRANT_HANDLE;
 		}
 	}
+
 	/*
 	 * Decrease the live-grant counter.  This must happen after the loop to
 	 * prevent premature reuse of the grants by gnttab_mmap().
 	 */
-	atomic_sub(data->count, &map->live_grants);
+	live_grants = atomic_sub_return(successful_unmaps, &map->live_grants);
+	if (WARN_ON(live_grants < 0))
+		pr_err("%s: live_grants became negative (%d) after unmapping %d pages!\n",
+		       __func__, live_grants, successful_unmaps);
 
 	/* Release reference taken by __unmap_grant_pages */
 	gntdev_put_map(NULL, map);


