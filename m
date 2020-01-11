Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9650E13801F
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729245AbgAKK0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:26:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:58546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729047AbgAKK0P (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:26:15 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A5FB2082E;
        Sat, 11 Jan 2020 10:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738375;
        bh=dkNy826DC2l0wBjP/1QqqtSStFbYBWhyqa/0i34FXI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jFHq/dFI4w+VhB/AtSI7uKs/mDWTAbFuwLWYoj9n3m0jIvEoV0fyf2lTq2rNUtLya
         oLm9QtQ85Y14SxCIBw2XAcuBL4s7qKjjC2zjRCmHxvIm0pTtxVyQkpuereW0YmayVi
         oTARDXBsDeqkSVPjGkhUCR5XspfbUFbFYm9DAcC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oded Gabbay <oded.gabbay@gmail.com>,
        Tomer Tayar <ttayar@habana.ai>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 081/165] habanalabs: rate limit error msg on waiting for CS
Date:   Sat, 11 Jan 2020 10:50:00 +0100
Message-Id: <20200111094927.954065460@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oded Gabbay <oded.gabbay@gmail.com>

[ Upstream commit 018e0e3594f7dcd029d258e368c485e742fa9cdb ]

In case a user submits a CS, and the submission fails, and the user doesn't
check the return value and instead use the error return value as a valid
sequence number of a CS and ask to wait on it, the driver will print an
error and return an error code for that wait.

The real problem happens if now the user ignores the error of the wait, and
try to wait again and again. This can lead to a flood of error messages
from the driver and even soft lockup event.

Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
Reviewed-by: Tomer Tayar <ttayar@habana.ai>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/command_submission.c | 5 +++--
 drivers/misc/habanalabs/context.c            | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/habanalabs/command_submission.c b/drivers/misc/habanalabs/command_submission.c
index a9ac045dcfde..447f307ef4d6 100644
--- a/drivers/misc/habanalabs/command_submission.c
+++ b/drivers/misc/habanalabs/command_submission.c
@@ -777,8 +777,9 @@ int hl_cs_wait_ioctl(struct hl_fpriv *hpriv, void *data)
 	memset(args, 0, sizeof(*args));
 
 	if (rc < 0) {
-		dev_err(hdev->dev, "Error %ld on waiting for CS handle %llu\n",
-			rc, seq);
+		dev_err_ratelimited(hdev->dev,
+				"Error %ld on waiting for CS handle %llu\n",
+				rc, seq);
 		if (rc == -ERESTARTSYS) {
 			args->out.status = HL_WAIT_CS_STATUS_INTERRUPTED;
 			rc = -EINTR;
diff --git a/drivers/misc/habanalabs/context.c b/drivers/misc/habanalabs/context.c
index 17db7b3dfb4c..2df6fb87e7ff 100644
--- a/drivers/misc/habanalabs/context.c
+++ b/drivers/misc/habanalabs/context.c
@@ -176,7 +176,7 @@ struct dma_fence *hl_ctx_get_fence(struct hl_ctx *ctx, u64 seq)
 	spin_lock(&ctx->cs_lock);
 
 	if (seq >= ctx->cs_sequence) {
-		dev_notice(hdev->dev,
+		dev_notice_ratelimited(hdev->dev,
 			"Can't wait on seq %llu because current CS is at seq %llu\n",
 			seq, ctx->cs_sequence);
 		spin_unlock(&ctx->cs_lock);
-- 
2.20.1



