Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F27F5B6F4B
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbiIMOKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232586AbiIMOJE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:09:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2759E5B7B2;
        Tue, 13 Sep 2022 07:08:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3E7D61497;
        Tue, 13 Sep 2022 14:08:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA9FC433D7;
        Tue, 13 Sep 2022 14:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078118;
        bh=LGBCI1tqWJ+ulcALgf4eeEU+udgwAdW2D6addDAKkQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L+3cf5friLus09NkSWr3zM87S8F8LJ3Px2k7AQVKvXIXJP4M/7klLMZMRgN/+wp1I
         9KwAYFqZaIA2Y/HFXIyx6KtOsKakF6wObTsnPmxo7MwbMD2SYcITnz3c34W8HIT3Vi
         RUZV31/zgoRPMV0Hp710qQ1H/wf1rr7HNAp4RD6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Tony Battersby <tonyb@cybernetics.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 009/192] scsi: qla2xxx: Disable ATIO interrupt coalesce for quad port ISP27XX
Date:   Tue, 13 Sep 2022 16:01:55 +0200
Message-Id: <20220913140410.444443406@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



