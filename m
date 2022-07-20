Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5639B57ACCE
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242109AbiGTBaF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242298AbiGTB3I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:29:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08C4DDC;
        Tue, 19 Jul 2022 18:19:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E750B81DEC;
        Wed, 20 Jul 2022 01:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B93C341CA;
        Wed, 20 Jul 2022 01:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279959;
        bh=sQpz8BDYT2bD6SCBsg8CaXg6DyHzADERq3Ghw6wsybY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EBIpWMZOIhiavikOcy7FcpW+aDLhX2YghrsRAy/Ln9Glboirq1Y0TAuWeGeygbFyb
         7luG1Sb1jLsLZK+inCgyiF/KkGjr2CYZA24dQ8AeFms3TVYPtN1Ydt8mujlqoJ/E9A
         2ibhenHhcM2UaaV+K45UpCA/kxcM/DLWb9jEAcPlxtNQZJzIHrLJ3nlOBufMDVErE8
         Qh1p8qdSBgkSVTbEYjRErbOpfBTkV2j3Egvg9xipGmuMG9Je6xlvldDGZjCrl69Szj
         X8Zm2ARqHvXW/6dVcaRBF5notY3nQv75Ilqvlo88UceskpZXsdcU1cyf3YOufZ6TmK
         wkz8PXVlqT1CQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 5/6] scsi: target: Fix WRITE_SAME No Data Buffer crash
Date:   Tue, 19 Jul 2022 21:18:56 -0400
Message-Id: <20220720011858.1025523-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011858.1025523-1-sashal@kernel.org>
References: <20220720011858.1025523-1-sashal@kernel.org>
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
index 57a3d3936364..ae252b978cf3 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -385,6 +385,9 @@ fd_execute_write_same(struct se_cmd *cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
+	if (!cmd->t_data_nents)
+		return TCM_INVALID_CDB_FIELD;
+
 	if (cmd->t_data_nents > 1 ||
 	    cmd->t_data_sg[0].length != cmd->se_dev->dev_attrib.block_size) {
 		pr_err("WRITE_SAME: Illegal SGL t_data_nents: %u length: %u"
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 372d744315f3..fc85d9fc2c88 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -462,6 +462,10 @@ iblock_execute_write_same(struct se_cmd *cmd)
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
index 6a5a089fd13e..ec1544272fa7 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -352,6 +352,12 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char flags, struct sbc_ops *op
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

