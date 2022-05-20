Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFC452E4AB
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 08:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238456AbiETGGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 02:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345729AbiETGGH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 02:06:07 -0400
X-Greylist: delayed 1800 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 19 May 2022 23:06:05 PDT
Received: from lgeamrelo11.lge.com (lgeamrelo13.lge.com [156.147.23.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3E8E0DED8
        for <stable@vger.kernel.org>; Thu, 19 May 2022 23:06:01 -0700 (PDT)
Received: from unknown (HELO lgeamrelo04.lge.com) (156.147.1.127)
        by 156.147.23.53 with ESMTP; 20 May 2022 14:36:00 +0900
X-Original-SENDERIP: 156.147.1.127
X-Original-MAILFROM: hyc.lee@gmail.com
Received: from unknown (HELO localhost.localdomain) (10.177.245.62)
        by 156.147.1.127 with ESMTP; 20 May 2022 14:36:00 +0900
X-Original-SENDERIP: 10.177.245.62
X-Original-MAILFROM: hyc.lee@gmail.com
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <sfrench@samba.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        stable@vger.kernel.org
Subject: [PATCH v3] ksmbd: fix outstanding credits related bugs
Date:   Fri, 20 May 2022 14:35:47 +0900
Message-Id: <20220520053547.29034-1-hyc.lee@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_SOFTFAIL,SPOOFED_FREEMAIL,SPOOF_GMAIL_MID,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

outstanding credits must be initialized to 0,
because it means the sum of credits consumed by
in-flight requests.
And outstanding credits must be compared with
total credits in smb2_validate_credit_charge(),
because total credits are the sum of credits
granted by ksmbd.

This patch fix the following error,
while frametest with Windows clients:

Limits exceeding the maximum allowable outstanding requests,
given : 128, pending : 8065

Fixes: b589f5db6d4a ("ksmbd: limits exceeding the maximum allowable outstanding requests")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Reported-by: Yufan Chen <wiz.chen@gmail.com>
Tested-by: Yufan Chen <wiz.chen@gmail.com>
---
changes from v2:
 - fix underflow issue of outstanding credits while mutli-protocol negotiation
   with an Windows client
changes from v1:
 - Add "Fixes" and stable tags

 fs/ksmbd/connection.c | 2 +-
 fs/ksmbd/smb2misc.c   | 2 +-
 fs/ksmbd/smb_common.c | 4 +++-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index 7db87771884a..e8f476c5f189 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -62,7 +62,7 @@ struct ksmbd_conn *ksmbd_conn_alloc(void)
 	atomic_set(&conn->req_running, 0);
 	atomic_set(&conn->r_count, 0);
 	conn->total_credits = 1;
-	conn->outstanding_credits = 1;
+	conn->outstanding_credits = 0;
 
 	init_waitqueue_head(&conn->req_running_q);
 	INIT_LIST_HEAD(&conn->conns_list);
diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
index 4a9460153b59..f8f456377a51 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -338,7 +338,7 @@ static int smb2_validate_credit_charge(struct ksmbd_conn *conn,
 		ret = 1;
 	}
 
-	if ((u64)conn->outstanding_credits + credit_charge > conn->vals->max_credits) {
+	if ((u64)conn->outstanding_credits + credit_charge > conn->total_credits) {
 		ksmbd_debug(SMB, "Limits exceeding the maximum allowable outstanding requests, given : %u, pending : %u\n",
 			    credit_charge, conn->outstanding_credits);
 		ret = 1;
diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
index 9a7e211dbf4f..a336715e35e5 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -140,8 +140,10 @@ int ksmbd_verify_smb_message(struct ksmbd_work *work)
 
 	hdr = work->request_buf;
 	if (*(__le32 *)hdr->Protocol == SMB1_PROTO_NUMBER &&
-	    hdr->Command == SMB_COM_NEGOTIATE)
+	    hdr->Command == SMB_COM_NEGOTIATE) {
+		work->conn->outstanding_credits += 1;
 		return 0;
+	}
 
 	return -EINVAL;
 }
-- 
2.17.1

