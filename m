Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2B04228E9
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235478AbhJENy5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:54:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235506AbhJENxI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:53:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9568461A10;
        Tue,  5 Oct 2021 13:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633441876;
        bh=2i0aVUHfCGPExYqmX35vMDum/QmkD/6Gm1AyXtiIJUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WXF0PmoKYrn+P8MCHOBdlOEsNBiG7aQLM/Ud5AfXYbQLdr1EilSk1QOBGdYhEvHc/
         yVvTDWLTZ5e6RMyXnlGP0xKyNLVDWdccvCQ8HDnCEAom8+DIZsZCFBS2V2utJwXCOt
         bodHWrFGEuMSpaFARvWwa8AXw3gijlQduADy9NU6N3O+mEBIj8MEMjT6vpwtYR/mbY
         vPuHp7rwno10NinzufT2KJ15w47QtUYc2ZD0OfWLNLrzJq0atYFVQNzamhiSa8j7cJ
         8E/tRcJtU4d5PALfWlehQrhxzbbdh8QYU5y933S3bcgSaj6PEeWpHqbGIoa1Cb1Yst
         QzQU/hQaxsaKg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Sven Peter <sven@svenpeter.dev>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Aditya Garg <gargaditya08@live.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, axboe@fb.com,
        Christoph@vger.kernel.org, sagi@grimberg.me,
        linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 29/40] nvme: add command id quirk for apple controllers
Date:   Tue,  5 Oct 2021 09:50:08 -0400
Message-Id: <20211005135020.214291-29-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135020.214291-1-sashal@kernel.org>
References: <20211005135020.214291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit a2941f6aa71a72be2c82c0a168523a492d093530 ]

Some apple controllers use the command id as an index to implementation
specific data structures and will fail if the value is out of bounds.
The nvme driver's recently introduced command sequence number breaks
this controller.

Provide a quirk so these spec incompliant controllers can function as
before. The driver will not have the ability to detect bad completions
when this quirk is used, but we weren't previously checking this anyway.

The quirk bit was selected so that it can readily apply to stable.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=214509
Cc: Sven Peter <sven@svenpeter.dev>
Reported-by: Orlando Chamberlain <redecorating@protonmail.com>
Reported-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Sven Peter <sven@svenpeter.dev>
Link: https://lore.kernel.org/r/20210927154306.387437-1-kbusch@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 4 +++-
 drivers/nvme/host/nvme.h | 6 ++++++
 drivers/nvme/host/pci.c  | 3 ++-
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index e2374319df61..9b6f78eac937 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -980,6 +980,7 @@ EXPORT_SYMBOL_GPL(nvme_cleanup_cmd);
 blk_status_t nvme_setup_cmd(struct nvme_ns *ns, struct request *req)
 {
 	struct nvme_command *cmd = nvme_req(req)->cmd;
+	struct nvme_ctrl *ctrl = nvme_req(req)->ctrl;
 	blk_status_t ret = BLK_STS_OK;
 
 	if (!(req->rq_flags & RQF_DONTPREP)) {
@@ -1028,7 +1029,8 @@ blk_status_t nvme_setup_cmd(struct nvme_ns *ns, struct request *req)
 		return BLK_STS_IOERR;
 	}
 
-	nvme_req(req)->genctr++;
+	if (!(ctrl->quirks & NVME_QUIRK_SKIP_CID_GEN))
+		nvme_req(req)->genctr++;
 	cmd->common.command_id = nvme_cid(req);
 	trace_nvme_setup_cmd(req, cmd);
 	return ret;
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 26511794629b..12393a72662e 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -149,6 +149,12 @@ enum nvme_quirks {
 	 * 48 bits.
 	 */
 	NVME_QUIRK_DMA_ADDRESS_BITS_48		= (1 << 16),
+
+	/*
+	 * The controller requires the command_id value be be limited, so skip
+	 * encoding the generation sequence number.
+	 */
+	NVME_QUIRK_SKIP_CID_GEN			= (1 << 17),
 };
 
 /*
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index c246fdacba2e..4f22fbafe964 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3282,7 +3282,8 @@ static const struct pci_device_id nvme_id_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, 0x2005),
 		.driver_data = NVME_QUIRK_SINGLE_VECTOR |
 				NVME_QUIRK_128_BYTES_SQES |
-				NVME_QUIRK_SHARED_TAGS },
+				NVME_QUIRK_SHARED_TAGS |
+				NVME_QUIRK_SKIP_CID_GEN },
 
 	{ PCI_DEVICE_CLASS(PCI_CLASS_STORAGE_EXPRESS, 0xffffff) },
 	{ 0, }
-- 
2.33.0

