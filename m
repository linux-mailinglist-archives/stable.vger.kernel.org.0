Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69181420D80
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236124AbhJDNPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:15:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236338AbhJDNNv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:13:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8700961B95;
        Mon,  4 Oct 2021 13:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352729;
        bh=WzMOgXrvb4YTkBj40OMzlVskVhLCOeCwBl4ym3E/mt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ANLLtOUiXwx1Qtnodf3rpE/KOwAk3VL+3927DdZhAlb1Ms09Pw5fLlcnEm31oykI4
         3c7k+Yj8D7Zt6XnFzYlUQ5Q/QkA7zIIYEk7gPqx+ompwyFp1qZwnYWsg3E8+JjFK0D
         9DI0cV3u5auv9UtmJK2ZxPDz0b8zq0CrkyLbLghk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?minihanshen ?= <minihanshen@tencent.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19 91/95] crypto: ccp - fix resource leaks in ccp_run_aes_gcm_cmd()
Date:   Mon,  4 Oct 2021 14:53:01 +0200
Message-Id: <20211004125036.548491377@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125033.572932188@linuxfoundation.org>
References: <20211004125033.572932188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 505d9dcb0f7ddf9d075e729523a33d38642ae680 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/ccp/ccp-ops.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -783,7 +783,7 @@ ccp_run_aes_gcm_cmd(struct ccp_cmd_queue
 				    in_place ? DMA_BIDIRECTIONAL
 					     : DMA_TO_DEVICE);
 		if (ret)
-			goto e_ctx;
+			goto e_aad;
 
 		if (in_place) {
 			dst = src;
@@ -868,7 +868,7 @@ ccp_run_aes_gcm_cmd(struct ccp_cmd_queue
 	op.u.aes.size = 0;
 	ret = cmd_q->ccp->vdata->perform->aes(&op);
 	if (ret)
-		goto e_dst;
+		goto e_final_wa;
 
 	if (aes->action == CCP_AES_ACTION_ENCRYPT) {
 		/* Put the ciphered tag after the ciphertext. */
@@ -878,17 +878,19 @@ ccp_run_aes_gcm_cmd(struct ccp_cmd_queue
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


