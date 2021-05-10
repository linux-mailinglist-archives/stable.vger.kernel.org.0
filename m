Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74487378628
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbhEJLEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:04:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234978AbhEJK5U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:57:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA364619D1;
        Mon, 10 May 2021 10:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643844;
        bh=Q/cYoiRK1U2NiiuwLVD/uZ7NVncO9dV/pNS5t0rS25E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eiKYASrLpq0Q+4ErefCGCGLsQ3A5jCmDKX+8yIt2025you9g2lZnXwR2wcvAKktWc
         SMqDuwX8jjhRpkoLnyQEwkTgWQlFDb6as8wVx83dPoY0V8efEAd1isIVWAB12OdYyA
         R+khNhNdRP7VyzkT5gYZ8immGyAQMtuJnm31T4Dk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Pu <houpu.main@gmail.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 183/342] nvmet: return proper error code from discovery ctrl
Date:   Mon, 10 May 2021 12:19:33 +0200
Message-Id: <20210510102016.138715702@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
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



