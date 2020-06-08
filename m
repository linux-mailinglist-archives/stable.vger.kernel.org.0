Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA541F2E9F
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730430AbgFIAnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:43:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728543AbgFHXMO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:12:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A92120C09;
        Mon,  8 Jun 2020 23:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657934;
        bh=ETOa5S7IVS5g7JXF0N5kT4zBWbPEceRY2Mwz3JiwPEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JGsUpFbPNJNHpKTtOWz4y701r97m687ovRqRSoCpy6pklBQWWB+LHItAFTGrZFSDP
         mU2wT4Jn9sDzfAmoMl00OOE6dm3gf8+Wpzt+HT3USD4W1SdKUa0A8ZJ/96c71gsYBp
         fhdCoqvDh9GFC5VHtkvqdZ/5Alq3legT1dO1wYto=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 002/606] s390/ism: fix error return code in ism_probe()
Date:   Mon,  8 Jun 2020 19:02:07 -0400
Message-Id: <20200608231211.3363633-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 29b74cb75e3572d83708745e81e24d37837415f9 ]

Fix to return negative error code -ENOMEM from the smcd_alloc_dev()
error handling case instead of 0, as done elsewhere in this function.

Fixes: 684b89bc39ce ("s390/ism: add device driver for internal shared memory")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/ism_drv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index 4fc2056bd227..e615dc240150 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -521,8 +521,10 @@ static int ism_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	ism->smcd = smcd_alloc_dev(&pdev->dev, dev_name(&pdev->dev), &ism_ops,
 				   ISM_NR_DMBS);
-	if (!ism->smcd)
+	if (!ism->smcd) {
+		ret = -ENOMEM;
 		goto err_resource;
+	}
 
 	ism->smcd->priv = ism;
 	ret = ism_dev_init(ism);
-- 
2.25.1

