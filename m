Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 563C1594FE9
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbiHPEes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbiHPEeP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:34:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE520C6CFA;
        Mon, 15 Aug 2022 13:24:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A757B8119D;
        Mon, 15 Aug 2022 20:24:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83ECAC433D7;
        Mon, 15 Aug 2022 20:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595090;
        bh=i8hmpQ53bR+sr3him2AXH2AmyhXku3SVxEQnzBlMJxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jn3We1sq65fXXCeGjo6HDILmd94H1qALd9B9/mdGRGvXYFLi4hCl4HhyL41Ei8sF5
         7qdq8SOxMyMgcypTWuEqUCNr5+mzjLfLHS3dS4Yz6UiMCwSMVUaYjtvrIORl5pohnM
         NLqdQEgAVfMSMF8DZb200rJ7q03J+OEPEXeLLeR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0621/1157] scsi: qla2xxx: edif: Tear down session if keys have been removed
Date:   Mon, 15 Aug 2022 19:59:37 +0200
Message-Id: <20220815180504.501777772@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

[ Upstream commit d7e2e4a68fc047a025afcd200e6b7e1fbc8b1999 ]

If all keys for a session have been deleted, trigger a session teardown.

Link: https://lore.kernel.org/r/20220608115849.16693-6-njavali@marvell.com
Fixes: dd30706e73b7 ("scsi: qla2xxx: edif: Add key update")
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h | 5 +++++
 drivers/scsi/qla2xxx/qla_isr.c | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index c2b92a6fef90..4062d46f33a6 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2158,6 +2158,11 @@ typedef struct {
 #define CS_IOCB_ERROR		0x31	/* Generic error for IOCB request
 					   failure */
 #define CS_REJECT_RECEIVED	0x4E	/* Reject received */
+#define CS_EDIF_AUTH_ERROR	0x63	/* decrypt error */
+#define CS_EDIF_PAD_LEN_ERROR	0x65	/* pad > frame size, not 4byte align */
+#define CS_EDIF_INV_REQ		0x66	/* invalid request */
+#define CS_EDIF_SPI_ERROR	0x67	/* rx frame unable to locate sa */
+#define CS_EDIF_HDR_ERROR	0x69	/* data frame != expected len */
 #define CS_BAD_PAYLOAD		0x80	/* Driver defined */
 #define CS_UNKNOWN		0x81	/* Driver defined */
 #define CS_RETRY		0x82	/* Driver defined */
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 5deea6bff09f..ad55eace66aa 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3424,6 +3424,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	case CS_PORT_UNAVAILABLE:
 	case CS_TIMEOUT:
 	case CS_RESET:
+	case CS_EDIF_INV_REQ:
 
 		/*
 		 * We are going to have the fc class block the rport
-- 
2.35.1



