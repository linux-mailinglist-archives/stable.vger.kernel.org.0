Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 469D657ACD1
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242204AbiGTB2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242198AbiGTB1o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:27:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329DC67CB0;
        Tue, 19 Jul 2022 18:18:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5FFCECE1E85;
        Wed, 20 Jul 2022 01:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6C2C341D0;
        Wed, 20 Jul 2022 01:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279914;
        bh=6wb/MlVfI6SKjTbpRAzndMk2/Pd/MfW2cahP+ld3YDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RsIO29duquUpbmEjB/469k/o7+F9DSswetu4NyBfvnvSitn6t2KpUjBVW1DrBga1E
         EKvGadEywFWtNcqEU4gtajAYEt7LBdkiCj2spqg9IKvkA7vZuDZMe9J0U9LXmRiGId
         Cc0ZiueDHfvvT0jkm91OXb6W7+yZ5Elf7eGNn0D2EBQ79CNMimgPrA5uWUhSWY+6lz
         WVZ9yc/E9RI6Y7GM8qRgdSqNhORDCmUyXRz2iqXnVSQ6S4IibPDJL+acjD7hQ8/nXQ
         /Tfmig1blHBbymu19x9tBkpeMBYMob25O4Pz5c0JzehK2zKjGv7rtQww7tdZccN4jb
         PPXdvG9Fkf7hw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 7/8] scsi: target: Fix WRITE_SAME No Data Buffer crash
Date:   Tue, 19 Jul 2022 21:18:09 -0400
Message-Id: <20220720011810.1025308-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011810.1025308-1-sashal@kernel.org>
References: <20220720011810.1025308-1-sashal@kernel.org>
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
index 16751ae55d7b..98487116d15e 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -468,6 +468,9 @@ fd_execute_write_same(struct se_cmd *cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
+	if (!cmd->t_data_nents)
+		return TCM_INVALID_CDB_FIELD;
+
 	if (cmd->t_data_nents > 1 ||
 	    cmd->t_data_sg[0].length != cmd->se_dev->dev_attrib.block_size) {
 		pr_err("WRITE_SAME: Illegal SGL t_data_nents: %u length: %u"
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 5668d02de10b..1f02817135e3 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -471,6 +471,10 @@ iblock_execute_write_same(struct se_cmd *cmd)
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
index af9b038da3ba..64e4daa1a507 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -325,6 +325,12 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char flags, struct sbc_ops *op
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

