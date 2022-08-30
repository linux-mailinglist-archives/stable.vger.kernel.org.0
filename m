Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76A745A69F2
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbiH3RYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231469AbiH3RYU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:24:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17C86CF79;
        Tue, 30 Aug 2022 10:22:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A4A361798;
        Tue, 30 Aug 2022 17:21:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A2EC43470;
        Tue, 30 Aug 2022 17:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661880105;
        bh=73lWbTdiqKnYoZ9jmUkpJuJBRTOaCYWnNn+0KzdRaHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lmfj1WIO7iP6UubfjT2DxwKBD8LVfaGVFGP3z9K/4/H46BLGW7ZX7JLfWcQ09SEUO
         BXHx67/wMJ4wLOKpXgdNF0KAHwO31mQ/f7t/mfT84duXlQqPr23paxJ0nQx6b4aA+V
         1isSPnAfz3/MkdYZZlnXBHwoH8hRFlIeEngIUHaZWW0JJaX5IwEV7UIBRzUEwBOP3c
         oeZ0eieHR4MxNMJFvnvZdJwR+KDiQRgNwD15yNVrX1ensaQQBwmYHd/l9TBtNgL1Bk
         z/Tgt4AinZpYt+CECfGN9IEEhocJZTlEysLHLDpkDAm9m2bdbdsRjCcU9mClWAS2Hd
         uapZD0nVnYXdQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Battersby <tonyb@cybernetics.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 02/23] scsi: qla2xxx: Disable ATIO interrupt coalesce for quad port ISP27XX
Date:   Tue, 30 Aug 2022 13:21:19 -0400
Message-Id: <20220830172141.581086-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830172141.581086-1-sashal@kernel.org>
References: <20220830172141.581086-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Battersby <tonyb@cybernetics.com>

[ Upstream commit 53661ded2460b414644532de6b99bd87f71987e9 ]

This partially reverts commit d2b292c3f6fd ("scsi: qla2xxx: Enable ATIO
interrupt handshake for ISP27XX")

For some workloads where the host sends a batch of commands and then
pauses, ATIO interrupt coalesce can cause some incoming ATIO entries to be
ignored for extended periods of time, resulting in slow performance,
timeouts, and aborted commands.

Disable interrupt coalesce and re-enable the dedicated ATIO MSI-X
interrupt.

Link: https://lore.kernel.org/r/97dcf365-89ff-014d-a3e5-1404c6af511c@cybernetics.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_target.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 7ab3c9e4d4783..b86f6e1f21b5c 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6961,14 +6961,8 @@ qlt_24xx_config_rings(struct scsi_qla_host *vha)
 
 	if (ha->flags.msix_enabled) {
 		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
-			if (IS_QLA2071(ha)) {
-				/* 4 ports Baker: Enable Interrupt Handshake */
-				icb->msix_atio = 0;
-				icb->firmware_options_2 |= cpu_to_le32(BIT_26);
-			} else {
-				icb->msix_atio = cpu_to_le16(msix->entry);
-				icb->firmware_options_2 &= cpu_to_le32(~BIT_26);
-			}
+			icb->msix_atio = cpu_to_le16(msix->entry);
+			icb->firmware_options_2 &= cpu_to_le32(~BIT_26);
 			ql_dbg(ql_dbg_init, vha, 0xf072,
 			    "Registering ICB vector 0x%x for atio que.\n",
 			    msix->entry);
-- 
2.35.1

