Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5319FB0641
	for <lists+stable@lfdr.de>; Thu, 12 Sep 2019 02:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbfILAjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 20:39:54 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:56146 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726157AbfILAjx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Sep 2019 20:39:53 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 88676435D9;
        Thu, 12 Sep 2019 00:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1568248791; x=1570063192; bh=0mflloWsjya3SzTXcn/bDjATsmhmG3gmW1a
        FmjrD1do=; b=JJyF7xyLGC9AkHOK9FR3N7eHA5J9u6Oi5o9M56sWlw7UtJP8of0
        Vsy3JMaq0CddQ2w9LvnW8xADSfFB5mgBr2vWWOXVxkWH6JDz2m8qHOSQ9Gs1nFfG
        /uTc2fqBoU4Yj34HrNSFu6dsg7l0M1G7Y445bPmmhCuNd+Ho1as+88Ag=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id i6UPLw9_BNU8; Thu, 12 Sep 2019 03:39:51 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 3581742001;
        Thu, 12 Sep 2019 03:39:51 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 12
 Sep 2019 03:39:50 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <linux-scsi@vger.kernel.org>
CC:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Quinn Tran <qtran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 4/4] scsi: qla2xxx: Change discovery state before PLOGI
Date:   Thu, 12 Sep 2019 03:39:19 +0300
Message-ID: <20190912003919.8488-5-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190912003919.8488-1-r.bolshakov@yadro.com>
References: <20190912003919.8488-1-r.bolshakov@yadro.com>
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
Cc: Quinn Tran <qtran@marvell.com>
Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: stable@vger.kernel.org
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index c8d89912d044..e4857ef0e5c4 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -516,6 +516,7 @@ static int qla_post_els_plogi_work(struct scsi_qla_host *vha, fc_port_t *fcport)
 
 	e->u.fcport.fcport = fcport;
 	fcport->flags |= FCF_ASYNC_ACTIVE;
+	fcport->disc_state = DSC_LOGIN_PEND;
 	return qla2x00_post_work(vha, e);
 }
 
-- 
2.22.0

