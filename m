Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1FA44EA07C
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 21:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343765AbiC1Tqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 15:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343779AbiC1Tq2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 15:46:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3376831E;
        Mon, 28 Mar 2022 12:43:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3A8BB81218;
        Mon, 28 Mar 2022 19:42:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B51EC36AE5;
        Mon, 28 Mar 2022 19:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648496577;
        bh=8jDtJcVMC/AdbhgKYyEFkAnFVPESQCIhjycJEyf6pFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m9ixiM8Cgpd6v6oV9vPqh9bS8GN3RioFRNMy+EV4+cT+oSh/i55mKU5lk6jSElGVi
         L2/1Ms+LEmLhbpSaAKispgVfRaUFH7gkZGo1U0h3crz6442uxl1VLbBIg/CZMrV45J
         l3UPv3zf11OTo7ALKPNnAZEFH6T7nYW6fcIOBJll4C0XwHd8ZA5dNQw6AR8B2zbnf+
         7InIE6bg6aoD+EbAHhq3TxyruvOkeyZEBlx82LV0S+9uLQg6zeLovl8MyMR0Gd03Hi
         CHKZldOJn7Na3gQBRIs+s6CfoVwZWVLfJ10Utnrssla1/GRuAqBjhz6Fty0KbANL+5
         jNJJ7NetrEm8w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rohith Surabattula <rohiths@microsoft.com>,
        Paulo Alcantara <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.16 19/20] Adjust cifssb maximum read size
Date:   Mon, 28 Mar 2022 15:42:25 -0400
Message-Id: <20220328194226.1585920-19-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328194226.1585920-1-sashal@kernel.org>
References: <20220328194226.1585920-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 99c51391a48d..d4fa4e3131b4 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -209,6 +209,9 @@ cifs_read_super(struct super_block *sb)
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
index 9fee3af83a73..abadc2f86dea 100644
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

