Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213E3496858
	for <lists+stable@lfdr.de>; Sat, 22 Jan 2022 00:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiAUXyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jan 2022 18:54:02 -0500
Received: from mail-pj1-f49.google.com ([209.85.216.49]:35785 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiAUXyB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jan 2022 18:54:01 -0500
Received: by mail-pj1-f49.google.com with SMTP id w12-20020a17090a528c00b001b276aa3aabso14970983pjh.0;
        Fri, 21 Jan 2022 15:54:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kiSTIgq2L6RzGs0SDabU1lIwcvCVrILXPf+FV7lZnhk=;
        b=LybJaZG5qzyZMszhaUPqh+UyZefW79qDvgmQ170mp47Yzup4PklmT242MUQTd/EoLW
         n+taLod1aelC9atKVyKxMQgXAuGexWjUNyVIOVyZ1FNcOMkkco4RLuxIeoXoIGFp/MG+
         VOADqPo8+H+NqULUv3Rar0Rkf4QePy5NQdiylZjP9pbt/hxHm6Rzj6+PFgqgb1GQWDUW
         8PlqLAuPkjSDRCtXXmyp2xd7h7j26Q41rzX7COPiDRH6sCmwgan2NDIrTqB97CXC3bs8
         ryTpsKvxAKsCWZ0xQdiaVfWCXS5+uD0ozZcxhtrukdIsKM9udrzjbQkgMN1zhozROp5H
         pyoA==
X-Gm-Message-State: AOAM532AbVYgfnUm8gKlRlIQKGRa8x2yOHhZd+RtZwTVzqY4rxGPF8Ez
        hNIAb21NMz5Wpm/t2ZO9avw=
X-Google-Smtp-Source: ABdhPJz3Axor6BLNUdu1mkm4qXB65ctwuDIhbq8aEqspxz0VnWvMemNSMPikUmqmAJycmV8zf6p1cg==
X-Received: by 2002:a17:90a:56:: with SMTP id 22mr2874962pjb.199.1642809241290;
        Fri, 21 Jan 2022 15:54:01 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id nn14sm6076356pjb.26.2022.01.21.15.53.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 15:54:01 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, smfrench@gmail.com,
        linux-cifs@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15.y 2/4] ksmbd: move credit charge deduction under processing request
Date:   Sat, 22 Jan 2022 08:53:38 +0900
Message-Id: <20220121235340.10269-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220121235340.10269-1-linkinjeon@kernel.org>
References: <20220121235340.10269-1-linkinjeon@kernel.org>
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
index f8f031978d06..e4a28eae51b2 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -290,7 +290,7 @@ static int smb2_validate_credit_charge(struct ksmbd_conn *conn,
 	unsigned int req_len = 0, expect_resp_len = 0, calc_credit_num, max_len;
 	unsigned short credit_charge = le16_to_cpu(hdr->CreditCharge);
 	void *__hdr = hdr;
-	int ret;
+	int ret = 0;
 
 	switch (hdr->Command) {
 	case SMB2_QUERY_INFO:
@@ -333,10 +333,7 @@ static int smb2_validate_credit_charge(struct ksmbd_conn *conn,
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
index 7be0e0994e10..0ce35717cdde 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -301,9 +301,8 @@ int smb2_set_rsp_credits(struct ksmbd_work *work)
 	struct smb2_hdr *req_hdr = ksmbd_req_buf_next(work);
 	struct smb2_hdr *hdr = ksmbd_resp_buf_next(work);
 	struct ksmbd_conn *conn = work->conn;
-	unsigned short credits_requested;
+	unsigned short credits_requested, aux_max;
 	unsigned short credit_charge, credits_granted = 0;
-	unsigned short aux_max, aux_credits;
 
 	if (work->send_no_response)
 		return 0;
@@ -318,6 +317,13 @@ int smb2_set_rsp_credits(struct ksmbd_work *work)
 
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
 
@@ -327,13 +333,11 @@ int smb2_set_rsp_credits(struct ksmbd_work *work)
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

