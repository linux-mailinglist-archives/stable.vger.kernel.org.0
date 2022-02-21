Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF664BE9CB
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347000AbiBUJED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:04:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347358AbiBUJBR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:01:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8A927FD4;
        Mon, 21 Feb 2022 00:56:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8095B80EAA;
        Mon, 21 Feb 2022 08:56:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAFB1C340E9;
        Mon, 21 Feb 2022 08:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433780;
        bh=6+DAcc/GTemVfT/BozWv5l4+CxuXuR9tBAK20Opgf1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NtqFK0quzjY7bRP0l21BzK2k/WK21gJxjHx7Xxk01zjnMmFDQT+eCh/1Yy3IGRWOc
         lkpfj9NVhOpwhh0XZF0/qkqsDWw31ifU8qXqYU0OY0wa4f/Kdkj4ntE8ugbIvH88Ey
         lxgYuH8hey2OOL0C2z56wYPUT0q2hKfRAh2hUNbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 4.19 39/58] NFS: Do not report writeback errors in nfs_getattr()
Date:   Mon, 21 Feb 2022 09:49:32 +0100
Message-Id: <20220221084913.137391366@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084911.895146879@linuxfoundation.org>
References: <20220221084911.895146879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit d19e0183a88306acda07f4a01fedeeffe2a2a06b upstream.

The result of the writeback, whether it is an ENOSPC or an EIO, or
anything else, does not inhibit the NFS client from reporting the
correct file timestamps.

Fixes: 79566ef018f5 ("NFS: Getattr doesn't require data sync semantics")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/inode.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -787,12 +787,9 @@ int nfs_getattr(const struct path *path,
 		goto out_no_update;
 
 	/* Flush out writes to the server in order to update c/mtime.  */
-	if ((request_mask & (STATX_CTIME|STATX_MTIME)) &&
-			S_ISREG(inode->i_mode)) {
-		err = filemap_write_and_wait(inode->i_mapping);
-		if (err)
-			goto out;
-	}
+	if ((request_mask & (STATX_CTIME | STATX_MTIME)) &&
+	    S_ISREG(inode->i_mode))
+		filemap_write_and_wait(inode->i_mapping);
 
 	/*
 	 * We may force a getattr if the user cares about atime.


