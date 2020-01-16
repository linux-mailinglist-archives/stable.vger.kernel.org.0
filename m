Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7DC813F3F7
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389849AbgAPRKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:10:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:47568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389845AbgAPRKI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:10:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B92724689;
        Thu, 16 Jan 2020 17:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194607;
        bh=B2qxsZi5im0ROgTjukgilkJpFct4R/89pn0HPMplz3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HwkOcHM5HI/Bqoek7oJ4barDqOq1RtUNIRe0s1LAaJ+iUJvfObNpPr5J2apPARTJ6
         GIef1aU5NQ2fuyyCgcP7SemHEi0jC4aaM5A3LuNYedMGGY0cGo3V3QFp0nAfCWMd9h
         uv5wU+ApBhbAhSv7mKD4Re8oO/gqUd9Ob1HlH39M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.19 474/671] crypto: ccp - Reduce maximum stack usage
Date:   Thu, 16 Jan 2020 12:01:52 -0500
Message-Id: <20200116170509.12787-211-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 72c8117adfced37df101c8c0b3f363e0906f83f0 ]

Each of the operations in ccp_run_cmd() needs several hundred
bytes of kernel stack. Depending on the inlining, these may
need separate stack slots that add up to more than the warning
limit, as shown in this clang based build:

drivers/crypto/ccp/ccp-ops.c:871:12: error: stack frame size of 1164 bytes in function 'ccp_run_aes_cmd' [-Werror,-Wframe-larger-than=]
static int ccp_run_aes_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)

The problem may also happen when there is no warning, e.g. in the
ccp_run_cmd()->ccp_run_aes_cmd()->ccp_run_aes_gcm_cmd() call chain with
over 2000 bytes.

Mark each individual function as 'noinline_for_stack' to prevent
this from happening, and move the calls to the two special cases for aes
into the top-level function. This will keep the actual combined stack
usage to the mimimum: 828 bytes for ccp_run_aes_gcm_cmd() and
at most 524 bytes for each of the other cases.

Fixes: 63b945091a07 ("crypto: ccp - CCP device driver and interface support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/ccp-ops.c | 52 +++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 4b48b8523a40..330853a2702f 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -458,8 +458,8 @@ static int ccp_copy_from_sb(struct ccp_cmd_queue *cmd_q,
 	return ccp_copy_to_from_sb(cmd_q, wa, jobid, sb, byte_swap, true);
 }
 
-static int ccp_run_aes_cmac_cmd(struct ccp_cmd_queue *cmd_q,
-				struct ccp_cmd *cmd)
+static noinline_for_stack int
+ccp_run_aes_cmac_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 {
 	struct ccp_aes_engine *aes = &cmd->u.aes;
 	struct ccp_dm_workarea key, ctx;
@@ -614,8 +614,8 @@ static int ccp_run_aes_cmac_cmd(struct ccp_cmd_queue *cmd_q,
 	return ret;
 }
 
-static int ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q,
-			       struct ccp_cmd *cmd)
+static noinline_for_stack int
+ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 {
 	struct ccp_aes_engine *aes = &cmd->u.aes;
 	struct ccp_dm_workarea key, ctx, final_wa, tag;
@@ -897,7 +897,8 @@ static int ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q,
 	return ret;
 }
 
-static int ccp_run_aes_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
+static noinline_for_stack int
+ccp_run_aes_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 {
 	struct ccp_aes_engine *aes = &cmd->u.aes;
 	struct ccp_dm_workarea key, ctx;
@@ -907,12 +908,6 @@ static int ccp_run_aes_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	bool in_place = false;
 	int ret;
 
-	if (aes->mode == CCP_AES_MODE_CMAC)
-		return ccp_run_aes_cmac_cmd(cmd_q, cmd);
-
-	if (aes->mode == CCP_AES_MODE_GCM)
-		return ccp_run_aes_gcm_cmd(cmd_q, cmd);
-
 	if (!((aes->key_len == AES_KEYSIZE_128) ||
 	      (aes->key_len == AES_KEYSIZE_192) ||
 	      (aes->key_len == AES_KEYSIZE_256)))
@@ -1080,8 +1075,8 @@ static int ccp_run_aes_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	return ret;
 }
 
-static int ccp_run_xts_aes_cmd(struct ccp_cmd_queue *cmd_q,
-			       struct ccp_cmd *cmd)
+static noinline_for_stack int
+ccp_run_xts_aes_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 {
 	struct ccp_xts_aes_engine *xts = &cmd->u.xts;
 	struct ccp_dm_workarea key, ctx;
@@ -1280,7 +1275,8 @@ static int ccp_run_xts_aes_cmd(struct ccp_cmd_queue *cmd_q,
 	return ret;
 }
 
-static int ccp_run_des3_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
+static noinline_for_stack int
+ccp_run_des3_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 {
 	struct ccp_des3_engine *des3 = &cmd->u.des3;
 
@@ -1476,7 +1472,8 @@ static int ccp_run_des3_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	return ret;
 }
 
-static int ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
+static noinline_for_stack int
+ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 {
 	struct ccp_sha_engine *sha = &cmd->u.sha;
 	struct ccp_dm_workarea ctx;
@@ -1820,7 +1817,8 @@ static int ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	return ret;
 }
 
-static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
+static noinline_for_stack int
+ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 {
 	struct ccp_rsa_engine *rsa = &cmd->u.rsa;
 	struct ccp_dm_workarea exp, src, dst;
@@ -1951,8 +1949,8 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	return ret;
 }
 
-static int ccp_run_passthru_cmd(struct ccp_cmd_queue *cmd_q,
-				struct ccp_cmd *cmd)
+static noinline_for_stack int
+ccp_run_passthru_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 {
 	struct ccp_passthru_engine *pt = &cmd->u.passthru;
 	struct ccp_dm_workarea mask;
@@ -2083,7 +2081,8 @@ static int ccp_run_passthru_cmd(struct ccp_cmd_queue *cmd_q,
 	return ret;
 }
 
-static int ccp_run_passthru_nomap_cmd(struct ccp_cmd_queue *cmd_q,
+static noinline_for_stack int
+ccp_run_passthru_nomap_cmd(struct ccp_cmd_queue *cmd_q,
 				      struct ccp_cmd *cmd)
 {
 	struct ccp_passthru_nomap_engine *pt = &cmd->u.passthru_nomap;
@@ -2424,7 +2423,8 @@ static int ccp_run_ecc_pm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	return ret;
 }
 
-static int ccp_run_ecc_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
+static noinline_for_stack int
+ccp_run_ecc_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 {
 	struct ccp_ecc_engine *ecc = &cmd->u.ecc;
 
@@ -2461,7 +2461,17 @@ int ccp_run_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 
 	switch (cmd->engine) {
 	case CCP_ENGINE_AES:
-		ret = ccp_run_aes_cmd(cmd_q, cmd);
+		switch (cmd->u.aes.mode) {
+		case CCP_AES_MODE_CMAC:
+			ret = ccp_run_aes_cmac_cmd(cmd_q, cmd);
+			break;
+		case CCP_AES_MODE_GCM:
+			ret = ccp_run_aes_gcm_cmd(cmd_q, cmd);
+			break;
+		default:
+			ret = ccp_run_aes_cmd(cmd_q, cmd);
+			break;
+		}
 		break;
 	case CCP_ENGINE_XTS_AES_128:
 		ret = ccp_run_xts_aes_cmd(cmd_q, cmd);
-- 
2.20.1

