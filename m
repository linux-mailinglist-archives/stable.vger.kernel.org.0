Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0C94062C0
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241999AbhIJAqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:46:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233917AbhIJAWJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:22:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56A7C610E9;
        Fri, 10 Sep 2021 00:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233259;
        bh=aQPmRYsp4t0R6lqqlMNRoQ45zgbx1MoWbciR14O1s7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mxTxtFSYCo8ifkqAEDUx8MikxLxRQ4dbJHY5iVyBnz0BWzU297qnKL23DaWm2os5w
         vXDfTeOMFFB5cFMuEEWMWzqyMUVddryiinV8cyMmRIk9LC0RT0e7JR391WRYxTfB3O
         51orc9PK095f6b5hMy5yhuufLMVm97cUOb7VrBaqd5PuR3SzRnbabzVi2SbyD1KYGX
         EJehfV6GDC6yR1YVSipk0o56EzMol2W+f4cBT5R3BJ12u75vCZqEQqp+B8QwFFjfo7
         fCNM56MFUnEzG7Fq+Pq5O7bSwR4QiPzIhx8D0vW8ZQr1c6SRT9qyB5pEXYedJ1sFxQ
         HyfFOgKfgK0wg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 22/53] scsi: qla2xxx: Fix port type info
Date:   Thu,  9 Sep 2021 20:19:57 -0400
Message-Id: <20210910002028.175174-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002028.175174-1-sashal@kernel.org>
References: <20210910002028.175174-1-sashal@kernel.org>
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
index 4f0486fe30dd..119b5d76f97a 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2375,11 +2375,9 @@ struct mbx_24xx_entry {
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

