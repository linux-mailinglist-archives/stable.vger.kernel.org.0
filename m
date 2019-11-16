Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36C44FF392
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbfKPPly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:41:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:45176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728024AbfKPPlv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:41:51 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7BCB20833;
        Sat, 16 Nov 2019 15:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918911;
        bh=6eykspN3cd2v1dC2FZs8AixH9I5Z7C5N1now7YBSKs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KUeqWWM4PIyauU9lugAMBZBc8zKZUlUvpUEeZ2EaBuhZ9JVDEBEecmvxhsZOYj0Eh
         wWugueQxrCb67UMzCT0bLC4wENwx0olqdC53UevRAPBjEttpY0bV/3eGARe2FunanK
         iaV1FpCqkQGMnjPrEOPR8ny3yFNU8dgCZ5c8BaZI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luo Jiaxing <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 034/237] scsi: hisi_sas: Feed back linkrate(max/min) when re-attached
Date:   Sat, 16 Nov 2019 10:37:49 -0500
Message-Id: <20191116154113.7417-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

[ Upstream commit 5a54691f874ab29ec82f08bc6936866a3ccdaa91 ]

At directly attached situation, if the user modifies the sysfs interface
of maximum_linkrate and minimum_linkrate to renegotiate the linkrate
between SAS controller and target, the value of both files mentioned
above should have change to user setting after renegotiate is over, but
it remains unchanged.

To fix this bug, maximum_linkrate and minimum_linkrate will be directly
fed back to relevant sas_phy structure.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index fd9d82c9033de..e9747379384b2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -906,6 +906,9 @@ static void hisi_sas_phy_set_linkrate(struct hisi_hba *hisi_hba, int phy_no,
 	_r.maximum_linkrate = max;
 	_r.minimum_linkrate = min;
 
+	sas_phy->phy->maximum_linkrate = max;
+	sas_phy->phy->minimum_linkrate = min;
+
 	hisi_hba->hw->phy_disable(hisi_hba, phy_no);
 	msleep(100);
 	hisi_hba->hw->phy_set_linkrate(hisi_hba, phy_no, &_r);
-- 
2.20.1

