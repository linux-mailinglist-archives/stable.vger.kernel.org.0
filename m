Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC661FE8CF
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbgFRBIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:08:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:34456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727843AbgFRBIh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:08:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9077D21BE5;
        Thu, 18 Jun 2020 01:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442516;
        bh=URqU8zLKGIUTvKeRvr6CXtgyoVs4U2bOE2L+VODufmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xrcW5FKLzI00tmKTU9c93je3rnfIvK9kV/G5MOc/n/fNpmXODD2PAayrg8PRf/RuD
         jOZzkzZkRaPiKQTiDtJsFRPrLacFkOfb98VaiylzqI7/mezd6w33GrVVpzb6nVhskn
         9tdJV6iTgCZTubZHjRhnrcpsTTsaKJ35dTqUvGMw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Daniel Wagner <dwagner@suse.de>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 022/388] scsi: core: free sgtables in case command setup fails
Date:   Wed, 17 Jun 2020 21:01:59 -0400
Message-Id: <20200618010805.600873-22-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit 20a66f2bf280277ab5bb22e27445153b4eb0ac88 ]

In case scsi_setup_fs_cmnd() fails we're not freeing the sgtables allocated
by scsi_init_io(), thus we leak the allocated memory.

Free the sgtables allocated by scsi_init_io() in case scsi_setup_fs_cmnd()
fails.

Technically scsi_setup_scsi_cmnd() does not suffer from this problem as it
can only fail if scsi_init_io() fails, so it does not have sgtables
allocated. But to maintain symmetry and as a measure of defensive
programming, free the sgtables on scsi_setup_scsi_cmnd() failure as well.
scsi_mq_free_sgtables() has safeguards against double-freeing of memory so
this is safe to do.

While we're at it, rename scsi_mq_free_sgtables() to scsi_free_sgtables().

Link: https://bugzilla.kernel.org/show_bug.cgi?id=205595
Link: https://lore.kernel.org/r/20200428104605.8143-2-johannes.thumshirn@wdc.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_lib.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 06c260f6cdae..3ecdae18597d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -548,7 +548,7 @@ static void scsi_uninit_cmd(struct scsi_cmnd *cmd)
 	}
 }
 
-static void scsi_mq_free_sgtables(struct scsi_cmnd *cmd)
+static void scsi_free_sgtables(struct scsi_cmnd *cmd)
 {
 	if (cmd->sdb.table.nents)
 		sg_free_table_chained(&cmd->sdb.table,
@@ -560,7 +560,7 @@ static void scsi_mq_free_sgtables(struct scsi_cmnd *cmd)
 
 static void scsi_mq_uninit_cmd(struct scsi_cmnd *cmd)
 {
-	scsi_mq_free_sgtables(cmd);
+	scsi_free_sgtables(cmd);
 	scsi_uninit_cmd(cmd);
 }
 
@@ -1059,7 +1059,7 @@ blk_status_t scsi_init_io(struct scsi_cmnd *cmd)
 
 	return BLK_STS_OK;
 out_free_sgtables:
-	scsi_mq_free_sgtables(cmd);
+	scsi_free_sgtables(cmd);
 	return ret;
 }
 EXPORT_SYMBOL(scsi_init_io);
@@ -1190,6 +1190,7 @@ static blk_status_t scsi_setup_cmnd(struct scsi_device *sdev,
 		struct request *req)
 {
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
+	blk_status_t ret;
 
 	if (!blk_rq_bytes(req))
 		cmd->sc_data_direction = DMA_NONE;
@@ -1199,9 +1200,14 @@ static blk_status_t scsi_setup_cmnd(struct scsi_device *sdev,
 		cmd->sc_data_direction = DMA_FROM_DEVICE;
 
 	if (blk_rq_is_scsi(req))
-		return scsi_setup_scsi_cmnd(sdev, req);
+		ret = scsi_setup_scsi_cmnd(sdev, req);
 	else
-		return scsi_setup_fs_cmnd(sdev, req);
+		ret = scsi_setup_fs_cmnd(sdev, req);
+
+	if (ret != BLK_STS_OK)
+		scsi_free_sgtables(cmd);
+
+	return ret;
 }
 
 static blk_status_t
-- 
2.25.1

