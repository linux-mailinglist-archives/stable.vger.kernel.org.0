Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76243BBBDF
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 13:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbhGELDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 07:03:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231450AbhGELDK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 07:03:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00996613D8;
        Mon,  5 Jul 2021 11:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625482833;
        bh=a46ov3xiFTEH9eZ2s2pmq+mMWtToy8dylQklgM1XSmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ONm158H1/lwWPgaR/5p/crhDLNbpy08vV8MB36VxTeniupGqcF1otQFEKwLUnOAcf
         4UHA6pgRZEzJJdLzUwhOiENjknt8S5iAaWPH6kdrNvc1u1q3s0eaLUErE+DBdHFdlq
         qrQt95PQODw90dppWpqg8LXPZl8eVztTYxiHSFafIwCFYR2OTqGKAGHgeGQvGIxgkg
         2yS07JQfzJVbjYrIPd/JviwH7I4dQUy+MJeaJUqVRCE5APP4kB/kAdRFciT515B2He
         7kGKI0VTG8PRdPtb/sgGbDlU1zNUcbPFXyIFgfdE1HBBzyzg+ih6OC0KyDKHC1SO0W
         l/IdMVfllfdlw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     ManYi Li <limanyi@uniontech.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 2/6] scsi: sr: Return appropriate error code when disk is ejected
Date:   Mon,  5 Jul 2021 07:00:25 -0400
Message-Id: <20210705110029.1513384-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705110029.1513384-1-sashal@kernel.org>
References: <20210705110029.1513384-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.130-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.130-rc1
X-KernelTest-Deadline: 2021-07-07T11:00+00:00
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

