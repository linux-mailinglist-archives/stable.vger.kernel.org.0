Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9FC53E6C4
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235541AbiFFLmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 07:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235545AbiFFLmI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 07:42:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEFF13BA
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 04:42:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72BC560F7E
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 11:42:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F260C385A9;
        Mon,  6 Jun 2022 11:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654515726;
        bh=v5amNq3sS4UgwFE9duNMZkkSbkh7D80Oxm0Va1bfX70=;
        h=Subject:To:Cc:From:Date:From;
        b=uMbJsQTb64mPTU5WRc+UdmABQrCEX+9tK4EquHfoRUrLywxQkewY3Pqj+3noKGQND
         k+8HnkKiWMqubE8HP+6DODe7B6slGvwKbtiGmwKHf2CY5bYZKAovnXGIXR7J/rcClq
         UqsB0FzzS4Wt9XAW8bzzJsf6YPJcHAgMg5RX5P+M=
Subject: WTF: patch "[PATCH] crypto: qat - add param check for RSA" was seriously submitted to be applied to the 5.18-stable tree?
To:     giovanni.cabiddu@intel.com, adam.guerin@intel.com,
        herbert@gondor.apana.org.au, wojciech.ziemba@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 13:42:01 +0200
Message-ID: <165451572118022@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

The patch below was submitted to be applied to the 5.18-stable tree.

I fail to see how this patch meets the stable kernel rules as found at
Documentation/process/stable-kernel-rules.rst.

I could be totally wrong, and if so, please respond to 
<stable@vger.kernel.org> and let me know why this patch should be
applied.  Otherwise, it is now dropped from my patch queues, never to be
seen again.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9714061423b8b24b8afb31b8eb4df977c63f19c4 Mon Sep 17 00:00:00 2001
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Date: Mon, 9 May 2022 14:34:14 +0100
Subject: [PATCH] crypto: qat - add param check for RSA

Reject requests with a source buffer that is bigger than the size of the
key. This is to prevent a possible integer underflow that might happen
when copying the source scatterlist into a linear buffer.

Cc: stable@vger.kernel.org
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

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

