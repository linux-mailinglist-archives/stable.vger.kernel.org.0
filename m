Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844784F2E9B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbiDEIjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240070AbiDEIWf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:22:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFBD5DEC2;
        Tue,  5 Apr 2022 01:19:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFB7EB81B92;
        Tue,  5 Apr 2022 08:19:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17FC2C385A1;
        Tue,  5 Apr 2022 08:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146781;
        bh=YtG+6EI3+FgkaM6u4nXFTkoCNBD5iXHVpVD+KDag51A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zP91NtjvYnsyZjgOjno+6xe0nAT/S3kJqAS4m+GWoyFbeXq/9jTqBf3vcoQ4RgfHf
         +EBlOkLvxV+3cgFVHwCVSlIBM7Lhz17F0OA6Qf+xsOCz/eUhr6KbTq/xKuff/0m/H0
         qGeNssODTuaet0Mv3+i1a7Tazvni0YoyJYKRjZ/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rohith Surabattula <rohiths@microsoft.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0887/1126] Adjust cifssb maximum read size
Date:   Tue,  5 Apr 2022 09:27:14 +0200
Message-Id: <20220405070433.564945778@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
index 4691b2706ddf..6e5246122ee2 100644
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
index e7af802dcfa6..a2723f7cb5e9 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3740,6 +3740,11 @@ cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
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
@@ -4474,6 +4479,11 @@ static void cifs_readahead(struct readahead_control *ractl)
 			}
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



