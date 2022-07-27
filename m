Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBB75830FC
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242961AbiG0RpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243130AbiG0RoT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:44:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746378AEC5;
        Wed, 27 Jul 2022 09:53:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DE06B821C5;
        Wed, 27 Jul 2022 16:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8335FC433D6;
        Wed, 27 Jul 2022 16:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940781;
        bh=/0a/0Z9dUlo8grhA3fXLHeVFNp9BdkiWV92ue3bNBfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OmnNLWBC80H+L9HOSXmvjuHuOdjTp5a/vwb7lIc50XxFGGDxou6uX4NF+WazLY3fq
         +ccWtRhMhPs9jlQAaS+RUxC4CIk6soeG+WeqCp9y9zLVl+48QzOXKfJrHSFMGiym7W
         +MKB6Bsi6Kbxv7+k42MefpZ5WgbXgw/qkzwQrTA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 147/158] crypto: qat - add param check for RSA
Date:   Wed, 27 Jul 2022 18:13:31 +0200
Message-Id: <20220727161027.247180664@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 9714061423b8b24b8afb31b8eb4df977c63f19c4 ]

Reject requests with a source buffer that is bigger than the size of the
key. This is to prevent a possible integer underflow that might happen
when copying the source scatterlist into a linear buffer.

Cc: stable@vger.kernel.org
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 25bbd22085c3..947eeff181b4 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -656,6 +656,10 @@ static int qat_rsa_enc(struct akcipher_request *req)
 		req->dst_len = ctx->key_sz;
 		return -EOVERFLOW;
 	}
+
+	if (req->src_len > ctx->key_sz)
+		return -EINVAL;
+
 	memset(msg, '\0', sizeof(*msg));
 	ICP_QAT_FW_PKE_HDR_VALID_FLAG_SET(msg->pke_hdr,
 					  ICP_QAT_FW_COMN_REQ_FLAG_SET);
@@ -785,6 +789,10 @@ static int qat_rsa_dec(struct akcipher_request *req)
 		req->dst_len = ctx->key_sz;
 		return -EOVERFLOW;
 	}
+
+	if (req->src_len > ctx->key_sz)
+		return -EINVAL;
+
 	memset(msg, '\0', sizeof(*msg));
 	ICP_QAT_FW_PKE_HDR_VALID_FLAG_SET(msg->pke_hdr,
 					  ICP_QAT_FW_COMN_REQ_FLAG_SET);
-- 
2.35.1



