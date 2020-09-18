Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B9226EFBE
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbgIRChy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:37:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:38976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727561AbgIRCMb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:12:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2490D235F7;
        Fri, 18 Sep 2020 02:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395150;
        bh=oqfgm3QiMflCw7HWafNqLL+eZ5LDEC54GAEMgL79QS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fZIWKxHjMDiDwvL4WblKeMCP4QNZKfPuA1eEQ+eKxgXF5BEM69HMx5HpuBl4uKhZa
         h+Su8hl0B0BfrwLtYzoqqKz1aFQyiJVWwqk1DTDTKY9FkfZ+RK/O86/Ip7/KLGke1w
         WOnD04zOMeX7leLd6nRBw4xDaFUoArBSuZhpzTzE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pan Bian <bianpan2016@163.com>, Satish Kharat <satishkh@cisco.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 009/127] scsi: fnic: fix use after free
Date:   Thu, 17 Sep 2020 22:10:22 -0400
Message-Id: <20200918021220.2066485-9-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021220.2066485-1-sashal@kernel.org>
References: <20200918021220.2066485-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit ec990306f77fd4c58c3b27cc3b3c53032d6e6670 ]

The memory chunk io_req is released by mempool_free. Accessing
io_req->start_time will result in a use after free bug. The variable
start_time is a backup of the timestamp. So, use start_time here to
avoid use after free.

Link: https://lore.kernel.org/r/1572881182-37664-1-git-send-email-bianpan2016@163.com
Signed-off-by: Pan Bian <bianpan2016@163.com>
Reviewed-by: Satish Kharat <satishkh@cisco.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/fnic/fnic_scsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index d79ac0b24f5af..04c25ca2be45f 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1034,7 +1034,8 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 		atomic64_inc(&fnic_stats->io_stats.io_completions);
 
 
-	io_duration_time = jiffies_to_msecs(jiffies) - jiffies_to_msecs(io_req->start_time);
+	io_duration_time = jiffies_to_msecs(jiffies) -
+						jiffies_to_msecs(start_time);
 
 	if(io_duration_time <= 10)
 		atomic64_inc(&fnic_stats->io_stats.io_btw_0_to_10_msec);
-- 
2.25.1

