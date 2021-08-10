Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D6C3E80DB
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236619AbhHJRxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:53:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235963AbhHJRvL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:51:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEC8B61351;
        Tue, 10 Aug 2021 17:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617381;
        bh=vWREjDAUBd+J8kl6nonl2vuQC8l+Y8Rc6HIwP/yVMbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X4kpF3uAhFh+CEKnpOLf2Nzm9remOJEnHXlrw3QY3EZpyJgN8tKLFm5EBZ+thQ6oG
         IPOs6/Egyw7WXmah4R575TJxMbw+sQJZ+TR6V1gSdCb9TvPq8HBOfZRrVnM3dEvY9s
         lyYJ6ge3mRxLsjASSnR4oR/Hzmu/vp7D71kIiJ9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Manyi <limanyi@uniontech.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 034/175] scsi: sr: Return correct event when media event code is 3
Date:   Tue, 10 Aug 2021 19:29:02 +0200
Message-Id: <20210810173002.082347297@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
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
index 1a94c7b1de2d..261d3663cbb7 100644
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



