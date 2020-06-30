Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6926320F49A
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 14:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730689AbgF3M3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 08:29:42 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:3750 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730095AbgF3M3m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 08:29:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1593520181; x=1625056181;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=1SYBHjTB+q5E+ZB8QENYuEXlQudyQrqQO5pO6Am+EEU=;
  b=H2gEzFv0kVTs7zN9dem+WBaSAh/9oFVo0mO+eDE3d7n+zPvwGeS0grV/
   zBUFkFHBSXAaaWrYTinmEcyIxPM8Jeit5zAww9HJFp1USU8yiwc7JToPV
   FTwQbL3GyalSH86SK/gHo9rQIVZVxZBSD7dS7F57vlb4EjtoOmqPAOOmp
   8=;
IronPort-SDR: 24GE8aKjT5T9+JGempUpxCY0xCGWdMUQzMqL9jkMNbtduu4ZyyCdQF6qGsE8klTAMuwe714Jgk
 xvtVzeu8wrVQ==
X-IronPort-AV: E=Sophos;i="5.75,297,1589241600"; 
   d="scan'208";a="39354207"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-69849ee2.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 30 Jun 2020 12:29:39 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-69849ee2.us-west-2.amazon.com (Postfix) with ESMTPS id DD6ADA23B6;
        Tue, 30 Jun 2020 12:29:38 +0000 (UTC)
Received: from EX13D18EUC001.ant.amazon.com (10.43.164.108) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 30 Jun 2020 12:29:38 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D18EUC001.ant.amazon.com (10.43.164.108) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 30 Jun 2020 12:29:37 +0000
Received: from dev-dsk-mheyne-60001.pdx1.corp.amazon.com (10.184.85.242) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Tue, 30 Jun 2020 12:29:36 +0000
Received: by dev-dsk-mheyne-60001.pdx1.corp.amazon.com (Postfix, from userid 5466572)
        id 92633222EA; Tue, 30 Jun 2020 12:29:35 +0000 (UTC)
From:   Maximilian Heyne <mheyne@amazon.de>
CC:     Amit Shah <aams@amazon.de>, Maximilian Heyne <mheyne@amazon.de>,
        <stable@vger.kernel.org>, Keith Busch <kbusch@kernel.org>,
        Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        <linux-nvme@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] nvme: validate cntlid's only for nvme >= 1.1.0
Date:   Tue, 30 Jun 2020 12:29:23 +0000
Message-ID: <20200630122923.70282-1-mheyne@amazon.de>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Controller ID's (cntlid) for NVMe devices were introduced in version
1.1.0 of the specification. Controllers that follow the older 1.0.0 spec
don't set this field so it doesn't make sense to validate it. On the
contrary, when using SR-IOV this check breaks VFs as they are all part
of the same NVMe subsystem.

Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
Cc: <stable@vger.kernel.org> # 5.4+
---
 drivers/nvme/host/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 28f4388c1337..c4a991acc949 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2773,7 +2773,8 @@ static int nvme_init_subsystem(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id)
 		put_device(&subsys->dev);
 		subsys = found;
 
-		if (!nvme_validate_cntlid(subsys, ctrl, id)) {
+		if (ctrl->vs >= NVME_VS(1, 1, 0) &&
+		    !nvme_validate_cntlid(subsys, ctrl, id)) {
 			ret = -EINVAL;
 			goto out_put_subsystem;
 		}
@@ -2883,7 +2884,7 @@ int nvme_init_identify(struct nvme_ctrl *ctrl)
 			goto out_free;
 	}
 
-	if (!(ctrl->ops->flags & NVME_F_FABRICS))
+	if (!(ctrl->ops->flags & NVME_F_FABRICS) && ctrl->vs >= NVME_VS(1, 1, 0))
 		ctrl->cntlid = le16_to_cpu(id->cntlid);
 
 	if (!ctrl->identified) {
-- 
2.16.6




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



