Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A29E35416BA
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377578AbiFGUy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378803AbiFGUwd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:52:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40816F1E;
        Tue,  7 Jun 2022 11:43:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8C09B82018;
        Tue,  7 Jun 2022 18:43:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512C0C385A2;
        Tue,  7 Jun 2022 18:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627386;
        bh=gdjgGA3jTeWt39F5XYCk+VKfrnsbIggp1l16MZwXDVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T8dO+2fMTSmGWsnbhGh7M4GgV75NI17ZvdHcjD+rWfQZvhyocdu3Esp65be6W42cY
         wV/jkkePVmdUbaPSTX33ixESHoAWvO+cx4RjaaGj3dJCf2Yx+APf6cuf5HomedyPrB
         9ErJyvQJjuyzk5aMuGXcXvf/3uR5KmV9lGyAeI/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyunchul Lee <hyc.lee@gmail.com>,
        Yufan Chen <wiz.chen@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.17 720/772] ksmbd: fix outstanding credits related bugs
Date:   Tue,  7 Jun 2022 19:05:12 +0200
Message-Id: <20220607165010.258925531@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Hyunchul Lee <hyc.lee@gmail.com>

commit 376b9133826865568167b4091ef92a68c4622b87 upstream.

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
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/connection.c |    2 +-
 fs/ksmbd/smb2misc.c   |    2 +-
 fs/ksmbd/smb_common.c |    4 +++-
 3 files changed, 5 insertions(+), 3 deletions(-)

--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -62,7 +62,7 @@ struct ksmbd_conn *ksmbd_conn_alloc(void
 	atomic_set(&conn->req_running, 0);
 	atomic_set(&conn->r_count, 0);
 	conn->total_credits = 1;
-	conn->outstanding_credits = 1;
+	conn->outstanding_credits = 0;
 
 	init_waitqueue_head(&conn->req_running_q);
 	INIT_LIST_HEAD(&conn->conns_list);
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -338,7 +338,7 @@ static int smb2_validate_credit_charge(s
 		ret = 1;
 	}
 
-	if ((u64)conn->outstanding_credits + credit_charge > conn->vals->max_credits) {
+	if ((u64)conn->outstanding_credits + credit_charge > conn->total_credits) {
 		ksmbd_debug(SMB, "Limits exceeding the maximum allowable outstanding requests, given : %u, pending : %u\n",
 			    credit_charge, conn->outstanding_credits);
 		ret = 1;
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -140,8 +140,10 @@ int ksmbd_verify_smb_message(struct ksmb
 
 	hdr = work->request_buf;
 	if (*(__le32 *)hdr->Protocol == SMB1_PROTO_NUMBER &&
-	    hdr->Command == SMB_COM_NEGOTIATE)
+	    hdr->Command == SMB_COM_NEGOTIATE) {
+		work->conn->outstanding_credits++;
 		return 0;
+	}
 
 	return -EINVAL;
 }


