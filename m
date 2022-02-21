Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3905A4BDBFC
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347888AbiBUJNe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:13:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349320AbiBUJMU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:12:20 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649EE2B24F;
        Mon, 21 Feb 2022 01:05:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BA33FCE0E96;
        Mon, 21 Feb 2022 09:05:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAFEDC36AF4;
        Mon, 21 Feb 2022 09:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434306;
        bh=Uo+ubOqA+ITSRbDif9O/tdwRuedNsxQhWzP0LFzYGbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=loa7eWjruFLRH5o+cub8N9U0EXBToFfQ0yiIk0S84Irg4w07FsXq5pr7bftuposLg
         1KA1adpABR/YlrO2ssrjbS10j9v5+SZDmQ7e51a9xihlkDS1zTl7hWICgKiePgcDfw
         cwu0INRuozZRUwWX8QtQlgkj5aRcLEhK4/ldSS8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.10 083/121] NFS: Do not report writeback errors in nfs_getattr()
Date:   Mon, 21 Feb 2022 09:49:35 +0100
Message-Id: <20220221084924.022454619@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
References: <20220221084921.147454846@linuxfoundation.org>
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
@@ -807,12 +807,9 @@ int nfs_getattr(const struct path *path,
 	}
 
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


