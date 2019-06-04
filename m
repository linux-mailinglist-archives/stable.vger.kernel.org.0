Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAC0635422
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 01:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbfFDXbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 19:31:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:33598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727183AbfFDXXH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 19:23:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8011F2085A;
        Tue,  4 Jun 2019 23:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559690587;
        bh=nPrxG2VCASchUxSF39JLTqA8vdNFE2cc2ID1X0gHivw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ghBHankZdiz7+AN1/+96Lr2l+EMpKw45ye4LiTlW1nXbV/VDvAJyM3wSsSrnBYSO5
         ce10wjxqZ8RvIz6PPvP75ubPN49+pBEQS/uNyfNxnIwRmtaIRNlxmWvQ7E0UWmUk2X
         7esKwhvNX0I+l/278u2pJF6kSDdgYxnGHeErDmPI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        Hannes Reinecke <hare@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 36/60] scsi: myrs: Fix uninitialized variable
Date:   Tue,  4 Jun 2019 19:21:46 -0400
Message-Id: <20190604232212.6753-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190604232212.6753-1-sashal@kernel.org>
References: <20190604232212.6753-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 41552199b5518fe26bee0829a28dd1880441b430 ]

drivers/scsi/myrs.c: In function 'myrs_log_event':
drivers/scsi/myrs.c:821:24: warning: 'sshdr.sense_key' may be used uninitialized in this function [-Wmaybe-uninitialized]
  struct scsi_sense_hdr sshdr;

If ev->ev_code is not 0x1C, sshdr.sense_key may be used uninitialized. Fix
this by initializing variable 'sshdr' to 0.

Fixes: 77266186397c ("scsi: myrs: Add Mylex RAID controller (SCSI interface)")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/myrs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index b8d54ef8cf6d..eb0dd566330a 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -818,7 +818,7 @@ static void myrs_log_event(struct myrs_hba *cs, struct myrs_event *ev)
 	unsigned char ev_type, *ev_msg;
 	struct Scsi_Host *shost = cs->host;
 	struct scsi_device *sdev;
-	struct scsi_sense_hdr sshdr;
+	struct scsi_sense_hdr sshdr = {0};
 	unsigned char sense_info[4];
 	unsigned char cmd_specific[4];
 
-- 
2.20.1

