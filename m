Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EACE353E1
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 01:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfFDX2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 19:28:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727091AbfFDXYl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 19:24:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E577206C1;
        Tue,  4 Jun 2019 23:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559690681;
        bh=nh0lPNtU7stzpWYvVlQm/DEHacNPeiTiSaWypLnmXYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fkXp3fXsnuqPV7XyHG4WxWwmzwuqrI0U/DAaH8QSI4HU+aEEVZx+LyR5+UxKodtAL
         BrO9H9hYDffJkXNzD8VIcca0SRuZRvT4UpUblKiXW0A9uYHLhX6cjeF0/Wlco+eRR7
         jca70VAFqFUXq6O7L3l1oyLej2Yizs3I3KsEsFu0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 12/24] scsi: qedi: remove set but not used variables 'cdev' and 'udev'
Date:   Tue,  4 Jun 2019 19:24:03 -0400
Message-Id: <20190604232416.7479-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190604232416.7479-1-sashal@kernel.org>
References: <20190604232416.7479-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit d0adee5d12752256ff0c87ad7f002f21fe49d618 ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/qedi/qedi_iscsi.c: In function 'qedi_ep_connect':
drivers/scsi/qedi/qedi_iscsi.c:813:23: warning: variable 'udev' set but not used [-Wunused-but-set-variable]
drivers/scsi/qedi/qedi_iscsi.c:812:18: warning: variable 'cdev' set but not used [-Wunused-but-set-variable]

These have never been used since introduction.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedi/qedi_iscsi.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 0b7267e68336..94f3829b1974 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -817,8 +817,6 @@ qedi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 	struct qedi_endpoint *qedi_ep;
 	struct sockaddr_in *addr;
 	struct sockaddr_in6 *addr6;
-	struct qed_dev *cdev  =  NULL;
-	struct qedi_uio_dev *udev = NULL;
 	struct iscsi_path path_req;
 	u32 msg_type = ISCSI_KEVENT_IF_DOWN;
 	u32 iscsi_cid = QEDI_CID_RESERVED;
@@ -838,8 +836,6 @@ qedi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 	}
 
 	qedi = iscsi_host_priv(shost);
-	cdev = qedi->cdev;
-	udev = qedi->udev;
 
 	if (test_bit(QEDI_IN_OFFLINE, &qedi->flags) ||
 	    test_bit(QEDI_IN_RECOVERY, &qedi->flags)) {
-- 
2.20.1

