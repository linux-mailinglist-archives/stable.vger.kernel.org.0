Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17BF73EB7FD
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241672AbhHMPK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:10:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241548AbhHMPKC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:10:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9458F610CC;
        Fri, 13 Aug 2021 15:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867375;
        bh=Jo8QVitmMw0Sk3mcUaWlOWyNbU+LQqm0Oxvf44cN4Pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eAJVLBMGyaZVSkyatdLBfvjCxwk+pWuUookagSUimM5aSfKCzTU95Fpg8aCDuxsvw
         HS/RJysJKoBRS4bxaXMml1yLWh6YMhIGbJj/O7rLfuja5IXnjR2H7xHc6E3DKQoJHz
         TgH7Aqd9CXTYPUSqw7+D2pxDbPZSANJZW9oos6og=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Manyi <limanyi@uniontech.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 02/30] scsi: sr: Return correct event when media event code is 3
Date:   Fri, 13 Aug 2021 17:06:30 +0200
Message-Id: <20210813150522.526410651@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150522.445553924@linuxfoundation.org>
References: <20210813150522.445553924@linuxfoundation.org>
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
index 5e51a39a0c27..9b63e46edffc 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -217,7 +217,7 @@ static unsigned int sr_get_events(struct scsi_device *sdev)
 	else if (med->media_event_code == 2)
 		return DISK_EVENT_MEDIA_CHANGE;
 	else if (med->media_event_code == 3)
-		return DISK_EVENT_EJECT_REQUEST;
+		return DISK_EVENT_MEDIA_CHANGE;
 	return 0;
 }
 
-- 
2.30.2



