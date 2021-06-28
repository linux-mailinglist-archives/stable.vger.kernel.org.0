Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 471503B6A32
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 23:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237941AbhF1VXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 17:23:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237909AbhF1VX1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 17:23:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E18361CFC;
        Mon, 28 Jun 2021 21:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624915261;
        bh=p88Dfq2ocF55CXnAHK+P/uCHyqbNSfZBQjPxRzvgz6I=;
        h=From:To:Cc:Subject:Date:From;
        b=Rl+dXm8j/COFidAK7BV3ml6xVEihLW486B9jCgU4w8BgVE1ggXsQuYUoURs9F+FDV
         KjMyIrs4y4KsEpDmWnGqjf5Jud3qja3lishZkUo/JKHLm59L8SKvw1G9RYZREWb5Gk
         PN6CwwtUOV/UcqxGJlfv2aIpLcPKANB58BjZo06hDSW24igRZF6fAX/oeSFLWxz+c4
         jxNRsBoXvAhS+byGWGovg+sbiRETYAc0nsAWt6q4ejx4M/15+7xRxldpHXRoBIu2hU
         gbO80I7nbEv+IJy5LNoQp68q9vM9aiLnuu1vN5ekzOuCk1+cbugo906ytZ5SwnqL/f
         7YUv53vBpGAog==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     ManYi Li <limanyi@uniontech.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 1/4] scsi: sr: Return appropriate error code when disk is ejected
Date:   Mon, 28 Jun 2021 17:20:55 -0400
Message-Id: <20210628212059.43361-1-sashal@kernel.org>
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
index fd4b582110b2..77961f058367 100644
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

