Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 484DC15C584
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgBMPWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:22:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:32936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728172AbgBMPWx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:22:53 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25A0B24693;
        Thu, 13 Feb 2020 15:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607372;
        bh=/Kw46xrvWB8hefBpLQr0auTxVCYGnT9cei+/yPa7N8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XUsITtdDjyOwBrgVo17ppr0K3Za6XstbU4sVizlEAczE16dc8wW8e3nIupehxCiG0
         PrOzFMaStmPZbgFQPZZOSsTDt2Cl3U7HRLWxbR9u9I4rClXT3gGgKLQpkFM4+YxyYb
         9A17YPistIGneLRX4V2z0NVCDP9KXTe/gserJD/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.4 47/91] scsi: qla2xxx: Fix the endianness of the qla82xx_get_fw_size() return type
Date:   Thu, 13 Feb 2020 07:20:04 -0800
Message-Id: <20200213151839.719740209@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151821.384445454@linuxfoundation.org>
References: <20200213151821.384445454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

commit 3f5f7335e5e234e340b48ecb24c2aba98a61f934 upstream.

Since qla82xx_get_fw_size() returns a number in CPU-endian format, change
its return type from __le32 into u32. This patch does not change any
functionality.

Fixes: 9c2b297572bf ("[SCSI] qla2xxx: Support for loading Unified ROM Image (URI) format firmware file.")
Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Link: https://lore.kernel.org/r/20191219004905.39586-1-bvanassche@acm.org
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_nx.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -10,6 +10,7 @@
 #include <linux/ratelimit.h>
 #include <linux/vmalloc.h>
 #include <scsi/scsi_tcq.h>
+#include <asm/unaligned.h>
 
 #define MASK(n)			((1ULL<<(n))-1)
 #define MN_WIN(addr) (((addr & 0x1fc0000) >> 1) | \
@@ -1600,8 +1601,7 @@ qla82xx_get_bootld_offset(struct qla_hw_
 	return (u8 *)&ha->hablob->fw->data[offset];
 }
 
-static __le32
-qla82xx_get_fw_size(struct qla_hw_data *ha)
+static u32 qla82xx_get_fw_size(struct qla_hw_data *ha)
 {
 	struct qla82xx_uri_data_desc *uri_desc = NULL;
 
@@ -1612,7 +1612,7 @@ qla82xx_get_fw_size(struct qla_hw_data *
 			return cpu_to_le32(uri_desc->size);
 	}
 
-	return cpu_to_le32(*(u32 *)&ha->hablob->fw->data[FW_SIZE_OFFSET]);
+	return get_unaligned_le32(&ha->hablob->fw->data[FW_SIZE_OFFSET]);
 }
 
 static u8 *
@@ -1803,7 +1803,7 @@ qla82xx_fw_load_from_blob(struct qla_hw_
 	}
 
 	flashaddr = FLASH_ADDR_START;
-	size = (__force u32)qla82xx_get_fw_size(ha) / 8;
+	size = qla82xx_get_fw_size(ha) / 8;
 	ptr64 = (u64 *)qla82xx_get_fw_offs(ha);
 
 	for (i = 0; i < size; i++) {


