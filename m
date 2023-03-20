Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20356C19EB
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233280AbjCTPjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233199AbjCTPjT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:39:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112D838B79
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:30:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 836D7615A7
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955B1C433EF;
        Mon, 20 Mar 2023 15:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679326250;
        bh=jBCWZUU9BlE1C5GrdOf2xmkCaXeJEFIwXnmOFDJ4syQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fg75FRfQBNs0gkFLd4mA0JNrwqXSDbZAIPfNWWgXrstt47SvjNn0wfnb7cwsPG/wU
         NYvm/lj8hnAUUR1xDXkH/NPb/heaJvTfgSyaFa/4SL4W8sRHsDgKfr6oLQ7cBq8hY/
         Gh3sQB5rT2NwgM+OPfSXhWK+S5oNnn0FW467TW2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Borislav Petkov (AMD)" <bp@alien8.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 6.2 208/211] virt/coco/sev-guest: Carve out the request issuing logic into a helper
Date:   Mon, 20 Mar 2023 15:55:43 +0100
Message-Id: <20230320145522.246388991@linuxfoundation.org>
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

commit 0fdb6cc7c89cb5e0cbc45dbdbafb8e3fb92ddc95 upstream.

This makes the code flow a lot easier to follow.

No functional changes.

  [ Tom: touchups. ]

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230307192449.24732-6-bp@alien8.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virt/coco/sev-guest/sev-guest.c |   44 +++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 17 deletions(-)

--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -318,27 +318,12 @@ static int enc_payload(struct snp_guest_
 	return __enc_payload(snp_dev, req, payload, sz);
 }
 
-static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code, int msg_ver,
-				u8 type, void *req_buf, size_t req_sz, void *resp_buf,
-				u32 resp_sz, __u64 *fw_err)
+static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code, __u64 *fw_err)
 {
 	unsigned long err, override_err = 0;
 	unsigned int override_npages = 0;
-	u64 seqno;
 	int rc;
 
-	/* Get message sequence and verify that its a non-zero */
-	seqno = snp_get_msg_seqno(snp_dev);
-	if (!seqno)
-		return -EIO;
-
-	memset(snp_dev->response, 0, sizeof(struct snp_guest_msg));
-
-	/* Encrypt the userspace provided payload */
-	rc = enc_payload(snp_dev, seqno, msg_ver, type, req_buf, req_sz);
-	if (rc)
-		return rc;
-
 retry_request:
 	/*
 	 * Call firmware to process the request. In this function the encrypted
@@ -347,7 +332,6 @@ retry_request:
 	 * prevent reuse of the IV.
 	 */
 	rc = snp_issue_guest_request(exit_code, &snp_dev->input, &err);
-
 	switch (rc) {
 	case -ENOSPC:
 		/*
@@ -401,7 +385,33 @@ retry_request:
 	if (!rc && override_err == SNP_GUEST_REQ_INVALID_LEN)
 		return -EIO;
 
+	return rc;
+}
+
+static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code, int msg_ver,
+				u8 type, void *req_buf, size_t req_sz, void *resp_buf,
+				u32 resp_sz, __u64 *fw_err)
+{
+	u64 seqno;
+	int rc;
+
+	/* Get message sequence and verify that its a non-zero */
+	seqno = snp_get_msg_seqno(snp_dev);
+	if (!seqno)
+		return -EIO;
+
+	memset(snp_dev->response, 0, sizeof(struct snp_guest_msg));
+
+	/* Encrypt the userspace provided payload */
+	rc = enc_payload(snp_dev, seqno, msg_ver, type, req_buf, req_sz);
+	if (rc)
+		return rc;
+
+	rc = __handle_guest_request(snp_dev, exit_code, fw_err);
 	if (rc) {
+		if (rc == -EIO && *fw_err == SNP_GUEST_REQ_INVALID_LEN)
+			return rc;
+
 		dev_alert(snp_dev->dev,
 			  "Detected error from ASP request. rc: %d, fw_err: %llu\n",
 			  rc, *fw_err);


