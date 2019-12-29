Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2103412C7D5
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731215AbfL2RrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:47:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:57646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731212AbfL2RrM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:47:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A81220718;
        Sun, 29 Dec 2019 17:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641631;
        bh=JQavVVK4m8ATRA49WjZPbeYlVPVpntoS23ebp+Y/E8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CcLWT68gJHp+Kt0EASKoaQ1bpCpOUKEuC9XvbMWUjt95i2q7jJ/9vjho0hWVPKs1U
         ZUndZCIKxap+tlP9DSAZ+091B8pr6rWwSCRDNdBhVigyjw1jSgzAImrY25ihJFWgd6
         LY6Ot9k5+frb5iNvOj++BG+w+GIwLXM+px/BkIGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 107/434] media: cec-funcs.h: add status_req checks
Date:   Sun, 29 Dec 2019 18:22:40 +0100
Message-Id: <20191229172708.732337880@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8997d5068c08..4511b85c84df 100644
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



