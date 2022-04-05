Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 185DE4F3904
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377490AbiDEL31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351231AbiDEKBr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:01:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79156C955;
        Tue,  5 Apr 2022 02:51:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 626A2B81B14;
        Tue,  5 Apr 2022 09:51:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C20C385A1;
        Tue,  5 Apr 2022 09:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152290;
        bh=D7L0OFuGq8ZDjoEuhEiuaTbdXnNi98bio94Ocv4+WzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PbZEKi0mgr5KqKeybjCaRIjFeZb6dUDihhUaTVKaAlQBrwzQxOZI2+GccCQBT94yc
         xYXgYCaihph74zDldmFmuKZHZHpK2GRWYuxLw0DqZ2n8Qi53gUM7Z7ZoOIbAbgpkFe
         R6yNyLzsFR29DvhVg1ycAuLpUwA7+fAokLft3Uo4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rohith Surabattula <rohiths@microsoft.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 723/913] Adjust cifssb maximum read size
Date:   Tue,  5 Apr 2022 09:29:45 +0200
Message-Id: <20220405070401.504022314@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Rohith Surabattula <rohiths@microsoft.com>

[ Upstream commit 06a466565d54a1a42168f9033a062a3f5c40e73b ]

When session gets reconnected during mount then read size in super block fs context
gets set to zero and after negotiate, rsize is not modified which results in
incorrect read with requested bytes as zero. Fixes intermittent failure
of xfstest generic/240

Note that stable requires a different version of this patch which will be
sent to the stable mailing list.

Signed-off-by: Rohith Surabattula <rohiths@microsoft.com>
Acked-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsfs.c |  3 +++
 fs/cifs/file.c   | 10 ++++++++++
 2 files changed, 13 insertions(+)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 22a1d8156220..ed220daca3e1 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -210,6 +210,9 @@ cifs_read_super(struct super_block *sb)
 	if (rc)
 		goto out_no_root;
 	/* tune readahead according to rsize if readahead size not set on mount */
+	if (cifs_sb->ctx->rsize == 0)
+		cifs_sb->ctx->rsize =
+			tcon->ses->server->ops->negotiate_rsize(tcon, cifs_sb->ctx);
 	if (cifs_sb->ctx->rasize)
 		sb->s_bdi->ra_pages = cifs_sb->ctx->rasize / PAGE_SIZE;
 	else
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 82bbaf8e92b7..b23f6b489bb9 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3734,6 +3734,11 @@ cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
 				break;
 		}
 
+		if (cifs_sb->ctx->rsize == 0)
+			cifs_sb->ctx->rsize =
+				server->ops->negotiate_rsize(tlink_tcon(open_file->tlink),
+							     cifs_sb->ctx);
+
 		rc = server->ops->wait_mtu_credits(server, cifs_sb->ctx->rsize,
 						   &rsize, credits);
 		if (rc)
@@ -4512,6 +4517,11 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 				break;
 		}
 
+		if (cifs_sb->ctx->rsize == 0)
+			cifs_sb->ctx->rsize =
+				server->ops->negotiate_rsize(tlink_tcon(open_file->tlink),
+							     cifs_sb->ctx);
+
 		rc = server->ops->wait_mtu_credits(server, cifs_sb->ctx->rsize,
 						   &rsize, credits);
 		if (rc)
-- 
2.34.1



