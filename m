Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72A764B4B4E
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347676AbiBNKbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:31:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348057AbiBNKap (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:30:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334C39BF51;
        Mon, 14 Feb 2022 01:59:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E122260A6B;
        Mon, 14 Feb 2022 09:59:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1183C340EF;
        Mon, 14 Feb 2022 09:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832741;
        bh=OEDJNIYHkJ6QNba+OjECjhNgSeZq5mr0y+XWi/DAICA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CdQO1uR8O2vYV9zRw5PrP59xIgrOHYS8V5zbSv7uBiXSzY5+PVhvmp9VAnSrtHofd
         BHT++CtC/Llydbm9vngq62QoRVo/QudTpbLJg2HNpvasbbsKcGHmBe5UgibMW4D2Bv
         Owfo3NAS0vavLiHL/bP7hRYtnggfOKlrPI9T+LzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.16 078/203] gfs2: Fix gfs2_release for non-writers regression
Date:   Mon, 14 Feb 2022 10:25:22 +0100
Message-Id: <20220214092512.927908552@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

commit d3add1a9519dcacd6e644ecac741c56cf18b67f5 upstream.

When a file is opened for writing, the vfs code (do_dentry_open)
calls get_write_access for the inode, thus incrementing the inode's write
count. That writer normally then creates a multi-block reservation for
the inode (i_res) that can be re-used by other writers, which speeds up
writes for applications that stupidly loop on open/write/close.
When the writes are all done, the multi-block reservation should be
deleted when the file is closed by the last "writer."

Commit 0ec9b9ea4f83 broke that concept when it moved the call to
gfs2_rs_delete before the check for FMODE_WRITE.  Non-writers have no
business removing the multi-block reservations of writers. In fact, if
someone opens and closes the file for RO while a writer has a
multi-block reservation, the RO closer will delete the reservation
midway through the write, and this results in:

kernel BUG at fs/gfs2/rgrp.c:677! (or thereabouts) which is:
BUG_ON(rs->rs_requested); from function gfs2_rs_deltree.

This patch moves the check back inside the check for FMODE_WRITE.

Fixes: 0ec9b9ea4f83 ("gfs2: Check for active reservation in gfs2_release")
Cc: stable@vger.kernel.org # v5.12+
Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/file.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -704,10 +704,11 @@ static int gfs2_release(struct inode *in
 	kfree(file->private_data);
 	file->private_data = NULL;
 
-	if (gfs2_rs_active(&ip->i_res))
-		gfs2_rs_delete(ip, &inode->i_writecount);
-	if (file->f_mode & FMODE_WRITE)
+	if (file->f_mode & FMODE_WRITE) {
+		if (gfs2_rs_active(&ip->i_res))
+			gfs2_rs_delete(ip, &inode->i_writecount);
 		gfs2_qa_put(ip);
+	}
 	return 0;
 }
 


