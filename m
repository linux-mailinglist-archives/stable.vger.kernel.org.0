Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07ED9594899
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243004AbiHOXH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352796AbiHOXGP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:06:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E733140CBC;
        Mon, 15 Aug 2022 12:58:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D986C60FD8;
        Mon, 15 Aug 2022 19:58:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF53C433B5;
        Mon, 15 Aug 2022 19:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593529;
        bh=x41DbS8qV3r1/pYkKDJeNP/yz9M9kqdvIN4rxibxN+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yHxvA7O8j+DUJHmiFUaULU9ljY/bxHh61WX5EVtm7nk1xQ4SvRnUHlQULZvy24y/q
         CEjUXi2kLqJ1XoV4o6/l24aijpKUenZFzjF8Hj87O0BeQEBWcnVXuGq4aM8jyooLkx
         FYRqaI2q/Hm5kC37GKwVkBcVfN4CRlE6917Fe6NE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.18 0963/1095] scsi: qla2xxx: Turn off multi-queue for 8G adapters
Date:   Mon, 15 Aug 2022 20:06:02 +0200
Message-Id: <20220815180508.906617776@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
@@ -4264,8 +4264,8 @@ struct qla_hw_data {
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
@@ -4419,16 +4419,12 @@ msix_register_fail:
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


