Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C984615AF9
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiKBDpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbiKBDpO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:45:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD29D2736
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:45:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EEEDB81AF4
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:45:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55326C433C1;
        Wed,  2 Nov 2022 03:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667360710;
        bh=/P1EJTdP+mnp2v3ugrHFRcEgn0TLsCsK3UxQQNg1S+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AbSRoaSbUHiJGwEw785KRYu1qPDPIm5IWoAqxxYK7z14SYDaBRn1d1M2IWOmLXaU6
         FQOWLrslFPHlK0jTEuv1LbntcftgxeFP6XrkiFI900XlNW7LCBRf/unE5Uft5qcBO1
         ZjE9Mcj78a2XB1ZN+9FINrxG2NybShnqx+jYi6XM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "M. Vefa Bicakci" <m.v.b@runbox.com>,
        Demi Marie Obenour <demi@invisiblethingslab.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 4.9 23/44] xen/gntdev: Prevent leaking grants
Date:   Wed,  2 Nov 2022 03:35:09 +0100
Message-Id: <20221102022049.873076820@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022049.017479464@linuxfoundation.org>
References: <20221102022049.017479464@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/gntdev.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -361,8 +361,7 @@ static int map_grant_pages(struct grant_
 	for (i = 0; i < map->count; i++) {
 		if (map->map_ops[i].status == GNTST_okay) {
 			map->unmap_ops[i].handle = map->map_ops[i].handle;
-			if (!use_ptemod)
-				alloced++;
+			alloced++;
 		} else if (!err)
 			err = -EINVAL;
 
@@ -371,8 +370,7 @@ static int map_grant_pages(struct grant_
 
 		if (use_ptemod) {
 			if (map->kmap_ops[i].status == GNTST_okay) {
-				if (map->map_ops[i].status == GNTST_okay)
-					alloced++;
+				alloced++;
 				map->kunmap_ops[i].handle = map->kmap_ops[i].handle;
 			} else if (!err)
 				err = -EINVAL;
@@ -388,8 +386,14 @@ static void __unmap_grant_pages_done(int
 	unsigned int i;
 	struct grant_map *map = data->data;
 	unsigned int offset = data->unmap_ops - map->unmap_ops;
+	int successful_unmaps = 0;
+	int live_grants;
 
 	for (i = 0; i < data->count; i++) {
+		if (map->unmap_ops[offset + i].status == GNTST_okay &&
+		    map->unmap_ops[offset + i].handle != -1)
+			successful_unmaps++;
+
 		WARN_ON(map->unmap_ops[offset+i].status &&
 			map->unmap_ops[offset+i].handle != -1);
 		pr_debug("unmap handle=%d st=%d\n",
@@ -397,6 +401,10 @@ static void __unmap_grant_pages_done(int
 			map->unmap_ops[offset+i].status);
 		map->unmap_ops[offset+i].handle = -1;
 		if (use_ptemod) {
+			if (map->kunmap_ops[offset + i].status == GNTST_okay &&
+			    map->kunmap_ops[offset + i].handle != -1)
+				successful_unmaps++;
+
 			WARN_ON(map->kunmap_ops[offset+i].status &&
 				map->kunmap_ops[offset+i].handle != -1);
 			pr_debug("kunmap handle=%u st=%d\n",
@@ -405,11 +413,15 @@ static void __unmap_grant_pages_done(int
 			map->kunmap_ops[offset+i].handle = -1;
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
 
 	/* Release reference taken by unmap_grant_pages */
 	gntdev_put_map(NULL, map);


