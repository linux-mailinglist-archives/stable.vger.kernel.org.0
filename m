Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC5F1D0EEF
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732629AbgEMJsw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:48:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733121AbgEMJsu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:48:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DE5320575;
        Wed, 13 May 2020 09:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363330;
        bh=R8iEln+dLJ0CdeHWgp0V3gFCfQATCdjG5I2aG0UjMbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CSBL4UlRP84/z2vKG8nb8C9zw2sYbN+x7Ihy0KPWCEhB4KwfeHLJ0bSRVhMPpsbkH
         N/zkMN9olxsnm2rFU05r8WHA2D+erOesuEsji8u6KFoytE7oFuOmG5+8SoZZc4LM0f
         +KK3GAjX4/piH0xAaSp0B0dzFkcZhuQqsU4XGdv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anton Eidelman <anton@lightbitslabs.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 03/90] nvme: fix possible hang when ns scanning fails during error recovery
Date:   Wed, 13 May 2020 11:43:59 +0200
Message-Id: <20200513094409.467768594@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094408.810028856@linuxfoundation.org>
References: <20200513094408.810028856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 59c7c3caaaf8750df4ec3255082f15eb4e371514 ]

When the controller is reconnecting, the host fails I/O and admin
commands as the host cannot reach the controller. ns scanning may
revalidate namespaces during that period and it is wrong to remove
namespaces due to these failures as we may hang (see 205da2434301).

One command that may fail is nvme_identify_ns_descs. Since we return
success due to having ns identify descriptor list optional, we continue
to compare ns identifiers in nvme_revalidate_disk, obviously fail and
return -ENODEV to nvme_validate_ns, which will remove the namespace.

Exactly what we don't want to happen.

Fixes: 22802bf742c2 ("nvme: Namepace identification descriptor list is optional")
Tested-by: Anton Eidelman <anton@lightbitslabs.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 66147df86d883..f0e0af3aa714e 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1078,7 +1078,7 @@ static int nvme_identify_ns_descs(struct nvme_ctrl *ctrl, unsigned nsid,
 		  * Don't treat an error as fatal, as we potentially already
 		  * have a NGUID or EUI-64.
 		  */
-		if (status > 0)
+		if (status > 0 && !(status & NVME_SC_DNR))
 			status = 0;
 		goto free_data;
 	}
-- 
2.20.1



