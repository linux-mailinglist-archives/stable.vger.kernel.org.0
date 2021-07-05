Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDC83BC002
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbhGEPeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:34:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232513AbhGEPdV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:33:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 961E8619C3;
        Mon,  5 Jul 2021 15:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499034;
        bh=cAeuC7oI2K6Da1Me3x4gMryj6x09fXna4zQuwwynkWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hdsqALyiONG8klZ4qP2PnyK9rP/71T649k1WQMr6gTEQSw0Xmc4IbYS92i1rgPlto
         GVfWKc7MPWPsT7G3tpPMqYNARt1tf4N6irKOf6gcb+Nh2msucrmZ7ecRt9HG0HmcVN
         YyExlxMFjGPbmlHcv6+z157TL6MtDh/Piujh2Ux9cfG/+GLSZG8pszJSys4BF9AJ3G
         a3y7HRIBOiOWSlBXofB1n4wIs7BVqdrxp9Xrfrpmy3W3lhHWBmXf4eSsu+q2c2VmSe
         Ei+A27Y+lNoSqUGTJAF1u3Zd/tX1sdMgrtu7qgZLi7m7wPhDsE//VN/zSUN7sx/IXL
         eu1fXpHtsEUtQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>, James Smart <jsmart2021@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 26/41] nvmet-fc: do not check for invalid target port in nvmet_fc_handle_fcp_rqst()
Date:   Mon,  5 Jul 2021 11:29:46 -0400
Message-Id: <20210705153001.1521447-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153001.1521447-1-sashal@kernel.org>
References: <20210705153001.1521447-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 2a4a910aa4f0acc428dc8d10227c42e14ed21d10 ]

When parsing a request in nvmet_fc_handle_fcp_rqst() we should not
check for invalid target ports; if we do the command is aborted
from the fcp layer, causing the host to assume a transport error.
Rather we should still forward this request to the nvmet layer, which
will then correctly fail the command with an appropriate error status.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fc.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index cd4e73aa9807..640031cbda7c 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -2499,13 +2499,6 @@ nvmet_fc_handle_fcp_rqst(struct nvmet_fc_tgtport *tgtport,
 	u32 xfrlen = be32_to_cpu(cmdiu->data_len);
 	int ret;
 
-	/*
-	 * if there is no nvmet mapping to the targetport there
-	 * shouldn't be requests. just terminate them.
-	 */
-	if (!tgtport->pe)
-		goto transport_error;
-
 	/*
 	 * Fused commands are currently not supported in the linux
 	 * implementation.
@@ -2533,7 +2526,8 @@ nvmet_fc_handle_fcp_rqst(struct nvmet_fc_tgtport *tgtport,
 
 	fod->req.cmd = &fod->cmdiubuf.sqe;
 	fod->req.cqe = &fod->rspiubuf.cqe;
-	fod->req.port = tgtport->pe->port;
+	if (tgtport->pe)
+		fod->req.port = tgtport->pe->port;
 
 	/* clear any response payload */
 	memset(&fod->rspiubuf, 0, sizeof(fod->rspiubuf));
-- 
2.30.2

