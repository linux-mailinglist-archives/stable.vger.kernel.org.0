Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B944D37C80E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238242AbhELQEZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:04:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235995AbhELP75 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:59:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BC1F61CCB;
        Wed, 12 May 2021 15:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833555;
        bh=Tg//zAH72ySi3/bj3M1eWFuyB7wxIsdTUexY1QxiLZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x/nCvfcj0K80GB2lp61h2KaQQIocY078iWBtvgFBrpA0/USTTmpeVS70H1vrNHlLZ
         EVGQminK5BK8+34Wt8iQ5jXuAPaJcHSLAbhW2UfrAQx7naNyjfhFugeaAAtf44Ottr
         422VKtFhTz7vvrltp2et1nXl18WrHHPaJD8TlBn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 197/601] crypto: ccp - fix command queuing to TEE ring buffer
Date:   Wed, 12 May 2021 16:44:34 +0200
Message-Id: <20210512144834.320192304@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rijo Thomas <Rijo-john.Thomas@amd.com>

[ Upstream commit 00aa6e65aa04e500a11a2c91e92a11c37b9e234d ]

Multiple threads or clients can submit a command to the TEE ring
buffer. This patch helps to synchronize command submission to the
ring.

One thread shall write a command to a TEE ring buffer entry only if:

 - Trusted OS has notified that the TEE command for the given entry
   has been processed and driver has copied the TEE response into
   client buffer.

 - The command entry is empty and can be written into.

After a command has been written to the TEE ring buffer, the global
wptr (mutex protected) shall be incremented for use by next client.

If PSP became unresponsive while processing TEE request from a
client, then further command submission to queue will be disabled.

Fixes: 33960acccfbd (crypto: ccp - add TEE support for Raven Ridge)
Reviewed-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/tee-dev.c | 49 +++++++++++++++++++++++++-----------
 drivers/crypto/ccp/tee-dev.h | 20 +++++++++++++--
 2 files changed, 53 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
index 5e697a90ea7f..bcb81fef4211 100644
--- a/drivers/crypto/ccp/tee-dev.c
+++ b/drivers/crypto/ccp/tee-dev.c
@@ -36,6 +36,7 @@ static int tee_alloc_ring(struct psp_tee_device *tee, int ring_size)
 	if (!start_addr)
 		return -ENOMEM;
 
+	memset(start_addr, 0x0, ring_size);
 	rb_mgr->ring_start = start_addr;
 	rb_mgr->ring_size = ring_size;
 	rb_mgr->ring_pa = __psp_pa(start_addr);
@@ -244,41 +245,54 @@ static int tee_submit_cmd(struct psp_tee_device *tee, enum tee_cmd_id cmd_id,
 			  void *buf, size_t len, struct tee_ring_cmd **resp)
 {
 	struct tee_ring_cmd *cmd;
-	u32 rptr, wptr;
 	int nloop = 1000, ret = 0;
+	u32 rptr;
 
 	*resp = NULL;
 
 	mutex_lock(&tee->rb_mgr.mutex);
 
-	wptr = tee->rb_mgr.wptr;
-
-	/* Check if ring buffer is full */
+	/* Loop until empty entry found in ring buffer */
 	do {
+		/* Get pointer to ring buffer command entry */
+		cmd = (struct tee_ring_cmd *)
+			(tee->rb_mgr.ring_start + tee->rb_mgr.wptr);
+
 		rptr = ioread32(tee->io_regs + tee->vdata->ring_rptr_reg);
 
-		if (!(wptr + sizeof(struct tee_ring_cmd) == rptr))
+		/* Check if ring buffer is full or command entry is waiting
+		 * for response from TEE
+		 */
+		if (!(tee->rb_mgr.wptr + sizeof(struct tee_ring_cmd) == rptr ||
+		      cmd->flag == CMD_WAITING_FOR_RESPONSE))
 			break;
 
-		dev_info(tee->dev, "tee: ring buffer full. rptr = %u wptr = %u\n",
-			 rptr, wptr);
+		dev_dbg(tee->dev, "tee: ring buffer full. rptr = %u wptr = %u\n",
+			rptr, tee->rb_mgr.wptr);
 
-		/* Wait if ring buffer is full */
+		/* Wait if ring buffer is full or TEE is processing data */
 		mutex_unlock(&tee->rb_mgr.mutex);
 		schedule_timeout_interruptible(msecs_to_jiffies(10));
 		mutex_lock(&tee->rb_mgr.mutex);
 
 	} while (--nloop);
 
-	if (!nloop && (wptr + sizeof(struct tee_ring_cmd) == rptr)) {
-		dev_err(tee->dev, "tee: ring buffer full. rptr = %u wptr = %u\n",
-			rptr, wptr);
+	if (!nloop &&
+	    (tee->rb_mgr.wptr + sizeof(struct tee_ring_cmd) == rptr ||
+	     cmd->flag == CMD_WAITING_FOR_RESPONSE)) {
+		dev_err(tee->dev, "tee: ring buffer full. rptr = %u wptr = %u response flag %u\n",
+			rptr, tee->rb_mgr.wptr, cmd->flag);
 		ret = -EBUSY;
 		goto unlock;
 	}
 
-	/* Pointer to empty data entry in ring buffer */
-	cmd = (struct tee_ring_cmd *)(tee->rb_mgr.ring_start + wptr);
+	/* Do not submit command if PSP got disabled while processing any
+	 * command in another thread
+	 */
+	if (psp_dead) {
+		ret = -EBUSY;
+		goto unlock;
+	}
 
 	/* Write command data into ring buffer */
 	cmd->cmd_id = cmd_id;
@@ -286,6 +300,9 @@ static int tee_submit_cmd(struct psp_tee_device *tee, enum tee_cmd_id cmd_id,
 	memset(&cmd->buf[0], 0, sizeof(cmd->buf));
 	memcpy(&cmd->buf[0], buf, len);
 
+	/* Indicate driver is waiting for response */
+	cmd->flag = CMD_WAITING_FOR_RESPONSE;
+
 	/* Update local copy of write pointer */
 	tee->rb_mgr.wptr += sizeof(struct tee_ring_cmd);
 	if (tee->rb_mgr.wptr >= tee->rb_mgr.ring_size)
@@ -353,12 +370,16 @@ int psp_tee_process_cmd(enum tee_cmd_id cmd_id, void *buf, size_t len,
 		return ret;
 
 	ret = tee_wait_cmd_completion(tee, resp, TEE_DEFAULT_TIMEOUT);
-	if (ret)
+	if (ret) {
+		resp->flag = CMD_RESPONSE_TIMEDOUT;
 		return ret;
+	}
 
 	memcpy(buf, &resp->buf[0], len);
 	*status = resp->status;
 
+	resp->flag = CMD_RESPONSE_COPIED;
+
 	return 0;
 }
 EXPORT_SYMBOL(psp_tee_process_cmd);
diff --git a/drivers/crypto/ccp/tee-dev.h b/drivers/crypto/ccp/tee-dev.h
index f09960112115..49d26158b71e 100644
--- a/drivers/crypto/ccp/tee-dev.h
+++ b/drivers/crypto/ccp/tee-dev.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: MIT */
 /*
- * Copyright 2019 Advanced Micro Devices, Inc.
+ * Copyright (C) 2019,2021 Advanced Micro Devices, Inc.
  *
  * Author: Rijo Thomas <Rijo-john.Thomas@amd.com>
  * Author: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
@@ -18,7 +18,7 @@
 #include <linux/mutex.h>
 
 #define TEE_DEFAULT_TIMEOUT		10
-#define MAX_BUFFER_SIZE			992
+#define MAX_BUFFER_SIZE			988
 
 /**
  * enum tee_ring_cmd_id - TEE interface commands for ring buffer configuration
@@ -81,6 +81,20 @@ enum tee_cmd_state {
 	TEE_CMD_STATE_COMPLETED,
 };
 
+/**
+ * enum cmd_resp_state - TEE command's response status maintained by driver
+ * @CMD_RESPONSE_INVALID:      initial state when no command is written to ring
+ * @CMD_WAITING_FOR_RESPONSE:  driver waiting for response from TEE
+ * @CMD_RESPONSE_TIMEDOUT:     failed to get response from TEE
+ * @CMD_RESPONSE_COPIED:       driver has copied response from TEE
+ */
+enum cmd_resp_state {
+	CMD_RESPONSE_INVALID,
+	CMD_WAITING_FOR_RESPONSE,
+	CMD_RESPONSE_TIMEDOUT,
+	CMD_RESPONSE_COPIED,
+};
+
 /**
  * struct tee_ring_cmd - Structure of the command buffer in TEE ring
  * @cmd_id:      refers to &enum tee_cmd_id. Command id for the ring buffer
@@ -91,6 +105,7 @@ enum tee_cmd_state {
  * @pdata:       private data (currently unused)
  * @res1:        reserved region
  * @buf:         TEE command specific buffer
+ * @flag:	 refers to &enum cmd_resp_state
  */
 struct tee_ring_cmd {
 	u32 cmd_id;
@@ -100,6 +115,7 @@ struct tee_ring_cmd {
 	u64 pdata;
 	u32 res1[2];
 	u8 buf[MAX_BUFFER_SIZE];
+	u32 flag;
 
 	/* Total size: 1024 bytes */
 } __packed;
-- 
2.30.2



