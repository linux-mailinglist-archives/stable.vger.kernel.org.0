Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98CE0593873
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343652AbiHOTMi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344006AbiHOTLc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:11:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A524F4F69F;
        Mon, 15 Aug 2022 11:37:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB974B81082;
        Mon, 15 Aug 2022 18:37:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FB9C433C1;
        Mon, 15 Aug 2022 18:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588622;
        bh=dGIhvIVlTqjvge9VTLyUtZVpVLlYTitEQSS0D6+X9eo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z3S0XcFJ652j5o7+wk2yG82Mz0mUXJzkk6dW7R2SrzZOMfQazLIFnFMPhTmiATydE
         oQqj16zsxDveZK02srQY3l/5suEl9UOQuHk6LgJgXXlsBBN/9ZGqEmrUD/FhmNK1Vm
         jM0vhU+YoGtmxcIhtDRWmYeOwCAYbBexAsshSukU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 422/779] scsi: qla2xxx: edif: Tear down session if keys have been removed
Date:   Mon, 15 Aug 2022 20:01:06 +0200
Message-Id: <20220815180355.297007226@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index 883b3fb07c2c..4fc289815ccb 100644
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
index c3711ab68c3d..c41a965eb4a7 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3420,6 +3420,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	case CS_PORT_UNAVAILABLE:
 	case CS_TIMEOUT:
 	case CS_RESET:
+	case CS_EDIF_INV_REQ:
 
 		/*
 		 * We are going to have the fc class block the rport
-- 
2.35.1



