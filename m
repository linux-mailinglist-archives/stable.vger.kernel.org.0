Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51779ACD4B
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729900AbfIHMrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:47:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:36130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730756AbfIHMri (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:47:38 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F132218AF;
        Sun,  8 Sep 2019 12:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946857;
        bh=VQW4JxtBSA8uCuI6Kk12pcVkUqkLC1Wx3tvKKIQOyxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q1JGD/E+234v8Lhkb6+/ZYPBoVHJoLoqHg66zRanilKQPuFNV7sKEgh3z/HbR51Pq
         l31jf6TmwHt7RKZZiHOwY0L0LMHgXlUBwk3xCPfKCn2ImqOjaKD15RkmyiT3Vp0SRi
         PXzT8oA5Ic+w7WlYE0JGNz6yQs2knOP4x5sQxwu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        Mike Christie <mchristi@redhat.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 26/57] scsi: target: tcmu: avoid use-after-free after command timeout
Date:   Sun,  8 Sep 2019 13:41:50 +0100
Message-Id: <20190908121136.330463012@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121125.608195329@linuxfoundation.org>
References: <20190908121125.608195329@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index c46efa47d68a5..7159e8363b83b 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1143,14 +1143,16 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
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
 
@@ -1163,6 +1165,7 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 		goto done;
 	}
 
+	read_len = se_cmd->data_length;
 	if (se_cmd->data_direction == DMA_FROM_DEVICE &&
 	    (entry->hdr.uflags & TCMU_UFLAG_READ_LEN) && entry->rsp.read_len) {
 		read_len_valid = true;
@@ -1318,6 +1321,7 @@ static int tcmu_check_expired_cmd(int id, void *p, void *data)
 		 */
 		scsi_status = SAM_STAT_CHECK_CONDITION;
 		list_del_init(&cmd->queue_entry);
+		cmd->se_cmd = NULL;
 	} else {
 		list_del_init(&cmd->queue_entry);
 		idr_remove(&udev->commands, id);
@@ -2036,6 +2040,7 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
 
 		idr_remove(&udev->commands, i);
 		if (!test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags)) {
+			WARN_ON(!cmd->se_cmd);
 			list_del_init(&cmd->queue_entry);
 			if (err_level == 1) {
 				/*
-- 
2.20.1



