Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF92B378847
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239123AbhEJLVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:21:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:44218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236806AbhEJLK3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:10:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5775A6147F;
        Mon, 10 May 2021 11:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644738;
        bh=Q/cYoiRK1U2NiiuwLVD/uZ7NVncO9dV/pNS5t0rS25E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CNrjugJrXsMyBNBkoi5W3+KvCsaN5gSBJazfOit+HXpYr26iKMBuOZ77T4EiT5vNU
         TJL/gyJhG5vQ+EnpoLLD57mEYHZKCqhq4uuT7hwJ0+PEIf5s1ivqTE96HD6Vy3mjzI
         TQrJp+IyLWWPwIkpQS/0z14eAFdsf2hSTdeAfSRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Pu <houpu.main@gmail.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 205/384] nvmet: return proper error code from discovery ctrl
Date:   Mon, 10 May 2021 12:19:54 +0200
Message-Id: <20210510102021.641472556@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Pu <houpu.main@gmail.com>

[ Upstream commit 79695dcd9ad4463a82def7f42960e6d7baa76f0b ]

Return NVME_SC_INVALID_FIELD from discovery controller like normal
controller when executing identify or get log page command.

Signed-off-by: Hou Pu <houpu.main@gmail.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/discovery.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/discovery.c b/drivers/nvme/target/discovery.c
index 682854e0e079..4845d12e374a 100644
--- a/drivers/nvme/target/discovery.c
+++ b/drivers/nvme/target/discovery.c
@@ -178,12 +178,14 @@ static void nvmet_execute_disc_get_log_page(struct nvmet_req *req)
 	if (req->cmd->get_log_page.lid != NVME_LOG_DISC) {
 		req->error_loc =
 			offsetof(struct nvme_get_log_page_command, lid);
-		status = NVME_SC_INVALID_OPCODE | NVME_SC_DNR;
+		status = NVME_SC_INVALID_FIELD | NVME_SC_DNR;
 		goto out;
 	}
 
 	/* Spec requires dword aligned offsets */
 	if (offset & 0x3) {
+		req->error_loc =
+			offsetof(struct nvme_get_log_page_command, lpo);
 		status = NVME_SC_INVALID_FIELD | NVME_SC_DNR;
 		goto out;
 	}
@@ -250,7 +252,7 @@ static void nvmet_execute_disc_identify(struct nvmet_req *req)
 
 	if (req->cmd->identify.cns != NVME_ID_CNS_CTRL) {
 		req->error_loc = offsetof(struct nvme_identify, cns);
-		status = NVME_SC_INVALID_OPCODE | NVME_SC_DNR;
+		status = NVME_SC_INVALID_FIELD | NVME_SC_DNR;
 		goto out;
 	}
 
-- 
2.30.2



