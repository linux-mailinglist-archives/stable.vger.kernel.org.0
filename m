Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E19257ABF6
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241106AbiGTBPq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241078AbiGTBPX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:15:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845176172F;
        Tue, 19 Jul 2022 18:13:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0143461772;
        Wed, 20 Jul 2022 01:13:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC7AC341CA;
        Wed, 20 Jul 2022 01:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279607;
        bh=WWaHRw3CvVJmFss32L96g2HcEgu5nZjX7bUIcQU2Z4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qg4LfvTPJJItHSBQV1nSOsL5Qyg5zZZPKFa9oj1RbeHdyL3tAkyC4jmnZRyKtXv0T
         JdXbDKBKEc3wseUsTJiaOuSr9ET7xZCzzwej/0ftBcqLVaW9sRPQejXp3c6BSG6Wwk
         KpgCPLsYqadT15i7OGe8GrDYujFIGz3Rj4CByhoEQthr6TPZmd06RVpHbj4cosDPro
         wPZoTG1OJ7okllLI8HTIPJtoP2s2954W9OmFFomaiX7903dgICKKYpIX5LJH5pfZ8a
         yoJU5xUmWaGT+uKARLDAL7Y+jPCxAYA4JdsJg41m44uydiAa0zTFGJrn7hip5v9+cQ
         tQpvyO1iLwJIA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 45/54] scsi: target: Fix WRITE_SAME No Data Buffer crash
Date:   Tue, 19 Jul 2022 21:10:22 -0400
Message-Id: <20220720011031.1023305-45-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011031.1023305-1-sashal@kernel.org>
References: <20220720011031.1023305-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit ccd3f449052449a917a3e577d8ba0368f43b8f29 ]

In newer version of the SBC specs, we have a NDOB bit that indicates there
is no data buffer that gets written out. If this bit is set using commands
like "sg_write_same --ndob" we will crash in target_core_iblock/file's
execute_write_same handlers when we go to access the se_cmd->t_data_sg
because its NULL.

This patch adds a check for the NDOB bit in the common WRITE SAME code
because we don't support it. And, it adds a check for zero SG elements in
each handler in case the initiator tries to send a normal WRITE SAME with
no data buffer.

Link: https://lore.kernel.org/r/20220628022325.14627-2-michael.christie@oracle.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_file.c   | 3 +++
 drivers/target/target_core_iblock.c | 4 ++++
 drivers/target/target_core_sbc.c    | 6 ++++++
 3 files changed, 13 insertions(+)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 8190b840065f..56b9bfaf769a 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -448,6 +448,9 @@ fd_execute_write_same(struct se_cmd *cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
+	if (!cmd->t_data_nents)
+		return TCM_INVALID_CDB_FIELD;
+
 	if (cmd->t_data_nents > 1 ||
 	    cmd->t_data_sg[0].length != cmd->se_dev->dev_attrib.block_size) {
 		pr_err("WRITE_SAME: Illegal SGL t_data_nents: %u length: %u"
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 87ede165ddba..9e678ff32b60 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -494,6 +494,10 @@ iblock_execute_write_same(struct se_cmd *cmd)
 		       " backends not supported\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
+
+	if (!cmd->t_data_nents)
+		return TCM_INVALID_CDB_FIELD;
+
 	sg = &cmd->t_data_sg[0];
 
 	if (cmd->t_data_nents > 1 ||
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index ca1b2312d6e7..f6132836eb38 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -312,6 +312,12 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char flags, struct sbc_ops *op
 		pr_warn("WRITE SAME with ANCHOR not supported\n");
 		return TCM_INVALID_CDB_FIELD;
 	}
+
+	if (flags & 0x01) {
+		pr_warn("WRITE SAME with NDOB not supported\n");
+		return TCM_INVALID_CDB_FIELD;
+	}
+
 	/*
 	 * Special case for WRITE_SAME w/ UNMAP=1 that ends up getting
 	 * translated into block discard requests within backend code.
-- 
2.35.1

