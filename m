Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97267496863
	for <lists+stable@lfdr.de>; Sat, 22 Jan 2022 00:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbiAUXyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jan 2022 18:54:46 -0500
Received: from mail-pg1-f182.google.com ([209.85.215.182]:40845 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiAUXyp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jan 2022 18:54:45 -0500
Received: by mail-pg1-f182.google.com with SMTP id t32so9383285pgm.7;
        Fri, 21 Jan 2022 15:54:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yzdxpmAyNmyGcjnwjXl5CCcayGvezoMVG7GDAqHj0Fw=;
        b=7FjAmDRmzd/+9VSdrXONFSpJigapbcSu++XTbA3mxdQGcOchDTqkuClOv737wdqp9l
         g1W0Q5FXDCpnPzTfJ9Qf04B9IijUbgabLICgj9drz3Ry/qNIsf02up1D/wo5Pi6rCU73
         wF7VKg8zCNJyskD3CzzVfPIr7ZEla2u+V5V1U5flgfPrQ/PWMWxSvYaXFTGXugmxFqEe
         XqmlwlvwFqOnHatCO5IuSZD+J1XTsjDt8ejlkPGz6y/xsr9gqCcv9WCh3v/Zy8af3Ijm
         jVFcTJijTACmKt48DkrFBKn7uqMzfDtcfhQ41M3xhd96dgAjGQ/V5R9E2zwC6yCdtvW6
         Rqpw==
X-Gm-Message-State: AOAM532MgRy+uBBVSX1hsZ1Qjs/2offsrN9wyEd4pq3K1PK4CaqIkILE
        A3FebZTZq27PTHLJAUprfnU=
X-Google-Smtp-Source: ABdhPJy/jDL9C4ofYz0vw6uCxZhPoiZDK8A3JjjqdIsuFQ0wMupV4b/KrP+a6eHhey4WsbH6jiIltQ==
X-Received: by 2002:a05:6a00:c89:b0:4bf:29cf:b055 with SMTP id a9-20020a056a000c8900b004bf29cfb055mr5687054pfv.58.1642809285083;
        Fri, 21 Jan 2022 15:54:45 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id 5sm14530082pjf.34.2022.01.21.15.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 15:54:44 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, smfrench@gmail.com,
        linux-cifs@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.16.y 2/4] ksmbd: move credit charge deduction under processing request
Date:   Sat, 22 Jan 2022 08:54:25 +0900
Message-Id: <20220121235427.10349-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220121235427.10349-1-linkinjeon@kernel.org>
References: <20220121235427.10349-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 914d7e5709ac59ded70bea7956d408fe2acd7c3c upstream.

Moves the credit charge deduction from total_credits under the processing
a request. When repeating smb2 lock request and other command request,
there will be a problem that ->total_credits does not decrease.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/ksmbd/smb2misc.c |  7 ++-----
 fs/ksmbd/smb2pdu.c  | 16 ++++++++++------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
index 6892d1822269..fedcb753c7af 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -289,7 +289,7 @@ static int smb2_validate_credit_charge(struct ksmbd_conn *conn,
 	unsigned int req_len = 0, expect_resp_len = 0, calc_credit_num, max_len;
 	unsigned short credit_charge = le16_to_cpu(hdr->CreditCharge);
 	void *__hdr = hdr;
-	int ret;
+	int ret = 0;
 
 	switch (hdr->Command) {
 	case SMB2_QUERY_INFO:
@@ -332,10 +332,7 @@ static int smb2_validate_credit_charge(struct ksmbd_conn *conn,
 	}
 
 	spin_lock(&conn->credits_lock);
-	if (credit_charge <= conn->total_credits) {
-		conn->total_credits -= credit_charge;
-		ret = 0;
-	} else {
+	if (credit_charge > conn->total_credits) {
 		ksmbd_debug(SMB, "Insufficient credits granted, given: %u, granted: %u\n",
 			    credit_charge, conn->total_credits);
 		ret = 1;
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index d8f89b753c54..cbeadaf20697 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -299,9 +299,8 @@ int smb2_set_rsp_credits(struct ksmbd_work *work)
 	struct smb2_hdr *req_hdr = ksmbd_req_buf_next(work);
 	struct smb2_hdr *hdr = ksmbd_resp_buf_next(work);
 	struct ksmbd_conn *conn = work->conn;
-	unsigned short credits_requested;
+	unsigned short credits_requested, aux_max;
 	unsigned short credit_charge, credits_granted = 0;
-	unsigned short aux_max, aux_credits;
 
 	if (work->send_no_response)
 		return 0;
@@ -316,6 +315,13 @@ int smb2_set_rsp_credits(struct ksmbd_work *work)
 
 	credit_charge = max_t(unsigned short,
 			      le16_to_cpu(req_hdr->CreditCharge), 1);
+	if (credit_charge > conn->total_credits) {
+		ksmbd_debug(SMB, "Insufficient credits granted, given: %u, granted: %u\n",
+			    credit_charge, conn->total_credits);
+		return -EINVAL;
+	}
+
+	conn->total_credits -= credit_charge;
 	credits_requested = max_t(unsigned short,
 				  le16_to_cpu(req_hdr->CreditRequest), 1);
 
@@ -325,13 +331,11 @@ int smb2_set_rsp_credits(struct ksmbd_work *work)
 	 * TODO: Need to adjuct CreditRequest value according to
 	 * current cpu load
 	 */
-	aux_credits = credits_requested - 1;
 	if (hdr->Command == SMB2_NEGOTIATE)
-		aux_max = 0;
+		aux_max = 1;
 	else
 		aux_max = conn->vals->max_credits - credit_charge;
-	aux_credits = min_t(unsigned short, aux_credits, aux_max);
-	credits_granted = credit_charge + aux_credits;
+	credits_granted = min_t(unsigned short, credits_requested, aux_max);
 
 	if (conn->vals->max_credits - conn->total_credits < credits_granted)
 		credits_granted = conn->vals->max_credits -
-- 
2.25.1

