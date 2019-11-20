Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85C6C104672
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 23:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbfKTW1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 17:27:39 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:51252 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726346AbfKTW1i (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Nov 2019 17:27:38 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 2F10643D79;
        Wed, 20 Nov 2019 22:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1574288856; x=1576103257; bh=bukIwQHWOI0oe/Kwe6RNHTVy/xzfD1g7Tzr
        Im4yeQc8=; b=XumyDsq4dKFGr5jfWSbRy41kfAngfcHK43Z1QE9gYH024CsvsB1
        F4QsaoVTNxeDaV9nWyruUOSckb/o8NrB/PnKYsbniJqI31MYzet6OTi1zIaviAJx
        nCjz7wqgfSjFBJ6oksmRMfki69ySGM81AJPTn4+QwXmWEhYrer18C4ho=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id YYtdjL79dd2y; Thu, 21 Nov 2019 01:27:36 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 8483D43597;
        Thu, 21 Nov 2019 01:27:33 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 21
 Nov 2019 01:27:33 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
CC:     <linux@yadro.com>, Roman Bolshakov <r.bolshakov@yadro.com>,
        Quinn Tran <qutran@marvell.com>, <stable@vger.kernel.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 04/15] scsi: qla2xxx: Change discovery state before PLOGI
Date:   Thu, 21 Nov 2019 01:27:12 +0300
Message-ID: <20191120222723.27779-5-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191120222723.27779-1-r.bolshakov@yadro.com>
References: <20191120222723.27779-1-r.bolshakov@yadro.com>
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

When a port sends PLOGI, discovery state should be changed to login
pending, otherwise RELOGIN_NEEDED bit is set in
qla24xx_handle_plogi_done_event(). RELOGIN_NEEDED triggers another
PLOGI, and it never goes out of the loop until login timer expires.

Fixes: 8777e4314d397 ("scsi: qla2xxx: Migrate NVME N2N handling into state machine")
Fixes: 8b5292bcfcacf ("scsi: qla2xxx: Fix Relogin to prevent modifying scan_state flag")
Cc: Quinn Tran <qutran@marvell.com>
Cc: stable@vger.kernel.org
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 4f3da968163e..fcb309be50d9 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -533,6 +533,7 @@ static int qla_post_els_plogi_work(struct scsi_qla_host *vha, fc_port_t *fcport)
 
 	e->u.fcport.fcport = fcport;
 	fcport->flags |= FCF_ASYNC_ACTIVE;
+	fcport->disc_state = DSC_LOGIN_PEND;
 	return qla2x00_post_work(vha, e);
 }
 
-- 
2.24.0

