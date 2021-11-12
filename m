Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2A744E93D
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 15:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235122AbhKLO5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 09:57:43 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:36538 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235086AbhKLO5m (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Nov 2021 09:57:42 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 97E2A45EF2;
        Fri, 12 Nov 2021 14:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1636728889; x=
        1638543290; bh=mqBJQNwOobrzjyHVHW5ArqQIiv9cWEhbKXD2O0BuDrY=; b=f
        u1SzsbnqN9kxVF5zJ3ee3JSzbglKmDmunNwbOwQJhJ9/GNeX4JbRIPyATfR7t3cR
        DAc1gdZSWlqs9g7dzPoV9nbH5pZ/qB8al0MwVu6RlcZKKV45MrGQVnItfWPSclvz
        D2Fg72gtALiI1fK0z8nZEBjvIon40ORUnYpGzR65C4=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id jexl9PWAki8t; Fri, 12 Nov 2021 17:54:49 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id C5CD145E32;
        Fri, 12 Nov 2021 17:54:48 +0300 (MSK)
Received: from localhost (172.22.1.233) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Fri, 12
 Nov 2021 17:54:47 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Rajan Shanmugavelu <rajan.shanmugavelu@oracle.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] scsi: qla2xxx: Format log strings only if needed
Date:   Fri, 12 Nov 2021 17:54:46 +0300
Message-ID: <20211112145446.51210-1-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.22.1.233]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 598a90f2002c4 ("scsi: qla2xxx: add ring buffer for tracing debug
logs") introduced unconditional log string formatting to ql_dbg() even
if ql_dbg_log event is disabled. It harms performance because some
strings are formatted in fastpath and/or interrupt context.

Cc: Rajan Shanmugavelu <rajan.shanmugavelu@oracle.com>
Cc: stable@vger.kernel.org
Fixes: 598a90f2002c4 ("scsi: qla2xxx: add ring buffer for tracing debug logs")
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 25549a8a2d72..7cf1f78cbaee 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -2491,6 +2491,9 @@ ql_dbg(uint level, scsi_qla_host_t *vha, uint id, const char *fmt, ...)
 	struct va_format vaf;
 	char pbuf[64];
 
+	if (!ql_mask_match(level) && !trace_ql_dbg_log_enabled())
+		return;
+
 	va_start(va, fmt);
 
 	vaf.fmt = fmt;
-- 
2.33.1

