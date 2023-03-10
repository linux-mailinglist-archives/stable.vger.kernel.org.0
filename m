Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 669426B4752
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233422AbjCJOuG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:50:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbjCJOsh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:48:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6A912209A
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:47:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C0B06196F
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A322C433A0;
        Fri, 10 Mar 2023 14:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459656;
        bh=B1BcAT6wwrx0XeamQGhV7uCFgLyugQc2+9qeSR3HVpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V7IiSyJHFz6PpRoaJytc5oamPPs7EV094ST4w4CFKn1C87reyLi26siJU2HrLGbwL
         cC7jLMB0ymALfFw6JwTcDUbkOFR+QZLPQ3FggYLfGKWQYtJ3JKI42b3/vtpTASPbsy
         mC4ziYeuRddP+RiJhMdEpCv+pITJLBNoRUW0m6gY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/529] crypto: ccp: Use the stack for small SEV command buffers
Date:   Fri, 10 Mar 2023 14:33:39 +0100
Message-Id: <20230310133808.495306749@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit e4a9af799e5539b0feb99571f0aaed5a3c81dc5a ]

For commands with small input/output buffers, use the local stack to
"allocate" the structures used to communicate with the PSP.   Now that
__sev_do_cmd_locked() gracefully handles vmalloc'd buffers, there's no
reason to avoid using the stack, e.g. CONFIG_VMAP_STACK=y will just work.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210406224952.4177376-6-seanjc@google.com>
Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 91dfd98216d8 ("crypto: ccp - Avoid page allocation failure warning for SEV_GET_ID2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 117 +++++++++++++----------------------
 1 file changed, 44 insertions(+), 73 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index ed39a22e1b2b9..75341ad2fdd8a 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -385,7 +385,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_pek_csr input;
-	struct sev_data_pek_csr *data;
+	struct sev_data_pek_csr data;
 	void __user *input_address;
 	void *blob = NULL;
 	int ret;
@@ -396,9 +396,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
 		return -EFAULT;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
+	memset(&data, 0, sizeof(data));
 
 	/* userspace wants to query CSR length */
 	if (!input.address || !input.length)
@@ -406,19 +404,15 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 
 	/* allocate a physically contiguous buffer to store the CSR blob */
 	input_address = (void __user *)input.address;
-	if (input.length > SEV_FW_BLOB_MAX_SIZE) {
-		ret = -EFAULT;
-		goto e_free;
-	}
+	if (input.length > SEV_FW_BLOB_MAX_SIZE)
+		return -EFAULT;
 
 	blob = kmalloc(input.length, GFP_KERNEL);
-	if (!blob) {
-		ret = -ENOMEM;
-		goto e_free;
-	}
+	if (!blob)
+		return -ENOMEM;
 
-	data->address = __psp_pa(blob);
-	data->len = input.length;
+	data.address = __psp_pa(blob);
+	data.len = input.length;
 
 cmd:
 	if (sev->state == SEV_STATE_UNINIT) {
@@ -427,10 +421,10 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 			goto e_free_blob;
 	}
 
-	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, data, &argp->error);
+	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->error);
 
 	 /* If we query the CSR length, FW responded with expected data. */
-	input.length = data->len;
+	input.length = data.len;
 
 	if (copy_to_user((void __user *)argp->data, &input, sizeof(input))) {
 		ret = -EFAULT;
@@ -444,8 +438,6 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 
 e_free_blob:
 	kfree(blob);
-e_free:
-	kfree(data);
 	return ret;
 }
 
@@ -577,7 +569,7 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_pek_cert_import input;
-	struct sev_data_pek_cert_import *data;
+	struct sev_data_pek_cert_import data;
 	void *pek_blob, *oca_blob;
 	int ret;
 
@@ -587,19 +579,14 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
 		return -EFAULT;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
 	/* copy PEK certificate blobs from userspace */
 	pek_blob = psp_copy_user_blob(input.pek_cert_address, input.pek_cert_len);
-	if (IS_ERR(pek_blob)) {
-		ret = PTR_ERR(pek_blob);
-		goto e_free;
-	}
+	if (IS_ERR(pek_blob))
+		return PTR_ERR(pek_blob);
 
-	data->pek_cert_address = __psp_pa(pek_blob);
-	data->pek_cert_len = input.pek_cert_len;
+	data.reserved = 0;
+	data.pek_cert_address = __psp_pa(pek_blob);
+	data.pek_cert_len = input.pek_cert_len;
 
 	/* copy PEK certificate blobs from userspace */
 	oca_blob = psp_copy_user_blob(input.oca_cert_address, input.oca_cert_len);
@@ -608,8 +595,8 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 		goto e_free_pek;
 	}
 
-	data->oca_cert_address = __psp_pa(oca_blob);
-	data->oca_cert_len = input.oca_cert_len;
+	data.oca_cert_address = __psp_pa(oca_blob);
+	data.oca_cert_len = input.oca_cert_len;
 
 	/* If platform is not in INIT state then transition it to INIT */
 	if (sev->state != SEV_STATE_INIT) {
@@ -618,21 +605,19 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 			goto e_free_oca;
 	}
 
-	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, data, &argp->error);
+	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data, &argp->error);
 
 e_free_oca:
 	kfree(oca_blob);
 e_free_pek:
 	kfree(pek_blob);
-e_free:
-	kfree(data);
 	return ret;
 }
 
 static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
 {
 	struct sev_user_data_get_id2 input;
-	struct sev_data_get_id *data;
+	struct sev_data_get_id data;
 	void __user *input_address;
 	void *id_blob = NULL;
 	int ret;
@@ -646,28 +631,25 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
 
 	input_address = (void __user *)input.address;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
 	if (input.address && input.length) {
 		id_blob = kmalloc(input.length, GFP_KERNEL);
-		if (!id_blob) {
-			kfree(data);
+		if (!id_blob)
 			return -ENOMEM;
-		}
 
-		data->address = __psp_pa(id_blob);
-		data->len = input.length;
+		data.address = __psp_pa(id_blob);
+		data.len = input.length;
+	} else {
+		data.address = 0;
+		data.len = 0;
 	}
 
-	ret = __sev_do_cmd_locked(SEV_CMD_GET_ID, data, &argp->error);
+	ret = __sev_do_cmd_locked(SEV_CMD_GET_ID, &data, &argp->error);
 
 	/*
 	 * Firmware will return the length of the ID value (either the minimum
 	 * required length or the actual length written), return it to the user.
 	 */
-	input.length = data->len;
+	input.length = data.len;
 
 	if (copy_to_user((void __user *)argp->data, &input, sizeof(input))) {
 		ret = -EFAULT;
@@ -675,7 +657,7 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
 	}
 
 	if (id_blob) {
-		if (copy_to_user(input_address, id_blob, data->len)) {
+		if (copy_to_user(input_address, id_blob, data.len)) {
 			ret = -EFAULT;
 			goto e_free;
 		}
@@ -683,7 +665,6 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
 
 e_free:
 	kfree(id_blob);
-	kfree(data);
 
 	return ret;
 }
@@ -733,7 +714,7 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_pdh_cert_export input;
 	void *pdh_blob = NULL, *cert_blob = NULL;
-	struct sev_data_pdh_cert_export *data;
+	struct sev_data_pdh_cert_export data;
 	void __user *input_cert_chain_address;
 	void __user *input_pdh_cert_address;
 	int ret;
@@ -751,9 +732,7 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
 		return -EFAULT;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
+	memset(&data, 0, sizeof(data));
 
 	/* Userspace wants to query the certificate length. */
 	if (!input.pdh_cert_address ||
@@ -765,25 +744,19 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	input_cert_chain_address = (void __user *)input.cert_chain_address;
 
 	/* Allocate a physically contiguous buffer to store the PDH blob. */
-	if (input.pdh_cert_len > SEV_FW_BLOB_MAX_SIZE) {
-		ret = -EFAULT;
-		goto e_free;
-	}
+	if (input.pdh_cert_len > SEV_FW_BLOB_MAX_SIZE)
+		return -EFAULT;
 
 	/* Allocate a physically contiguous buffer to store the cert chain blob. */
-	if (input.cert_chain_len > SEV_FW_BLOB_MAX_SIZE) {
-		ret = -EFAULT;
-		goto e_free;
-	}
+	if (input.cert_chain_len > SEV_FW_BLOB_MAX_SIZE)
+		return -EFAULT;
 
 	pdh_blob = kmalloc(input.pdh_cert_len, GFP_KERNEL);
-	if (!pdh_blob) {
-		ret = -ENOMEM;
-		goto e_free;
-	}
+	if (!pdh_blob)
+		return -ENOMEM;
 
-	data->pdh_cert_address = __psp_pa(pdh_blob);
-	data->pdh_cert_len = input.pdh_cert_len;
+	data.pdh_cert_address = __psp_pa(pdh_blob);
+	data.pdh_cert_len = input.pdh_cert_len;
 
 	cert_blob = kmalloc(input.cert_chain_len, GFP_KERNEL);
 	if (!cert_blob) {
@@ -791,15 +764,15 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 		goto e_free_pdh;
 	}
 
-	data->cert_chain_address = __psp_pa(cert_blob);
-	data->cert_chain_len = input.cert_chain_len;
+	data.cert_chain_address = __psp_pa(cert_blob);
+	data.cert_chain_len = input.cert_chain_len;
 
 cmd:
-	ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, data, &argp->error);
+	ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, &data, &argp->error);
 
 	/* If we query the length, FW responded with expected data. */
-	input.cert_chain_len = data->cert_chain_len;
-	input.pdh_cert_len = data->pdh_cert_len;
+	input.cert_chain_len = data.cert_chain_len;
+	input.pdh_cert_len = data.pdh_cert_len;
 
 	if (copy_to_user((void __user *)argp->data, &input, sizeof(input))) {
 		ret = -EFAULT;
@@ -824,8 +797,6 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	kfree(cert_blob);
 e_free_pdh:
 	kfree(pdh_blob);
-e_free:
-	kfree(data);
 	return ret;
 }
 
-- 
2.39.2



