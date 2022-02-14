Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46BDC4B4979
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345049AbiBNKID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:08:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345594AbiBNKGa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:06:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2296474DCA;
        Mon, 14 Feb 2022 01:49:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B42F661238;
        Mon, 14 Feb 2022 09:49:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A09D5C340EF;
        Mon, 14 Feb 2022 09:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832171;
        bh=A4SdmNYLAnveL9cm0e3pqcw/lppUkfyaqYDwasfTHx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X5nmCx4pIw69sw+P918zfDv8N1xUweMmkYOJP7AoEHNFNumTAZHEMbfVAg/FtPSOa
         abbWvCXOaJXgWSp+kygb73l+r2ZOv0WMcom1Mz6/AOrWP6JX8m/9FY/L4AWYXUaVa7
         hPPpnhD9x0dque9UqpHgHjOv4yKMg+8Wv/ExrEP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.15 069/172] gfs2: Fix gfs2_release for non-writers regression
Date:   Mon, 14 Feb 2022 10:25:27 +0100
Message-Id: <20220214092508.782354238@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
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
@@ -711,10 +711,11 @@ static int gfs2_release(struct inode *in
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
 


