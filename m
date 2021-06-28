Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93EF03B6A20
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 23:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237177AbhF1VXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 17:23:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236794AbhF1VXT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 17:23:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDE2761CFC;
        Mon, 28 Jun 2021 21:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624915253;
        bh=YCXtV/pR9YFL5eLGNB9mKwdY0EYLoXZSs9y4rTOPIAc=;
        h=From:To:Cc:Subject:Date:From;
        b=dau3sz3PnxEycwXqFfmRfmi3q0mBRvBIH7lyee/gr0UfwOgnCgiqAOAdazDj7kcMh
         lcqCAyq4pgaGAyzSCEBbZT8rX/grbQ0uJcdG9hdKOTd7hoF2kpwLRiaFLOAJTbMugb
         8ds6ItfLxmm4NqxVRdYGk/zVWN9hP63eUS3oXlUS7b0aJ6w2piLpqHNpewVinL0SlB
         yyKVcvmL9U2lAwnBE+jP2+LHS/kxp16OBnmtnXTwef3L/6SOU1zFm8zBUpBLUlBrMv
         V2qnCBCTW/iFHM5/UzLkr9PzFjsT+n7PBl2tO17pvzxO/ppVyglDpbKO73x0Z/WCO/
         joEmJCnkSYMJw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     ManYi Li <limanyi@uniontech.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 1/5] scsi: sr: Return appropriate error code when disk is ejected
Date:   Mon, 28 Jun 2021 17:20:47 -0400
Message-Id: <20210628212051.43265-1-sashal@kernel.org>
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
index e4633b84c556..7815ed642d43 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -220,6 +220,8 @@ static unsigned int sr_get_events(struct scsi_device *sdev)
 		return DISK_EVENT_EJECT_REQUEST;
 	else if (med->media_event_code == 2)
 		return DISK_EVENT_MEDIA_CHANGE;
+	else if (med->media_event_code == 3)
+		return DISK_EVENT_EJECT_REQUEST;
 	return 0;
 }
 
-- 
2.30.2

