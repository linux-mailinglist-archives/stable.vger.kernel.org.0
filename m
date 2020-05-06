Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8530E1C7DC8
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 01:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbgEFXOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 19:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727798AbgEFXOw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 May 2020 19:14:52 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653CEC061A0F
        for <stable@vger.kernel.org>; Wed,  6 May 2020 16:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=qsmELZOEDzRNbDZsaxEAKDMa4d9LvYEhs+8irjWrD78=; b=X+f4enLmCtRx16vHKMrM68bcHK
        awhVUYvCjHg12zmRIAjjymHMuaAvU3EAzHKK95GB/wbYSfrxSvnN1Oa3QMnCVy/RGPnh0nJZG8xqa
        wn8VWNmgG2ZFh3xrq4BQFrj072L6ZHlMPmjHXOY+24bTUmV9C0hQVI13FXdnhEAVG0FdVt5/yCbOq
        IaPxL8ePQD2qOwdYv7VfCc0WcgO6CkQgaX8VfqvZ1+NjbwjWvUB9EuHQit0ZGNeD4K8PjuHL/0H1F
        16vQrjrWYFPID/AuSVcqfKRvNmODVyEIxXbwMCa7xPmW7ehC6nZVnIkti1+oD8tToY2+5hzYO2lWo
        x7BTE5WQ==;
Received: from [2601:647:4802:9070:75a3:623e:9ea4:11b3] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWTFc-00079G-8X; Wed, 06 May 2020 23:14:52 +0000
From:   Sagi Grimberg <sagi@grimberg.me>
To:     <stable@vger.kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>
Subject: [PATCH stable 5.4+] nvme: fix possible hang when ns scanning fails during error recovery
Date:   Wed,  6 May 2020 16:14:51 -0700
Message-Id: <20200506231451.23145-1-sagi@grimberg.me>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When the controller is reconnecting, the host fails I/O and admin
commands as the host cannot reach the controller. ns scanning may
revalidate namespaces during that period and it is wrong to remove
namespaces due to these failures as we may hang (see 205da2434301).

One command that may fail is nvme_identify_ns_descs. Since we return
success due to having ns descriptor list optional, we continue to
validate ns identifiers in nvme_revalidate_disk, obviously fail and
return -ENODEV to nvme_validate_ns, which will remove the namespace.

Exactly what we don't want to happen.

Fixes: 22802bf742c2 ("nvme: Namepace identification descriptor list is optional")
Tested-by: Anton Eidelman <anton@lightbitslabs.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/nvme/host/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 31b7dcd791c2..8ce9b4fbc821 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1746,7 +1746,7 @@ static int nvme_report_ns_ids(struct nvme_ctrl *ctrl, unsigned int nsid,
 		if (ret)
 			dev_warn(ctrl->device,
 				 "Identify Descriptors failed (%d)\n", ret);
-		if (ret > 0)
+		if (ret > 0 && !(ret & NVME_SC_DNR))
 			ret = 0;
 	}
 	return ret;
-- 
2.20.1

