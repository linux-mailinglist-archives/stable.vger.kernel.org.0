Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054C23BBBCE
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 13:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbhGELCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 07:02:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231314AbhGELCh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 07:02:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E532F61416;
        Mon,  5 Jul 2021 10:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625482800;
        bh=p88Dfq2ocF55CXnAHK+P/uCHyqbNSfZBQjPxRzvgz6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ODfwrRLXheVfMpi89ljmhZK29jBtZWWp/7shnK/YsOxjOWtTER5LUZLrOGyryqA8o
         9ORt5nYBKnmfW6U3ZvKL2oobQHm9TvumiJRcr6tZXNScSZ7NKwKY8h+NK6at8wQQhn
         5yVHGu2ALYdMaAKDGhy55eu7mJHjeDbrMJHQxARrFs8bGTnMwXK+K5d49hKrLj6wBO
         5JCZjpVUHv6ha00mLEkdmNg/km4cWQqaYH6cy9oKwfK2cd9OM8GkiNqkZFi6Ypfr8q
         R8bjlD8HhwKrwDcs2U7+Vb8hvnM57GJOHBj+aYpxx45lRmN0vhDL7ku8NSsDbVgls/
         9pqUkGNu+JmQA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     ManYi Li <limanyi@uniontech.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1/7] scsi: sr: Return appropriate error code when disk is ejected
Date:   Mon,  5 Jul 2021 06:59:51 -0400
Message-Id: <20210705105957.1513284-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705105957.1513284-1-sashal@kernel.org>
References: <20210705105957.1513284-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.48-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.48-rc1
X-KernelTest-Deadline: 2021-07-07T10:59+00:00
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

