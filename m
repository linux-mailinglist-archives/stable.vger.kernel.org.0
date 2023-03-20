Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A895A6C19E5
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbjCTPjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233206AbjCTPjM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:39:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C51232E56
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:30:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BAEA1B80EC8
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:30:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C47EC433EF;
        Mon, 20 Mar 2023 15:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679326244;
        bh=4NgtUsg/Q2lOSKKQaoBTHaDt4aa3nA2cB2IgJwU3Z7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SPuQosN7Zb56ZwXhDr986s+VzmiTjrZJT88a7kx4qTwUzjysPTgjMx45wHI0GgmDz
         nb4XNa9TyHMhn7uLji4Wbup+eqLiNjShri6W2v2dYR8CLks9rluSpFgFEXJqLMfYfX
         fi+cRuBd4PWKhQH5YpaEecjIw/YydI8o5BsAkFpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Borislav Petkov (AMD)" <bp@alien8.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 6.2 206/211] virt/coco/sev-guest: Simplify extended guest request handling
Date:   Mon, 20 Mar 2023 15:55:41 +0100
Message-Id: <20230320145522.162740531@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov (AMD) <bp@alien8.de>

commit 970ab823743fb54b42002ec76c51481f67436444 upstream.

Return a specific error code - -ENOSPC - to signal the too small cert
data buffer instead of checking exit code and exitinfo2.

While at it, hoist the *fw_err assignment in snp_issue_guest_request()
so that a proper error value is returned to the callers.

  [ Tom: check override_err instead of err. ]

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230307192449.24732-4-bp@alien8.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/sev.c                   |   11 ++++---
 drivers/virt/coco/sev-guest/sev-guest.c |   48 +++++++++++++++++---------------
 2 files changed, 32 insertions(+), 27 deletions(-)

--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2209,15 +2209,16 @@ int snp_issue_guest_request(u64 exit_cod
 	if (ret)
 		goto e_put;
 
+	*fw_err = ghcb->save.sw_exit_info_2;
 	if (ghcb->save.sw_exit_info_2) {
 		/* Number of expected pages are returned in RBX */
 		if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST &&
-		    ghcb->save.sw_exit_info_2 == SNP_GUEST_REQ_INVALID_LEN)
+		    ghcb->save.sw_exit_info_2 == SNP_GUEST_REQ_INVALID_LEN) {
 			input->data_npages = ghcb_get_rbx(ghcb);
-
-		*fw_err = ghcb->save.sw_exit_info_2;
-
-		ret = -EIO;
+			ret = -ENOSPC;
+		} else {
+			ret = -EIO;
+		}
 	}
 
 e_put:
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -322,7 +322,8 @@ static int handle_guest_request(struct s
 				u8 type, void *req_buf, size_t req_sz, void *resp_buf,
 				u32 resp_sz, __u64 *fw_err)
 {
-	unsigned long err;
+	unsigned long err, override_err = 0;
+	unsigned int override_npages = 0;
 	u64 seqno;
 	int rc;
 
@@ -338,6 +339,7 @@ static int handle_guest_request(struct s
 	if (rc)
 		return rc;
 
+retry_request:
 	/*
 	 * Call firmware to process the request. In this function the encrypted
 	 * message enters shared memory with the host. So after this call the
@@ -346,17 +348,24 @@ static int handle_guest_request(struct s
 	 */
 	rc = snp_issue_guest_request(exit_code, &snp_dev->input, &err);
 
-	/*
-	 * If the extended guest request fails due to having too small of a
-	 * certificate data buffer, retry the same guest request without the
-	 * extended data request in order to increment the sequence number
-	 * and thus avoid IV reuse.
-	 */
-	if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST &&
-	    err == SNP_GUEST_REQ_INVALID_LEN) {
-		const unsigned int certs_npages = snp_dev->input.data_npages;
+	switch (rc) {
+	case -ENOSPC:
+		/*
+		 * If the extended guest request fails due to having too
+		 * small of a certificate data buffer, retry the same
+		 * guest request without the extended data request in
+		 * order to increment the sequence number and thus avoid
+		 * IV reuse.
+		 */
+		override_npages = snp_dev->input.data_npages;
+		exit_code	= SVM_VMGEXIT_GUEST_REQUEST;
 
-		exit_code = SVM_VMGEXIT_GUEST_REQUEST;
+		/*
+		 * Override the error to inform callers the given extended
+		 * request buffer size was too small and give the caller the
+		 * required buffer size.
+		 */
+		override_err	= SNP_GUEST_REQ_INVALID_LEN;
 
 		/*
 		 * If this call to the firmware succeeds, the sequence number can
@@ -366,15 +375,7 @@ static int handle_guest_request(struct s
 		 * of the VMPCK and the error code being propagated back to the
 		 * user as an ioctl() return code.
 		 */
-		rc = snp_issue_guest_request(exit_code, &snp_dev->input, &err);
-
-		/*
-		 * Override the error to inform callers the given extended
-		 * request buffer size was too small and give the caller the
-		 * required buffer size.
-		 */
-		err = SNP_GUEST_REQ_INVALID_LEN;
-		snp_dev->input.data_npages = certs_npages;
+		goto retry_request;
 	}
 
 	/*
@@ -386,7 +387,10 @@ static int handle_guest_request(struct s
 	snp_inc_msg_seqno(snp_dev);
 
 	if (fw_err)
-		*fw_err = err;
+		*fw_err = override_err ?: err;
+
+	if (override_npages)
+		snp_dev->input.data_npages = override_npages;
 
 	/*
 	 * If an extended guest request was issued and the supplied certificate
@@ -394,7 +398,7 @@ static int handle_guest_request(struct s
 	 * prevent IV reuse. If the standard request was successful, return -EIO
 	 * back to the caller as would have originally been returned.
 	 */
-	if (!rc && err == SNP_GUEST_REQ_INVALID_LEN)
+	if (!rc && override_err == SNP_GUEST_REQ_INVALID_LEN)
 		return -EIO;
 
 	if (rc) {


