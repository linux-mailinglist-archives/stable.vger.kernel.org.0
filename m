Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E13B5D6DD
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 21:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfGBTZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 15:25:53 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:53590 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726150AbfGBTZx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 15:25:53 -0400
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Jul 2019 15:25:53 EDT
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 7C75B411F8;
        Tue,  2 Jul 2019 19:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1562095080; x=
        1563909481; bh=sjz/K56KGGCUexLYlwc8FGJTk9NAU+HD2VlXyj7iZEo=; b=X
        7QiXo6pWgRewg7Gb8QysJaesR+7+NeD1ml86xm7cJ0r9JmgBJz578d4d+x4Jr+2s
        trlob+A2Z7huB6QYczjbYevGw20IRMhVQ7TuMZ+Gx79hix7R49Q6QLNdfUUfBnhC
        GiKyA2vew32eV+pGsATYyjswzTDxCi4e42IhsB8Ztk=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id V4ehjoBIEHyI; Tue,  2 Jul 2019 22:18:00 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 6A81A411D9;
        Tue,  2 Jul 2019 22:18:00 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 2 Jul
 2019 22:18:00 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>
CC:     Roman Bolshakov <r.bolshakov@yadro.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <stable@vger.kernel.org>, Bart Van Assche <bvanassche@acm.org>
Subject: [RESEND PATCH] scsi: target/iblock: Fix overrun in WRITE SAME emulation
Date:   Tue, 2 Jul 2019 22:16:38 +0300
Message-ID: <20190702191636.26481-1-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.17.128.60]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

WRITE SAME corrupts data on the block device behind iblock if the
command is emulated. The emulation code issues (M - 1) * N times more
bios than requested, where M is the number of 512 blocks per real block
size and N is the NUMBER OF LOGICAL BLOCKS specified in WRITE SAME
command. So, for a device with 4k blocks, 7 * N more LBAs gets written
after the requested range.

The issue happens because the number of 512 byte sectors to be written
is decreased one by one while the real bios are typically from 1 to 8
512 byte sectors per bio.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Cc: <stable@vger.kernel.org>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_iblock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index f4a075303e9a..6949ea8bc387 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -502,7 +502,7 @@ iblock_execute_write_same(struct se_cmd *cmd)
 
 		/* Always in 512 byte units for Linux/Block */
 		block_lba += sg->length >> SECTOR_SHIFT;
-		sectors -= 1;
+		sectors -= sg->length >> SECTOR_SHIFT;
 	}
 
 	iblock_submit_bios(&list);
-- 
2.22.0

