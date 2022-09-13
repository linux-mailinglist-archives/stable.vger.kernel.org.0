Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3DD65B718B
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbiIMOoe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbiIMOnY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:43:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69986E8A8;
        Tue, 13 Sep 2022 07:23:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 527D1B80F97;
        Tue, 13 Sep 2022 14:23:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA12C433B5;
        Tue, 13 Sep 2022 14:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078980;
        bh=DvXpHCfXbZfjG69P89g89P4VBGClGkIQAJFoRQUxUT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pQNBEuCfanIQ3Z7mKsoLEMGOPikXt0O+3Mi54TpCxr0MTI0XYdQUt4xTXne6UDhlm
         fGfa0dbfdsQx+BAi+qsmmA/efoOvlo7NZimblBWVhbtpkrcLF298r3B2bo4sNlVRjP
         v8pZO09LoQXv2hrPgNrCuN8hJnvx86SlWmkZ6tSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 36/79] smb3: missing inode locks in punch hole
Date:   Tue, 13 Sep 2022 16:04:41 +0200
Message-Id: <20220913140352.035475762@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140350.291927556@linuxfoundation.org>
References: <20220913140350.291927556@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit ba0803050d610d5072666be727bca5e03e55b242 ]

smb3 fallocate punch hole was not grabbing the inode or filemap_invalidate
locks so could have race with pagemap reinstantiating the page.

Cc: stable@vger.kernel.org
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 0a20ae96fe243..11efd5289ec43 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3430,7 +3430,7 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 			    loff_t offset, loff_t len)
 {
-	struct inode *inode;
+	struct inode *inode = file_inode(file);
 	struct cifsFileInfo *cfile = file->private_data;
 	struct file_zero_data_information fsctl_buf;
 	long rc;
@@ -3439,14 +3439,12 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 
 	xid = get_xid();
 
-	inode = d_inode(cfile->dentry);
-
+	inode_lock(inode);
 	/* Need to make file sparse, if not already, before freeing range. */
 	/* Consider adding equivalent for compressed since it could also work */
 	if (!smb2_set_sparse(xid, tcon, cfile, inode, set_sparse)) {
 		rc = -EOPNOTSUPP;
-		free_xid(xid);
-		return rc;
+		goto out;
 	}
 
 	/*
@@ -3465,6 +3463,8 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 			(char *)&fsctl_buf,
 			sizeof(struct file_zero_data_information),
 			CIFSMaxBufSize, NULL, NULL);
+out:
+	inode_unlock(inode);
 	free_xid(xid);
 	return rc;
 }
-- 
2.35.1



