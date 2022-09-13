Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E70E85B7241
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbiIMOpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234644AbiIMOoJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:44:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902826F250;
        Tue, 13 Sep 2022 07:23:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64D3D614B8;
        Tue, 13 Sep 2022 14:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E93C433D6;
        Tue, 13 Sep 2022 14:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078916;
        bh=eDajPw9Ie1LQQuiHq/lytkZaVPZCbjL0hqdGqGCO2kQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Sg3jcYrlcmIm28vs1uzav+AOTWPVrq5Sd8yFIRfkyFsuqTAHvBmVx2ebhMb1Uosf
         IVY+z0TQHY29ntHcChrrj9GuCXig9195jz6nQo1c1Bil2GVESDepC/HUvRu6WOQObZ
         fstnwCCfjd7cla++yqoLPQkOo80+tY7jNNoF3mXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Tony Battersby <tonyb@cybernetics.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 11/79] scsi: qla2xxx: Disable ATIO interrupt coalesce for quad port ISP27XX
Date:   Tue, 13 Sep 2022 16:04:16 +0200
Message-Id: <20220913140350.843918022@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140350.291927556@linuxfoundation.org>
References: <20220913140350.291927556@linuxfoundation.org>
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
index ba823e8eb902b..ecb30c2738b8b 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6817,14 +6817,8 @@ qlt_24xx_config_rings(struct scsi_qla_host *vha)
 
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



