Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9020C121838
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbfLPSAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:00:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:34788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728949AbfLPSAg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:00:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E668E20726;
        Mon, 16 Dec 2019 18:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519236;
        bh=qpNwJcQPCMoeoqAQpmsMhpaFzPY0C6tolrQbm+JA800=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gf1btnJqWDowtrwAc1dtxVG+tUsbW6t3CQFjqGJg7XITq0WhWeMEQDi833zWIHutX
         JsRDQsX+bEM8eA/NNZGSSS3Rq/UfsvMCvj/YV9jXWynYStP0L5Ogq55KGMrVFz1Jgz
         /p38FbL2zyvmfwznxF0spn+9fgGt64T+4Au0PmFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 251/267] drbd: Change drbd_request_detach_interruptibles return type to int
Date:   Mon, 16 Dec 2019 18:49:37 +0100
Message-Id: <20191216174916.378746725@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 5816a0932b4fd74257b8cc5785bc8067186a8723 ]

Clang warns when an implicit conversion is done between enumerated
types:

drivers/block/drbd/drbd_state.c:708:8: warning: implicit conversion from
enumeration type 'enum drbd_ret_code' to different enumeration type
'enum drbd_state_rv' [-Wenum-conversion]
                rv = ERR_INTR;
                   ~ ^~~~~~~~

drbd_request_detach_interruptible's only call site is in the return
statement of adm_detach, which returns an int. Change the return type of
drbd_request_detach_interruptible to match, silencing Clang's warning.

Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_state.c | 6 ++----
 drivers/block/drbd/drbd_state.h | 3 +--
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 0813c654c8938..b452359b6aae8 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -688,11 +688,9 @@ request_detach(struct drbd_device *device)
 			CS_VERBOSE | CS_ORDERED | CS_INHIBIT_MD_IO);
 }
 
-enum drbd_state_rv
-drbd_request_detach_interruptible(struct drbd_device *device)
+int drbd_request_detach_interruptible(struct drbd_device *device)
 {
-	enum drbd_state_rv rv;
-	int ret;
+	int ret, rv;
 
 	drbd_suspend_io(device); /* so no-one is stuck in drbd_al_begin_io */
 	wait_event_interruptible(device->state_wait,
diff --git a/drivers/block/drbd/drbd_state.h b/drivers/block/drbd/drbd_state.h
index b2a390ba73a05..f87371e55e682 100644
--- a/drivers/block/drbd/drbd_state.h
+++ b/drivers/block/drbd/drbd_state.h
@@ -162,8 +162,7 @@ static inline int drbd_request_state(struct drbd_device *device,
 }
 
 /* for use in adm_detach() (drbd_adm_detach(), drbd_adm_down()) */
-enum drbd_state_rv
-drbd_request_detach_interruptible(struct drbd_device *device);
+int drbd_request_detach_interruptible(struct drbd_device *device);
 
 enum drbd_role conn_highest_role(struct drbd_connection *connection);
 enum drbd_role conn_highest_peer(struct drbd_connection *connection);
-- 
2.20.1



