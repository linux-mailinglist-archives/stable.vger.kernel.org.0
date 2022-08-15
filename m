Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2629E593B1B
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241251AbiHOUOT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346161AbiHOUKz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:10:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F657670;
        Mon, 15 Aug 2022 11:56:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0857EB8109E;
        Mon, 15 Aug 2022 18:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3069FC433C1;
        Mon, 15 Aug 2022 18:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589807;
        bh=oaG8uRFFATYpJIIbw+3NNlxAQIMb14Wg6pkWXbXB2uw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NLArbumIyyQIwgSxpDdUDl07W53UIOTHHAcxcZ0WnqYJcjKNEi1W3M5M0+SQi97db
         DDqtH1PtzaNAAvb4BhnIdgvQx/Zx9nK1lhtDyvsHS6z1JQOE4XZ6t/hHqnljFIJQ8g
         kQ2FXWQYAlpdePPxPslP88f0PomNGQDzP+rCd+Uw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Nguyen <theflow@google.com>,
        David Rientjes <rientjes@google.com>,
        Peter Gonda <pgonda@google.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.18 0054/1095] crypto: ccp - Use kzalloc for sev ioctl interfaces to prevent kernel memory leak
Date:   Mon, 15 Aug 2022 19:50:53 +0200
Message-Id: <20220815180431.705430741@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: John Allen <john.allen@amd.com>

commit 13dc15a3f5fd7f884e4bfa8c011a0ae868df12ae upstream.

For some sev ioctl interfaces, input may be passed that is less than or
equal to SEV_FW_BLOB_MAX_SIZE, but larger than the data that PSP
firmware returns. In this case, kmalloc will allocate memory that is the
size of the input rather than the size of the data. Since PSP firmware
doesn't fully overwrite the buffer, the sev ioctl interfaces with the
issue may return uninitialized slab memory.

Currently, all of the ioctl interfaces in the ccp driver are safe, but
to prevent future problems, change all ioctl interfaces that allocate
memory with kmalloc to use kzalloc and memset the data buffer to zero
in sev_ioctl_do_platform_status.

Fixes: 38103671aad3 ("crypto: ccp: Use the stack and common buffer for status commands")
Fixes: e799035609e15 ("crypto: ccp: Implement SEV_PEK_CSR ioctl command")
Fixes: 76a2b524a4b1d ("crypto: ccp: Implement SEV_PDH_CERT_EXPORT ioctl command")
Fixes: d6112ea0cb344 ("crypto: ccp - introduce SEV_GET_ID2 command")
Cc: stable@vger.kernel.org
Reported-by: Andy Nguyen <theflow@google.com>
Suggested-by: David Rientjes <rientjes@google.com>
Suggested-by: Peter Gonda <pgonda@google.com>
Signed-off-by: John Allen <john.allen@amd.com>
Reviewed-by: Peter Gonda <pgonda@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/ccp/sev-dev.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -577,6 +577,8 @@ static int sev_ioctl_do_platform_status(
 	struct sev_user_data_status data;
 	int ret;
 
+	memset(&data, 0, sizeof(data));
+
 	ret = __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS, &data, &argp->error);
 	if (ret)
 		return ret;
@@ -630,7 +632,7 @@ static int sev_ioctl_do_pek_csr(struct s
 	if (input.length > SEV_FW_BLOB_MAX_SIZE)
 		return -EFAULT;
 
-	blob = kmalloc(input.length, GFP_KERNEL);
+	blob = kzalloc(input.length, GFP_KERNEL);
 	if (!blob)
 		return -ENOMEM;
 
@@ -854,7 +856,7 @@ static int sev_ioctl_do_get_id2(struct s
 	input_address = (void __user *)input.address;
 
 	if (input.address && input.length) {
-		id_blob = kmalloc(input.length, GFP_KERNEL);
+		id_blob = kzalloc(input.length, GFP_KERNEL);
 		if (!id_blob)
 			return -ENOMEM;
 
@@ -973,14 +975,14 @@ static int sev_ioctl_do_pdh_export(struc
 	if (input.cert_chain_len > SEV_FW_BLOB_MAX_SIZE)
 		return -EFAULT;
 
-	pdh_blob = kmalloc(input.pdh_cert_len, GFP_KERNEL);
+	pdh_blob = kzalloc(input.pdh_cert_len, GFP_KERNEL);
 	if (!pdh_blob)
 		return -ENOMEM;
 
 	data.pdh_cert_address = __psp_pa(pdh_blob);
 	data.pdh_cert_len = input.pdh_cert_len;
 
-	cert_blob = kmalloc(input.cert_chain_len, GFP_KERNEL);
+	cert_blob = kzalloc(input.cert_chain_len, GFP_KERNEL);
 	if (!cert_blob) {
 		ret = -ENOMEM;
 		goto e_free_pdh;


