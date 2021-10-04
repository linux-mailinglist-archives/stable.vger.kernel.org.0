Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B74CD420EFC
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234726AbhJDN34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:29:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237321AbhJDN2V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:28:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6721161CF3;
        Mon,  4 Oct 2021 13:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353156;
        bh=cdNiLtdRMDWRSvsDXWSNBqeLxgb0Io6im/yFMGrmzTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XyPPoHOAcgIZgM/JbiCv8RCqPqb9oDtsv+XQFmNeReg6cdpDnHrkOdTwUOlS/8gRM
         0lRgrghPGjUJ/tGZUrmQD4o5UtDdw/EMsjTA+Ldc4JpUCIa3VI8y9Y6R+y/sdji2Ya
         bDpj2eZWV3G3iixWM2ABJZKOK1oAw7JoAWazTDwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?minihanshen ?= <minihanshen@tencent.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 018/172] crypto: ccp - fix resource leaks in ccp_run_aes_gcm_cmd()
Date:   Mon,  4 Oct 2021 14:51:08 +0200
Message-Id: <20211004125045.553502993@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 505d9dcb0f7ddf9d075e729523a33d38642ae680 ]

There are three bugs in this code:

1) If we ccp_init_data() fails for &src then we need to free aad.
   Use goto e_aad instead of goto e_ctx.
2) The label to free the &final_wa was named incorrectly as "e_tag" but
   it should have been "e_final_wa".  One error path leaked &final_wa.
3) The &tag was leaked on one error path.  In that case, I added a free
   before the goto because the resource was local to that block.

Fixes: 36cf515b9bbe ("crypto: ccp - Enable support for AES GCM on v5 CCPs")
Reported-by: "minihanshen(沈明航)" <minihanshen@tencent.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: John Allen <john.allen@amd.com>
Tested-by: John Allen <john.allen@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/ccp-ops.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index bb88198c874e..aa4e1a500691 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -778,7 +778,7 @@ ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 				    in_place ? DMA_BIDIRECTIONAL
 					     : DMA_TO_DEVICE);
 		if (ret)
-			goto e_ctx;
+			goto e_aad;
 
 		if (in_place) {
 			dst = src;
@@ -863,7 +863,7 @@ ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	op.u.aes.size = 0;
 	ret = cmd_q->ccp->vdata->perform->aes(&op);
 	if (ret)
-		goto e_dst;
+		goto e_final_wa;
 
 	if (aes->action == CCP_AES_ACTION_ENCRYPT) {
 		/* Put the ciphered tag after the ciphertext. */
@@ -873,17 +873,19 @@ ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 		ret = ccp_init_dm_workarea(&tag, cmd_q, authsize,
 					   DMA_BIDIRECTIONAL);
 		if (ret)
-			goto e_tag;
+			goto e_final_wa;
 		ret = ccp_set_dm_area(&tag, 0, p_tag, 0, authsize);
-		if (ret)
-			goto e_tag;
+		if (ret) {
+			ccp_dm_free(&tag);
+			goto e_final_wa;
+		}
 
 		ret = crypto_memneq(tag.address, final_wa.address,
 				    authsize) ? -EBADMSG : 0;
 		ccp_dm_free(&tag);
 	}
 
-e_tag:
+e_final_wa:
 	ccp_dm_free(&final_wa);
 
 e_dst:
-- 
2.33.0



