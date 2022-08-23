Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD53D59DE80
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357711AbiHWLiI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358218AbiHWLhM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:37:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA8BC9275;
        Tue, 23 Aug 2022 02:28:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 439BD61174;
        Tue, 23 Aug 2022 09:28:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6B9C433C1;
        Tue, 23 Aug 2022 09:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246883;
        bh=pQ/YAxx82IxXZJaC+oKXN/2jjUS2Y+qfcqwQwTxngg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DH2qtrp8gsiE1QDIcWr7PzUEi8+RqPlrhKbKt1ASHqTt5Zee1wlN9VGYN4v/MhlFF
         KSjWLb9xfTu5UnaMKWnay1JZe40NOhkWgTF6R1UjUzAOOtLNwOcCCyrRh0pb0QpdW6
         h8szh55rSDfwK622LSzJnV2NqCt1eMg+2t0PL9Tg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 250/389] scsi: qla2xxx: Turn off multi-queue for 8G adapters
Date:   Tue, 23 Aug 2022 10:25:28 +0200
Message-Id: <20220823080126.024862097@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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

From: Quinn Tran <qutran@marvell.com>

commit 5304673bdb1635e27555bd636fd5d6956f1cd552 upstream.

For 8G adapters, multi-queue was enabled accidentally. Make sure
multi-queue is not enabled.

Link: https://lore.kernel.org/r/20220616053508.27186-5-njavali@marvell.com
Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_def.h |    4 ++--
 drivers/scsi/qla2xxx/qla_isr.c |   16 ++++++----------
 2 files changed, 8 insertions(+), 12 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3899,8 +3899,8 @@ struct qla_hw_data {
 #define IS_OEM_001(ha)          ((ha)->device_type & DT_OEM_001)
 #define HAS_EXTENDED_IDS(ha)    ((ha)->device_type & DT_EXTENDED_IDS)
 #define IS_CT6_SUPPORTED(ha)	((ha)->device_type & DT_CT6_SUPPORTED)
-#define IS_MQUE_CAPABLE(ha)	((ha)->mqenable || IS_QLA83XX(ha) || \
-				IS_QLA27XX(ha) || IS_QLA28XX(ha))
+#define IS_MQUE_CAPABLE(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha) || \
+				 IS_QLA28XX(ha))
 #define IS_BIDI_CAPABLE(ha) \
     (IS_QLA25XX(ha) || IS_QLA2031(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
 /* Bit 21 of fw_attributes decides the MCTP capabilities */
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3568,16 +3568,12 @@ msix_register_fail:
 	}
 
 	/* Enable MSI-X vector for response queue update for queue 0 */
-	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
-		if (ha->msixbase && ha->mqiobase &&
-		    (ha->max_rsp_queues > 1 || ha->max_req_queues > 1 ||
-		     ql2xmqsupport))
-			ha->mqenable = 1;
-	} else
-		if (ha->mqiobase &&
-		    (ha->max_rsp_queues > 1 || ha->max_req_queues > 1 ||
-		     ql2xmqsupport))
-			ha->mqenable = 1;
+	if (IS_MQUE_CAPABLE(ha) &&
+	    (ha->msixbase && ha->mqiobase && ha->max_qpairs))
+		ha->mqenable = 1;
+	else
+		ha->mqenable = 0;
+
 	ql_dbg(ql_dbg_multiq, vha, 0xc005,
 	    "mqiobase=%p, max_rsp_queues=%d, max_req_queues=%d.\n",
 	    ha->mqiobase, ha->max_rsp_queues, ha->max_req_queues);


