Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D1E632152
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 12:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiKULxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 06:53:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbiKULxE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 06:53:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2E4A45A
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 03:53:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89F8E60EC9
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 11:53:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBF0C433C1;
        Mon, 21 Nov 2022 11:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669031582;
        bh=HAI9VwJ7277n/Lr/3JJBOMHoWzin5iprY+e5QUQQRyw=;
        h=Subject:To:Cc:From:Date:From;
        b=nTiamw54X2QOI3CvZ4liRnc0yvbuhLSzOzKdNzeFlAYq6Rz59N856johVn3/X3h0I
         wnvXavYxN+7h2frJwiJEELFoCR3V2ypcqvnCJjkqtKXe65sWhA2BRL2N9A2g+SUAtt
         PZlb5joTIg3Bvs1ooXfSq+9f89sxhYwPkUZYLDic=
Subject: FAILED: patch "[PATCH] ceph: avoid putting the realm twice when decoding snaps fails" failed to apply to 5.10-stable tree
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Nov 2022 12:52:39 +0100
Message-ID: <16690315591462@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

51884d153f7e ("ceph: avoid putting the realm twice when decoding snaps fails")
2e586641c950 ("ceph: do not update snapshot context when there is no new snapshot")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 51884d153f7ec85e18d607b2467820a90e0f4359 Mon Sep 17 00:00:00 2001
From: Xiubo Li <xiubli@redhat.com>
Date: Wed, 9 Nov 2022 11:00:39 +0800
Subject: [PATCH] ceph: avoid putting the realm twice when decoding snaps fails

When decoding the snaps fails it maybe leaving the 'first_realm'
and 'realm' pointing to the same snaprealm memory. And then it'll
put it twice and could cause random use-after-free, BUG_ON, etc
issues.

Cc: stable@vger.kernel.org
Link: https://tracker.ceph.com/issues/57686
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 864cdaa0d2bd..e4151852184e 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -763,7 +763,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	struct ceph_mds_snap_realm *ri;    /* encoded */
 	__le64 *snaps;                     /* encoded */
 	__le64 *prior_parent_snaps;        /* encoded */
-	struct ceph_snap_realm *realm = NULL;
+	struct ceph_snap_realm *realm;
 	struct ceph_snap_realm *first_realm = NULL;
 	struct ceph_snap_realm *realm_to_rebuild = NULL;
 	int rebuild_snapcs;
@@ -774,6 +774,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 
 	dout("%s deletion=%d\n", __func__, deletion);
 more:
+	realm = NULL;
 	rebuild_snapcs = 0;
 	ceph_decode_need(&p, e, sizeof(*ri), bad);
 	ri = p;

