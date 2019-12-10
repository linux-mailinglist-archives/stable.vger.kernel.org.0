Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5BB11994C
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729607AbfLJVdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:33:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:36942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729602AbfLJVdA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:33:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A05B22464;
        Tue, 10 Dec 2019 21:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013580;
        bh=PQnaO16yEfIOBCWFcGEaFc+ZV6bUgyC5DyPZ8fTgcfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AbsD6pITO+xtsV8lol6CmPms4b9bUmbhjfW1u84fPRJDyuh6AF8DnvZSXHB341SYK
         1nCAn8xW1/ffMHqFEu1EOylgu/KH+w524eC5msd7lnjOxwSBTLQTB/3vcYyAlLmnwo
         9GmEz6kPjDraMO++f1gUVO/2si0924VU2yJ/AMcE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 032/177] media: cec-funcs.h: add status_req checks
Date:   Tue, 10 Dec 2019 16:29:56 -0500
Message-Id: <20191210213221.11921-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 9b211f9c5a0b67afc435b86f75d78273b97db1c5 ]

The CEC_MSG_GIVE_DECK_STATUS and CEC_MSG_GIVE_TUNER_DEVICE_STATUS commands
both have a status_req argument: ON, OFF, ONCE. If ON or ONCE, then the
follower will reply with a STATUS message. Either once or whenever the
status changes (status_req == ON).

If status_req == OFF, then it will stop sending continuous status updates,
but the follower will *not* send a STATUS message in that case.

This means that if status_req == OFF, then msg->reply should be 0 as well
since no reply is expected in that case.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/cec-funcs.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/cec-funcs.h b/include/uapi/linux/cec-funcs.h
index 8997d5068c085..4511b85c84dfc 100644
--- a/include/uapi/linux/cec-funcs.h
+++ b/include/uapi/linux/cec-funcs.h
@@ -923,7 +923,8 @@ static inline void cec_msg_give_deck_status(struct cec_msg *msg,
 	msg->len = 3;
 	msg->msg[1] = CEC_MSG_GIVE_DECK_STATUS;
 	msg->msg[2] = status_req;
-	msg->reply = reply ? CEC_MSG_DECK_STATUS : 0;
+	msg->reply = (reply && status_req != CEC_OP_STATUS_REQ_OFF) ?
+				CEC_MSG_DECK_STATUS : 0;
 }
 
 static inline void cec_ops_give_deck_status(const struct cec_msg *msg,
@@ -1027,7 +1028,8 @@ static inline void cec_msg_give_tuner_device_status(struct cec_msg *msg,
 	msg->len = 3;
 	msg->msg[1] = CEC_MSG_GIVE_TUNER_DEVICE_STATUS;
 	msg->msg[2] = status_req;
-	msg->reply = reply ? CEC_MSG_TUNER_DEVICE_STATUS : 0;
+	msg->reply = (reply && status_req != CEC_OP_STATUS_REQ_OFF) ?
+				CEC_MSG_TUNER_DEVICE_STATUS : 0;
 }
 
 static inline void cec_ops_give_tuner_device_status(const struct cec_msg *msg,
-- 
2.20.1

