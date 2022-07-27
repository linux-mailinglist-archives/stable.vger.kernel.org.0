Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0365582EF0
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbiG0RTx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241969AbiG0RTZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:19:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBAEE17E13;
        Wed, 27 Jul 2022 09:44:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 988B9B821A6;
        Wed, 27 Jul 2022 16:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11D3C433C1;
        Wed, 27 Jul 2022 16:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940274;
        bh=OGCj6S1xjd9XwIbJO81L93cBRcKmCDMbwE+p77sNUko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bsZeo27anj1n1HkU1kXIcD7cGAfzERxiglpGvldORqTskkcl9BLgHQc7fMs7e77qp
         3OKu6A3CrOi5UXIfKp7H9/iLkIknJJpOqD7wkycTueB8Uf00/5uqGGw2L4Xg9ed7kN
         ojJdtktSw68f8EY0idPynv03MX/vyrZ7Qa2IV1B0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 166/201] crypto: qat - add param check for DH
Date:   Wed, 27 Jul 2022 18:11:10 +0200
Message-Id: <20220727161034.710630601@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
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

[ Upstream commit 2acbb8771f6ac82422886e63832ee7a0f4b1635b ]

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
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 947eeff181b4..7173a2a0a484 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -235,6 +235,10 @@ static int qat_dh_compute_value(struct kpp_request *req)
 		req->dst_len = ctx->p_size;
 		return -EOVERFLOW;
 	}
+
+	if (req->src_len > ctx->p_size)
+		return -EINVAL;
+
 	memset(msg, '\0', sizeof(*msg));
 	ICP_QAT_FW_PKE_HDR_VALID_FLAG_SET(msg->pke_hdr,
 					  ICP_QAT_FW_COMN_REQ_FLAG_SET);
-- 
2.35.1



