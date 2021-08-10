Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC26B3E7FA0
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbhHJRlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:41:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:59194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233469AbhHJRjt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:39:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34BCA611C6;
        Tue, 10 Aug 2021 17:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617056;
        bh=cxvJByPagMpfRpFA5lFwdQ7dBNJGS4nUR3J6IK7apTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cYsVRVBbGwlU6p9IH0IZdsikzY8AuHhs37Hr/iYUIi85tPGrb1VCDx5AsPjRH9NX7
         ntNDW6Pb8XFMT0HlNB51HKBG8zAOmOWMjn/uMkh5hc8KpkvryKpElAvJQ5HMedqWFm
         esjkWgcuMqdffNXtTAn1QOMnGdBo08xyQOtyB+ZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Manyi <limanyi@uniontech.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 025/135] scsi: sr: Return correct event when media event code is 3
Date:   Tue, 10 Aug 2021 19:29:19 +0200
Message-Id: <20210810172956.529704096@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Manyi <limanyi@uniontech.com>

[ Upstream commit 5c04243a56a7977185b00400e59ca7e108004faf ]

Media event code 3 is defined in the MMC-6 spec as follows:

  "MediaRemoval: The media has been removed from the specified slot, and
   the Drive is unable to access the media without user intervention. This
   applies to media changers only."

This indicated that treating the condition as an EJECT_REQUEST was
appropriate. However, doing so had the unfortunate side-effect of causing
the drive tray to be physically ejected on resume. Instead treat the event
as a MEDIA_CHANGE request.

Fixes: 7dd753ca59d6 ("scsi: sr: Return appropriate error code when disk is ejected")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=213759
Link: https://lore.kernel.org/r/20210726114913.6760-1-limanyi@uniontech.com
Signed-off-by: Li Manyi <limanyi@uniontech.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 726b7048a767..4cb4ab9c6137 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -221,7 +221,7 @@ static unsigned int sr_get_events(struct scsi_device *sdev)
 	else if (med->media_event_code == 2)
 		return DISK_EVENT_MEDIA_CHANGE;
 	else if (med->media_event_code == 3)
-		return DISK_EVENT_EJECT_REQUEST;
+		return DISK_EVENT_MEDIA_CHANGE;
 	return 0;
 }
 
-- 
2.30.2



