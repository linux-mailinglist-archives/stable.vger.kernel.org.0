Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3035A6964
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiH3RSe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiH3RSd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:18:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A64CD34EC;
        Tue, 30 Aug 2022 10:18:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54CCDB81CD3;
        Tue, 30 Aug 2022 17:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C93C433C1;
        Tue, 30 Aug 2022 17:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661879910;
        bh=LGBCI1tqWJ+ulcALgf4eeEU+udgwAdW2D6addDAKkQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MEzSO/28a85mkleNfmP0PRTc2J0jxOI3zm57m9WfE1C5Y6tcau4SgEUggZ+b2YpQG
         s8MmFWAzYvWb+G72Y0jIQ53mUlj7RGvjAScyJxQnMIc/WOueHYQR9ReDu6GifTDNnd
         f8T3K/tjyV38FFjqK9nzcXx+dhDPFolEVYrZOKtn9PCnORT/VkOCYyaEuFOfhLKtrs
         LBYlZEWfr7cMPBYH4pVVZ705CFNMaOFK7QOfY4s+9vZlZSRr//rpBtWLsmo9AyPjAw
         jqsibO/c6MGN92++0l2+jsJnaRZj24QzHPX2UhzjAWfx8JcoBU/xPbY+qL8jrCxJnH
         lGV4/LYtY73tg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Battersby <tonyb@cybernetics.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 02/33] scsi: qla2xxx: Disable ATIO interrupt coalesce for quad port ISP27XX
Date:   Tue, 30 Aug 2022 13:17:53 -0400
Message-Id: <20220830171825.580603-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830171825.580603-1-sashal@kernel.org>
References: <20220830171825.580603-1-sashal@kernel.org>
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
index 2b2f682883752..62666df1a59eb 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6935,14 +6935,8 @@ qlt_24xx_config_rings(struct scsi_qla_host *vha)
 
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

