Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D787499600
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359679AbiAXU6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:58:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47958 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442362AbiAXUy1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:54:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 341156124A;
        Mon, 24 Jan 2022 20:54:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162EDC340E5;
        Mon, 24 Jan 2022 20:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057665;
        bh=VH5ozs5BLXy+4Jx5uCAGo22XB/FZvRGLoQpaQE8nOHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eI8sr5mxDANRbAuPhmOZIoCOlzgzABC2AQPZSyz5h2Le13Vy4H5Gp+AJGT+kRhBpx
         nBwYJBl6Ksnq2e6Mv7M80pm0+iSXhrEQeJ8hvI/dHKTcrxYONweeP/sOvcYgeXlZT3
         OMlqe4MHyYEPvVi9AdVYwq1Dx+AxyjNYrsejlnPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.16 0039/1039] ksmbd: move credit charge deduction under processing request
Date:   Mon, 24 Jan 2022 19:30:28 +0100
Message-Id: <20220124184126.446053646@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

commit 914d7e5709ac59ded70bea7956d408fe2acd7c3c upstream.

Moves the credit charge deduction from total_credits under the processing
a request. When repeating smb2 lock request and other command request,
there will be a problem that ->total_credits does not decrease.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2misc.c |    7 ++-----
 fs/ksmbd/smb2pdu.c  |   16 ++++++++++------
 2 files changed, 12 insertions(+), 11 deletions(-)

--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -289,7 +289,7 @@ static int smb2_validate_credit_charge(s
 	unsigned int req_len = 0, expect_resp_len = 0, calc_credit_num, max_len;
 	unsigned short credit_charge = le16_to_cpu(hdr->CreditCharge);
 	void *__hdr = hdr;
-	int ret;
+	int ret = 0;
 
 	switch (hdr->Command) {
 	case SMB2_QUERY_INFO:
@@ -332,10 +332,7 @@ static int smb2_validate_credit_charge(s
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
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -299,9 +299,8 @@ int smb2_set_rsp_credits(struct ksmbd_wo
 	struct smb2_hdr *req_hdr = ksmbd_req_buf_next(work);
 	struct smb2_hdr *hdr = ksmbd_resp_buf_next(work);
 	struct ksmbd_conn *conn = work->conn;
-	unsigned short credits_requested;
+	unsigned short credits_requested, aux_max;
 	unsigned short credit_charge, credits_granted = 0;
-	unsigned short aux_max, aux_credits;
 
 	if (work->send_no_response)
 		return 0;
@@ -316,6 +315,13 @@ int smb2_set_rsp_credits(struct ksmbd_wo
 
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
 
@@ -325,13 +331,11 @@ int smb2_set_rsp_credits(struct ksmbd_wo
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


