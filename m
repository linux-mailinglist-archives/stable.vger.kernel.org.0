Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36385A2340
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbfH2SOZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:14:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:55770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728708AbfH2SOD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:14:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 923D5233FF;
        Thu, 29 Aug 2019 18:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102442;
        bh=ELasd/krHemGHvL2GqE3FAxmL4MQO+r/h4KTacutGvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aB+Pt/XeB4nI2bXDn6jo67aYqMKUtctORiEnxL2vZa4FPHHE5uOyQdwfjVwKFNiAC
         v+zwZ+r5mPpub6Op7+EgJ8FTcTcTLP62QfBA/v6c/Xzg+E2nJkTM4A5V/ThDamb795
         ribWY5x0sfOwfiWIV7BykjMidoipv0yY0SyVTKgY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        Mike Christie <mchristi@redhat.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 30/76] scsi: target: tcmu: avoid use-after-free after command timeout
Date:   Thu, 29 Aug 2019 14:12:25 -0400
Message-Id: <20190829181311.7562-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181311.7562-1-sashal@kernel.org>
References: <20190829181311.7562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Fomichev <dmitry.fomichev@wdc.com>

[ Upstream commit a86a75865ff4d8c05f355d1750a5250aec89ab15 ]

In tcmu_handle_completion() function, the variable called read_len is
always initialized with a value taken from se_cmd structure. If this
function is called to complete an expired (timed out) out command, the
session command pointed by se_cmd is likely to be already deallocated by
the target core at that moment. As the result, this access triggers a
use-after-free warning from KASAN.

This patch fixes the code not to touch se_cmd when completing timed out
TCMU commands. It also resets the pointer to se_cmd at the time when the
TCMU_CMD_BIT_EXPIRED flag is set because it is going to become invalid
after calling target_complete_cmd() later in the same function,
tcmu_check_expired_cmd().

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Acked-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_user.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index b43d6385a1a09..95b2371fb67b6 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1132,14 +1132,16 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 	struct se_cmd *se_cmd = cmd->se_cmd;
 	struct tcmu_dev *udev = cmd->tcmu_dev;
 	bool read_len_valid = false;
-	uint32_t read_len = se_cmd->data_length;
+	uint32_t read_len;
 
 	/*
 	 * cmd has been completed already from timeout, just reclaim
 	 * data area space and free cmd
 	 */
-	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags))
+	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags)) {
+		WARN_ON_ONCE(se_cmd);
 		goto out;
+	}
 
 	list_del_init(&cmd->queue_entry);
 
@@ -1152,6 +1154,7 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 		goto done;
 	}
 
+	read_len = se_cmd->data_length;
 	if (se_cmd->data_direction == DMA_FROM_DEVICE &&
 	    (entry->hdr.uflags & TCMU_UFLAG_READ_LEN) && entry->rsp.read_len) {
 		read_len_valid = true;
@@ -1307,6 +1310,7 @@ static int tcmu_check_expired_cmd(int id, void *p, void *data)
 		 */
 		scsi_status = SAM_STAT_CHECK_CONDITION;
 		list_del_init(&cmd->queue_entry);
+		cmd->se_cmd = NULL;
 	} else {
 		list_del_init(&cmd->queue_entry);
 		idr_remove(&udev->commands, id);
@@ -2024,6 +2028,7 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
 
 		idr_remove(&udev->commands, i);
 		if (!test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags)) {
+			WARN_ON(!cmd->se_cmd);
 			list_del_init(&cmd->queue_entry);
 			if (err_level == 1) {
 				/*
-- 
2.20.1

