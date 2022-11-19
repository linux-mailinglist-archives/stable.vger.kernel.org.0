Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D89AD63094A
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233606AbiKSCMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:12:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233729AbiKSCMJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:12:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA50E6DFD9;
        Fri, 18 Nov 2022 18:11:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67ACE62837;
        Sat, 19 Nov 2022 02:11:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB214C433C1;
        Sat, 19 Nov 2022 02:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668823909;
        bh=HPphypBY4uY1rIxKcDmNvQVVeBl6fF5vcgXCR0pBTHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VUnuLJb74izBogHC2QClyVmxVdlNnfLAdVFAhEOjQrI/BMa+/+RDQPaoTOf9gMR8d
         VxD4ug8gC0zgZEQmiRapFSJl0claTaKukJHq9dE5zGU9aJaLE9KOsBbhNFgOCTJ3Pz
         qGVcLckk3SRYFQs4XtWIcqy7dMxIhke9q25sy184bh/l8/VQKg/hA1qE8bKS0lTxqC
         8ILDnDoMYHjsCRcTwh6SNgyrfrkfaVGFF3+iSiRyUL/sPMXrNr2RCkBaci/ImR/q2a
         eceQ9/dW7YM/GWHplKuh0/1Sw5AM78aADsR/Vd9/s8lMS2h856K1XZZlHYTuZ6aWIX
         JDmF4CF/R4gMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harald Freudenberger <freude@linux.ibm.com>,
        =?UTF-8?q?J=C3=BCrgen=20Christ?= <jchrist@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, hca@linux.ibm.com,
        agordeev@linux.ibm.com, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 11/44] s390/zcrypt: fix warning about field-spanning write
Date:   Fri, 18 Nov 2022 21:10:51 -0500
Message-Id: <20221119021124.1773699-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021124.1773699-1-sashal@kernel.org>
References: <20221119021124.1773699-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit b43088f30db1a7bff61c8486238c195c77788d6d ]

This patch fixes the warning

memcpy: detected field-spanning write (size 60) of single field "to" at drivers/s390/crypto/zcrypt_api.h:173 (size 2)
WARNING: CPU: 1 PID: 2114 at drivers/s390/crypto/zcrypt_api.h:173 prep_ep11_ap_msg+0x2c6/0x2e0 [zcrypt]

The code has been rewritten to use a union in combination
with a flex array to clearly state which part of the buffer
the payload is to be copied in via z_copy_from_user
function (which may call memcpy() in case of in-kernel calls).

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Suggested-by: Jürgen Christ <jchrist@linux.ibm.com>
Reviewed-by: Jürgen Christ <jchrist@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/zcrypt_msgtype6.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/crypto/zcrypt_msgtype6.c b/drivers/s390/crypto/zcrypt_msgtype6.c
index 8fb34b8eeb18..5ad251477593 100644
--- a/drivers/s390/crypto/zcrypt_msgtype6.c
+++ b/drivers/s390/crypto/zcrypt_msgtype6.c
@@ -342,7 +342,10 @@ static int xcrb_msg_to_type6cprb_msgx(bool userspace, struct ap_message *ap_msg,
 	};
 	struct {
 		struct type6_hdr hdr;
-		struct CPRBX cprbx;
+		union {
+			struct CPRBX cprbx;
+			DECLARE_FLEX_ARRAY(u8, userdata);
+		};
 	} __packed * msg = ap_msg->msg;
 
 	int rcblen = CEIL4(xcrb->request_control_blk_length);
@@ -403,7 +406,8 @@ static int xcrb_msg_to_type6cprb_msgx(bool userspace, struct ap_message *ap_msg,
 	msg->hdr.fromcardlen2 = xcrb->reply_data_length;
 
 	/* prepare CPRB */
-	if (z_copy_from_user(userspace, &msg->cprbx, xcrb->request_control_blk_addr,
+	if (z_copy_from_user(userspace, msg->userdata,
+			     xcrb->request_control_blk_addr,
 			     xcrb->request_control_blk_length))
 		return -EFAULT;
 	if (msg->cprbx.cprb_len + sizeof(msg->hdr.function_code) >
@@ -469,9 +473,14 @@ static int xcrb_msg_to_type6_ep11cprb_msgx(bool userspace, struct ap_message *ap
 
 	struct {
 		struct type6_hdr hdr;
-		struct ep11_cprb cprbx;
-		unsigned char	pld_tag;	/* fixed value 0x30 */
-		unsigned char	pld_lenfmt;	/* payload length format */
+		union {
+			struct {
+				struct ep11_cprb cprbx;
+				unsigned char pld_tag;    /* fixed value 0x30 */
+				unsigned char pld_lenfmt; /* length format */
+			} __packed;
+			DECLARE_FLEX_ARRAY(u8, userdata);
+		};
 	} __packed * msg = ap_msg->msg;
 
 	struct pld_hdr {
@@ -500,7 +509,7 @@ static int xcrb_msg_to_type6_ep11cprb_msgx(bool userspace, struct ap_message *ap
 	msg->hdr.fromcardlen1 = xcrb->resp_len;
 
 	/* Import CPRB data from the ioctl input parameter */
-	if (z_copy_from_user(userspace, &msg->cprbx.cprb_len,
+	if (z_copy_from_user(userspace, msg->userdata,
 			     (char __force __user *)xcrb->req, xcrb->req_len)) {
 		return -EFAULT;
 	}
-- 
2.35.1

