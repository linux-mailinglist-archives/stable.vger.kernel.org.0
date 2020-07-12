Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8D021C7D3
	for <lists+stable@lfdr.de>; Sun, 12 Jul 2020 09:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgGLHHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jul 2020 03:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727777AbgGLHHF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Jul 2020 03:07:05 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE95C08C5DD;
        Sun, 12 Jul 2020 00:07:05 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id by13so7992848edb.11;
        Sun, 12 Jul 2020 00:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3nHUKl4XNctrmVFHzNsgRLkFK27wlOc58Cv82KbaxHo=;
        b=fIULQabPHd6xKjjapx2tu57e5k7yU4m6yvy4AtDE5GSpBgkoa4SOKDCHBgGQYit6iX
         z85TUU6F3XDom+Jp9Z2+JwsNjsh4Y/JdXyT2CXWE4p2pt7NVnlRMtNnU6gnIoj0Gs9nB
         cTyqkz+tBScYhIeC/2k2Hg8U7+zWXAePky9xxQf2y2e9WSzMs373N8mcYbLwjLiQk1xz
         i1oHkSgxXC93F2LJUbVKLWZ8dqNs13KpEit1evn1RSwz48HEYNlpZZklBQRhjQ7lAH8Y
         vZLL808KNg6Z9YkQ4dt36BvXIb9Ju+Cr8r+dLLZw4cjMlW4G4n574l3vfqKajqIKD9U2
         Kbng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3nHUKl4XNctrmVFHzNsgRLkFK27wlOc58Cv82KbaxHo=;
        b=K2K63B9OoSjkxoLUJqyGsM/qvLjWm0bIlpZUdQ3Ajka24onvOPsbGTbH06fsfDv6kG
         tca3vD9mF4dadj0qVTMDs/EbsdHWBV270mUsL11duXq1LG1dmggsbXitkSJX0JZABXpD
         ymT5JBppJpxOIBrudMJ4BCO/cuihjpaks6KWwyqC/slV4XuzO9eDl3vA2oKT9/KKGoub
         q5Z1OjZg3xsi6tmsQBp148hfSLhowSbAlBcMscjFoeRC74EbhET2ZE3BKCgqeZnZgnd2
         AvgxJS+YPTlBddphM8WqHfAY3CtwJ9z4VlTxP1WCLKDk6A6BwKxlntvGJSF7MhijV+V1
         Q+kg==
X-Gm-Message-State: AOAM5328+xfI6zcKRITg4F2vJtdkCbSZBXlLY5hYjq/LMRL6bgjhHuBR
        Xm4i+XORGYr90C1hRnfw7Og=
X-Google-Smtp-Source: ABdhPJxr8mekQkfcJf64wIpurpyIu1/EIejxP1OBQc1/ddS6HKuLyoJms7/GZ73d/Fhclwk+gUzLJA==
X-Received: by 2002:aa7:c657:: with SMTP id z23mr77491613edr.265.1594537623778;
        Sun, 12 Jul 2020 00:07:03 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id y24sm6926677ejj.97.2020.07.12.00.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 00:07:03 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 5.8] io_uring: fix missing msg_name assignment
Date:   Sun, 12 Jul 2020 10:05:09 +0300
Message-Id: <fcf14a85d9478be55b72551b3046e898503950c9.1594537448.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ensure to set msg.msg_name for the async portion of send/recvmsg,
as the header copy will copy to/from it.

Cc: stable@vger.kernel.org # 5.5, 5.6, 5.7
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7f2a2cb5c056..8482b9aed952 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3913,6 +3913,7 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
 
+	io->msg.msg.msg_name = &io->msg.addr;
 	io->msg.iov = io->msg.fast_iov;
 	ret = sendmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
 					&io->msg.iov);
@@ -4025,6 +4026,7 @@ static int __io_recvmsg_copy_hdr(struct io_kiocb *req, struct io_async_ctx *io)
 	size_t iov_len;
 	int ret;
 
+	io->msg.msg.msg_name = &io->msg.addr;
 	ret = __copy_msghdr_from_user(&io->msg.msg, sr->msg, &io->msg.uaddr,
 					&uiov, &iov_len);
 	if (ret)
-- 
2.24.0

