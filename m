Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C51233B6A4A
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 23:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238036AbhF1V0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 17:26:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237959AbhF1VXd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 17:23:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8342F61CFA;
        Mon, 28 Jun 2021 21:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624915267;
        bh=a46ov3xiFTEH9eZ2s2pmq+mMWtToy8dylQklgM1XSmw=;
        h=From:To:Cc:Subject:Date:From;
        b=kF/EgW9ZOeSLFJIbLcOV97k1B0U3pbb2m5jBFj0A2Gmsj2Nz3/XVIVZKz41KNVon3
         PHYcKI6Woj/VSyOJQDykvxgQ/w5EuF8FPYI+D/JpfoliMkF8gNY0sUg7aXDAoc4yDJ
         dFQQ5vUd2mF/OvctRWfRVVPlxduKbE0JEwHCCMgqVTDg7OQqkvFhTUQnynY6szWX9L
         rSgfLc9sgF2A7klTX0vhyZ0k6sKPdJsppquuEXbmLPvrqPSjocZgf/F6YHzS32bIPF
         RB8wRtVicTLr+YvLKIKcE2sv39CbLcKM/iMXyV+6PQbZ2+1D/4d1aQNV0/BWvFhxxc
         RnqqdnG5aQ+ZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     ManYi Li <limanyi@uniontech.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 1/3] scsi: sr: Return appropriate error code when disk is ejected
Date:   Mon, 28 Jun 2021 17:21:03 -0400
Message-Id: <20210628212105.43449-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ManYi Li <limanyi@uniontech.com>

[ Upstream commit 7dd753ca59d6c8cc09aa1ed24f7657524803c7f3 ]

Handle a reported media event code of 3. This indicates that the media has
been removed from the drive and user intervention is required to proceed.
Return DISK_EVENT_EJECT_REQUEST in that case.

Link: https://lore.kernel.org/r/20210611094402.23884-1-limanyi@uniontech.com
Signed-off-by: ManYi Li <limanyi@uniontech.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 70a28f6fb1d0..2332b245b182 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -218,6 +218,8 @@ static unsigned int sr_get_events(struct scsi_device *sdev)
 		return DISK_EVENT_EJECT_REQUEST;
 	else if (med->media_event_code == 2)
 		return DISK_EVENT_MEDIA_CHANGE;
+	else if (med->media_event_code == 3)
+		return DISK_EVENT_EJECT_REQUEST;
 	return 0;
 }
 
-- 
2.30.2

