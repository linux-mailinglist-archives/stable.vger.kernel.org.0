Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0491481AF
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390522AbgAXLV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:21:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:60894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388317AbgAXLV5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:21:57 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 307DE20704;
        Fri, 24 Jan 2020 11:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864916;
        bh=BRYwBjzqPeNcYdjfaXF3xkVJMjvsS/my2E02IvspKh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tR6Wsv1zH8sOXe52WRU4YG9rwxvDWi5FiRPFfk1DNtO/TzhgR81HQP4fcnTDXO3s/
         6Ca4dLlxV9/vvg5GtBydMn3U2g25qwOe6WrJFZpmfwGSpE2N60/YXg6FiKqLjGvdJy
         vgv3FJzdiRCMGXa1xmFRqTqDyTRzsu7WrYhlHlWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gary R Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 387/639] crypto: ccp - Fix 3DES complaint from ccp-crypto module
Date:   Fri, 24 Jan 2020 10:29:17 +0100
Message-Id: <20200124093135.428027550@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hook, Gary <Gary.Hook@amd.com>

[ Upstream commit 89646fdda4cae203185444ac7988835f36a21ee1 ]

Crypto self-tests reveal an error:

alg: skcipher: cbc-des3-ccp encryption test failed (wrong output IV) on test vector 0, cfg="in-place"

The offset value should not be recomputed when retrieving the context.
Also, a code path exists which makes decisions based on older (version 3)
hardware; a v3 device deosn't support 3DES so remove this check.

Fixes: 990672d48515 ('crypto: ccp - Enable 3DES function on v5 CCPs')

Signed-off-by: Gary R Hook <gary.hook@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/ccp-ops.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 1e2e42106dee0..4b48b8523a40c 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -1293,6 +1293,9 @@ static int ccp_run_des3_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	int ret;
 
 	/* Error checks */
+	if (cmd_q->ccp->vdata->version < CCP_VERSION(5, 0))
+		return -EINVAL;
+
 	if (!cmd_q->ccp->vdata->perform->des3)
 		return -EINVAL;
 
@@ -1375,8 +1378,6 @@ static int ccp_run_des3_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	 * passthru option to convert from big endian to little endian.
 	 */
 	if (des3->mode != CCP_DES3_MODE_ECB) {
-		u32 load_mode;
-
 		op.sb_ctx = cmd_q->sb_ctx;
 
 		ret = ccp_init_dm_workarea(&ctx, cmd_q,
@@ -1392,12 +1393,8 @@ static int ccp_run_des3_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 		if (ret)
 			goto e_ctx;
 
-		if (cmd_q->ccp->vdata->version == CCP_VERSION(3, 0))
-			load_mode = CCP_PASSTHRU_BYTESWAP_NOOP;
-		else
-			load_mode = CCP_PASSTHRU_BYTESWAP_256BIT;
 		ret = ccp_copy_to_sb(cmd_q, &ctx, op.jobid, op.sb_ctx,
-				     load_mode);
+				     CCP_PASSTHRU_BYTESWAP_256BIT);
 		if (ret) {
 			cmd->engine_error = cmd_q->cmd_error;
 			goto e_ctx;
@@ -1459,10 +1456,6 @@ static int ccp_run_des3_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 		}
 
 		/* ...but we only need the last DES3_EDE_BLOCK_SIZE bytes */
-		if (cmd_q->ccp->vdata->version == CCP_VERSION(3, 0))
-			dm_offset = CCP_SB_BYTES - des3->iv_len;
-		else
-			dm_offset = 0;
 		ccp_get_dm_area(&ctx, dm_offset, des3->iv, 0,
 				DES3_EDE_BLOCK_SIZE);
 	}
-- 
2.20.1



