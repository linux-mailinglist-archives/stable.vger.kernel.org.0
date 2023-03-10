Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A80DA6B4759
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbjCJOuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:50:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233234AbjCJOtQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:49:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81CF9121150
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:47:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88331B822BF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF8EC43327;
        Fri, 10 Mar 2023 14:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459662;
        bh=ZoydsZQcik9UuE+HGWRo20gb4MULBUcqolIqn1cTGlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wyrp46tNOVFXr66tIUj/s3VqjT5sJYHiYRhZvx61zdgAns+xASBJ1m5r5eruWFeGv
         uwmwKb+0JGLWMOJTOKAyJdM8Y03bqaf3nR2QnV2LWqhbpEIWNw3f0FX0nD/Ye/p2L4
         jRi2qO66HInX3B7XOSV75yLlAyYUcUOZauY6jBck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andy Nguyen <theflow@google.com>,
        David Rientjes <rientjes@google.com>,
        Peter Gonda <pgonda@google.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 078/529] crypto: ccp - Use kzalloc for sev ioctl interfaces to prevent kernel memory leak
Date:   Fri, 10 Mar 2023 14:33:41 +0100
Message-Id: <20230310133808.593869070@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Allen <john.allen@amd.com>

[ Upstream commit 13dc15a3f5fd7f884e4bfa8c011a0ae868df12ae ]

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
Stable-dep-of: 91dfd98216d8 ("crypto: ccp - Avoid page allocation failure warning for SEV_GET_ID2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 1aac3a12a6c7c..6edd938ce6acc 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -352,6 +352,8 @@ static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
 	struct sev_user_data_status data;
 	int ret;
 
+	memset(&data, 0, sizeof(data));
+
 	ret = __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS, &data, &argp->error);
 	if (ret)
 		return ret;
@@ -405,7 +407,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 	if (input.length > SEV_FW_BLOB_MAX_SIZE)
 		return -EFAULT;
 
-	blob = kmalloc(input.length, GFP_KERNEL);
+	blob = kzalloc(input.length, GFP_KERNEL);
 	if (!blob)
 		return -ENOMEM;
 
@@ -629,7 +631,7 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
 	input_address = (void __user *)input.address;
 
 	if (input.address && input.length) {
-		id_blob = kmalloc(input.length, GFP_KERNEL);
+		id_blob = kzalloc(input.length, GFP_KERNEL);
 		if (!id_blob)
 			return -ENOMEM;
 
@@ -748,14 +750,14 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
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
-- 
2.39.2



