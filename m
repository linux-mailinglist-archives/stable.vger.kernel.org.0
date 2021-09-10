Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47D1406211
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbhIJAoi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:44:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233589AbhIJAUX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:20:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8E5C61101;
        Fri, 10 Sep 2021 00:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233153;
        bh=RbpI+L4ARcnT+0jWMh0/xtaUcmedBI1wx8lu169hb1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pMa0QhpTV3iUL2KYvmYuKhEUseudUpkkjQ6ykx+UOREnVFOl3k48M3PcoYxbtGK8S
         sCQ4L4UCiOkg5tCIPYi/e3HkoHaYt08CIdnol1pGosPh0TA0NfaPFNl4y7GZ2JKzqP
         UNhNJBG7FOqb13xsb2NYF88hsPVOrVVDTrXteMHPfMnGIhbXdOQT3QxwnPyU12vyEU
         HF4Orj5aH3Q31Y2HfANp93xAi+lnxaQmWgE1a19uGxxFaoStdp9oY3dvr2oFLciTpe
         iewT6+BXeBo8zRXqOveX6ietT5jswaHcSHsGHVvs9ObgCPqQxgz+mCXFBIcfSw7gaX
         Xcgy/rlS+OAuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 37/88] scsi: qla2xxx: Fix port type info
Date:   Thu,  9 Sep 2021 20:17:29 -0400
Message-Id: <20210910001820.174272-37-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit 01c97f2dd8fb4d2188c779a975031c0fe1ec061d ]

Over time, fcport->port_type became a flag field. The flags within this
field were not defined properly. This caused external tools to read wrong
info.

Link: https://lore.kernel.org/r/20210810043720.1137-8-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index def4d99f80e9..0cd1f820b111 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2377,11 +2377,9 @@ struct mbx_24xx_entry {
  */
 typedef enum {
 	FCT_UNKNOWN,
-	FCT_RSCN,
-	FCT_SWITCH,
-	FCT_BROADCAST,
-	FCT_INITIATOR,
-	FCT_TARGET,
+	FCT_BROADCAST = 0x01,
+	FCT_INITIATOR = 0x02,
+	FCT_TARGET    = 0x04,
 	FCT_NVME_INITIATOR = 0x10,
 	FCT_NVME_TARGET = 0x20,
 	FCT_NVME_DISCOVERY = 0x40,
-- 
2.30.2

