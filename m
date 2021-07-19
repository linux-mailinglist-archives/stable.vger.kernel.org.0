Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E95703CE2CE
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236679AbhGSPcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:32:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347740AbhGSPaN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:30:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78EA061410;
        Mon, 19 Jul 2021 16:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710960;
        bh=9Gmjgaw6CKRktLHYhs42VVmA6blzP+3WCN+a42EApWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GoMjUkGStGVwgSfduDMPGATOFq/93rive6mzMDbY+TOAagIzV8XFA3XcqMFV1EfUL
         TDbi3vZpFcJJqS0B5hzvvRRg+E1A2yK8zdpU2TXCL61axlPsnv4f2d2QOlozId3qGC
         CTd/9zJGNc/gRWItHca6dvkrE0pWzMfrKnK6ukMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 175/351] remoteproc: stm32: fix mbox_send_message call
Date:   Mon, 19 Jul 2021 16:52:01 +0200
Message-Id: <20210719144950.770551853@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>

[ Upstream commit 51c4b4e212269a8634dee2000182cfca7f11575b ]

mbox_send_message is called by passing a local dummy message or
a function parameter. As the message is queued, it is dereferenced.
This works because the message field is not used by the stm32 ipcc
driver, but it is not clean.

Fix by passing a constant string in all cases.

The associated comments are removed because rproc should not have to
deal with the behavior of the mailbox frame.

Reported-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
Link: https://lore.kernel.org/r/20210420091922.29429-1-arnaud.pouliquen@foss.st.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/stm32_rproc.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/remoteproc/stm32_rproc.c b/drivers/remoteproc/stm32_rproc.c
index 7353f9e7e7af..0e8203a432ab 100644
--- a/drivers/remoteproc/stm32_rproc.c
+++ b/drivers/remoteproc/stm32_rproc.c
@@ -474,14 +474,12 @@ static int stm32_rproc_attach(struct rproc *rproc)
 static int stm32_rproc_detach(struct rproc *rproc)
 {
 	struct stm32_rproc *ddata = rproc->priv;
-	int err, dummy_data, idx;
+	int err, idx;
 
 	/* Inform the remote processor of the detach */
 	idx = stm32_rproc_mbox_idx(rproc, STM32_MBX_DETACH);
 	if (idx >= 0 && ddata->mb[idx].chan) {
-		/* A dummy data is sent to allow to block on transmit */
-		err = mbox_send_message(ddata->mb[idx].chan,
-					&dummy_data);
+		err = mbox_send_message(ddata->mb[idx].chan, "stop");
 		if (err < 0)
 			dev_warn(&rproc->dev, "warning: remote FW detach without ack\n");
 	}
@@ -493,15 +491,13 @@ static int stm32_rproc_detach(struct rproc *rproc)
 static int stm32_rproc_stop(struct rproc *rproc)
 {
 	struct stm32_rproc *ddata = rproc->priv;
-	int err, dummy_data, idx;
+	int err, idx;
 
 	/* request shutdown of the remote processor */
 	if (rproc->state != RPROC_OFFLINE) {
 		idx = stm32_rproc_mbox_idx(rproc, STM32_MBX_SHUTDOWN);
 		if (idx >= 0 && ddata->mb[idx].chan) {
-			/* a dummy data is sent to allow to block on transmit */
-			err = mbox_send_message(ddata->mb[idx].chan,
-						&dummy_data);
+			err = mbox_send_message(ddata->mb[idx].chan, "detach");
 			if (err < 0)
 				dev_warn(&rproc->dev, "warning: remote FW shutdown without ack\n");
 		}
@@ -556,7 +552,7 @@ static void stm32_rproc_kick(struct rproc *rproc, int vqid)
 			continue;
 		if (!ddata->mb[i].chan)
 			return;
-		err = mbox_send_message(ddata->mb[i].chan, (void *)(long)vqid);
+		err = mbox_send_message(ddata->mb[i].chan, "kick");
 		if (err < 0)
 			dev_err(&rproc->dev, "%s: failed (%s, err:%d)\n",
 				__func__, ddata->mb[i].name, err);
-- 
2.30.2



