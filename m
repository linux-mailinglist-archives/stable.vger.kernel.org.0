Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A913B6A57
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 23:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238051AbhF1V0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 17:26:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238037AbhF1VX4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 17:23:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01E4B61D09;
        Mon, 28 Jun 2021 21:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624915279;
        bh=2/6PFKcqQpIK27RimnGf9jRd+T7ijjCZEd7Fgyj2bVo=;
        h=From:To:Cc:Subject:Date:From;
        b=nIAt6OEOCY+emTKQo3q/H612YaKM0HN+IxynZFq7wRHB0VxCa7wxFMPcNMOLrr/GZ
         PVo9azW6ovK2vPaZrFs8NXPeNtYFkDTUj+7Lc+gQBh6MAa+X0nk8PFNrfBzYTn49t8
         3Kst5kuAsuPH7bR56fE9LpEgoo2WNZlGACphkCexLKHKdNyuR7DBa2m3yjvv8kJ5PM
         8RA0kjmOJPd+fYF6Gg4OlMZopvBjdFQXXHkY/z+94y/qMHxytqU291cDosnaOYKscD
         80rOR/tootg8S03Fpei2Xcq5C7dixphcfDMKqlvu8dg0aNkKTlkWFN2Lad+SzkE/Ni
         vISMaG14de7Zw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     ManYi Li <limanyi@uniontech.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 1/2] scsi: sr: Return appropriate error code when disk is ejected
Date:   Mon, 28 Jun 2021 17:21:16 -0400
Message-Id: <20210628212117.43676-1-sashal@kernel.org>
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
index 67a73ea0a615..5e51a39a0c27 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -216,6 +216,8 @@ static unsigned int sr_get_events(struct scsi_device *sdev)
 		return DISK_EVENT_EJECT_REQUEST;
 	else if (med->media_event_code == 2)
 		return DISK_EVENT_MEDIA_CHANGE;
+	else if (med->media_event_code == 3)
+		return DISK_EVENT_EJECT_REQUEST;
 	return 0;
 }
 
-- 
2.30.2

