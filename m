Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF2B541CAE
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356484AbiFGWDb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382567AbiFGWCm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:02:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A04C24F952;
        Tue,  7 Jun 2022 12:14:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8902F6192A;
        Tue,  7 Jun 2022 19:14:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94DB7C385A5;
        Tue,  7 Jun 2022 19:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629283;
        bh=Pm1sdPAeGW7S0pQyTrq8Rdh0/AYBc4BFWlu2G/4YV0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=is3+rOrgR588nGUdgXX1fPSRLixvc9BCELoafz9XQMIJi79UvvifGiZC4Nb8BBtBt
         2xa/avQmF42blcCOyVpi94Mq2Rbp/aq4YsABqxqmKxLCqGNAUijodLzkDMZex7Zcrd
         nkJTb+GVtZF9Hg6yCQMsfSZ3PaztRfnT6+3+NIzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacky Li <jackyli@google.com>,
        Peter Gonda <pgonda@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 594/879] crypto: ccp - Fix the INIT_EX data file open failure
Date:   Tue,  7 Jun 2022 19:01:52 +0200
Message-Id: <20220607165020.094510951@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacky Li <jackyli@google.com>

[ Upstream commit 05def5cacfa0bd5ba380116046747da07ff5bd78 ]

There are 2 common cases when INIT_EX data file might not be
opened successfully and fail the sev initialization:

1. In user namespaces, normal user tasks (e.g. VMM) can change their
   current->fs->root to point to arbitrary directories. While
   init_ex_path is provided as a module param related to root file
   system. Solution: use the root directory of init_task to avoid
   accessing the wrong file.

2. Normal user tasks (e.g. VMM) don't have the privilege to access
   the INIT_EX data file. Solution: open the file as root and
   restore permissions immediately.

Fixes: 3d725965f836 ("crypto: ccp - Add SEV_INIT_EX support")
Signed-off-by: Jacky Li <jackyli@google.com>
Reviewed-by: Peter Gonda <pgonda@google.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 6ab93dfd478a..3aefb177715e 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -23,6 +23,7 @@
 #include <linux/gfp.h>
 #include <linux/cpufeature.h>
 #include <linux/fs.h>
+#include <linux/fs_struct.h>
 
 #include <asm/smp.h>
 
@@ -170,6 +171,31 @@ static void *sev_fw_alloc(unsigned long len)
 	return page_address(page);
 }
 
+static struct file *open_file_as_root(const char *filename, int flags, umode_t mode)
+{
+	struct file *fp;
+	struct path root;
+	struct cred *cred;
+	const struct cred *old_cred;
+
+	task_lock(&init_task);
+	get_fs_root(init_task.fs, &root);
+	task_unlock(&init_task);
+
+	cred = prepare_creds();
+	if (!cred)
+		return ERR_PTR(-ENOMEM);
+	cred->fsuid = GLOBAL_ROOT_UID;
+	old_cred = override_creds(cred);
+
+	fp = file_open_root(&root, filename, flags, mode);
+	path_put(&root);
+
+	revert_creds(old_cred);
+
+	return fp;
+}
+
 static int sev_read_init_ex_file(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
@@ -181,7 +207,7 @@ static int sev_read_init_ex_file(void)
 	if (!sev_init_ex_buffer)
 		return -EOPNOTSUPP;
 
-	fp = filp_open(init_ex_path, O_RDONLY, 0);
+	fp = open_file_as_root(init_ex_path, O_RDONLY, 0);
 	if (IS_ERR(fp)) {
 		int ret = PTR_ERR(fp);
 
@@ -217,7 +243,7 @@ static void sev_write_init_ex_file(void)
 	if (!sev_init_ex_buffer)
 		return;
 
-	fp = filp_open(init_ex_path, O_CREAT | O_WRONLY, 0600);
+	fp = open_file_as_root(init_ex_path, O_CREAT | O_WRONLY, 0600);
 	if (IS_ERR(fp)) {
 		dev_err(sev->dev,
 			"SEV: could not open file for write, error %ld\n",
-- 
2.35.1



