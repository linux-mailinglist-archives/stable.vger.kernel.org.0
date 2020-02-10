Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1A5157707
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgBJM5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:57:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:44092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730019AbgBJMle (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:34 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 716A32051A;
        Mon, 10 Feb 2020 12:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338493;
        bh=JijeiRR22X5vx0KO2KWcPuv8NQm7np4aQBgIfpzr/zo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yEWNHWeRPyo88LU5tGVLVBr3uuL28FOEeWPXiZmVTsUJTmHP4KQ0qyQSE5cuTNy+E
         XpQ1ElEe1OCC1u26tiiMHTBiH8oioq/Oxg2b0pU5YfY+YTXVZhZI6+FpnVrGSAfHox
         tT/kOSqR+ykgiiSdsZUOXPgMVyV3KWWKlEHwVY08=
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
Subject: [PATCH 5.5 280/367] scsi: qla2xxx: Fix the endianness of the qla82xx_get_fw_size() return type
Date:   Mon, 10 Feb 2020 04:33:13 -0800
Message-Id: <20200210122449.904942547@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
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
 drivers/scsi/qla2xxx/qla_nx.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1612,8 +1612,7 @@ qla82xx_get_bootld_offset(struct qla_hw_
 	return (u8 *)&ha->hablob->fw->data[offset];
 }
 
-static __le32
-qla82xx_get_fw_size(struct qla_hw_data *ha)
+static u32 qla82xx_get_fw_size(struct qla_hw_data *ha)
 {
 	struct qla82xx_uri_data_desc *uri_desc = NULL;
 
@@ -1624,7 +1623,7 @@ qla82xx_get_fw_size(struct qla_hw_data *
 			return cpu_to_le32(uri_desc->size);
 	}
 
-	return cpu_to_le32(*(u32 *)&ha->hablob->fw->data[FW_SIZE_OFFSET]);
+	return get_unaligned_le32(&ha->hablob->fw->data[FW_SIZE_OFFSET]);
 }
 
 static u8 *
@@ -1816,7 +1815,7 @@ qla82xx_fw_load_from_blob(struct qla_hw_
 	}
 
 	flashaddr = FLASH_ADDR_START;
-	size = (__force u32)qla82xx_get_fw_size(ha) / 8;
+	size = qla82xx_get_fw_size(ha) / 8;
 	ptr64 = (u64 *)qla82xx_get_fw_offs(ha);
 
 	for (i = 0; i < size; i++) {


