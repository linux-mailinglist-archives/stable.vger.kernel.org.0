Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C727D353CBB
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 10:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbhDEI4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:56:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:34824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232910AbhDEI40 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 04:56:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AFB361245;
        Mon,  5 Apr 2021 08:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617612980;
        bh=I2wM7d8m3gQj4oCpdlaDJdwdAUqStOU4cVPfVyEn7II=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ECJ2djGjVhuM7WZClPSytH9LHcrOBw+mn8cheMm5ITSkE6GOcrl9mH5ch8eM4h0KU
         huWD5S7sJyADBUj26fK9VhgT7gJINGe2nHBhvYBPdsNabnqNzMvLQO9SdfLyVlfQFW
         I2W5my6iFNHfUnkZjHAQcFp6OcdPqj/FYHE3q2l4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 09/28] scsi: qla2xxx: Fix broken #endif placement
Date:   Mon,  5 Apr 2021 10:53:43 +0200
Message-Id: <20210405085017.319504623@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085017.012074144@linuxfoundation.org>
References: <20210405085017.012074144@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>

[ Upstream commit 5999b9e5b1f8a2f5417b755130919b3ac96f5550 ]

Only half of the file is under include guard because terminating #endif
is placed too early.

Link: https://lore.kernel.org/r/YE4snvoW1SuwcXAn@localhost.localdomain
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_target.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index bca584ae45b7..7a6fafa8ba56 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -112,7 +112,6 @@
 	(min(1270, ((ql) > 0) ? (QLA_TGT_DATASEGS_PER_CMD_24XX + \
 		QLA_TGT_DATASEGS_PER_CONT_24XX*((ql) - 1)) : 0))
 #endif
-#endif
 
 #define GET_TARGET_ID(ha, iocb) ((HAS_EXTENDED_IDS(ha))			\
 			 ? le16_to_cpu((iocb)->u.isp2x.target.extended)	\
@@ -323,6 +322,7 @@ struct ctio_to_2xxx {
 #ifndef CTIO_RET_TYPE
 #define CTIO_RET_TYPE	0x17		/* CTIO return entry */
 #define ATIO_TYPE7 0x06 /* Accept target I/O entry for 24xx */
+#endif
 
 struct fcp_hdr {
 	uint8_t  r_ctl;
-- 
2.30.1



