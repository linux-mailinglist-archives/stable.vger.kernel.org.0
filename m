Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8893E7E73
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbhHJRd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:33:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232134AbhHJRdE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:33:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A900C61076;
        Tue, 10 Aug 2021 17:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616762;
        bh=Cr5UIL6t6XUtm8+tHN3SpOQIyrfTb7C8IGymWK1WlvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IJOEi39o6qVvvs23xgswzMKgAm1D5nT4XEX+ynE5uDXSU478Ya6SDR+u8dT9dVWTd
         lPndUWyYzqLie8Qbq7JmjgH5OEwTF9cdQt53WNxYiD1dOIbe/uKpKA2jHNQAGXLY6l
         r5o3i6iKZ+Jtfd+qDWfVpaOyJpjs7vZRxs6I/vO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Manyi <limanyi@uniontech.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 08/54] scsi: sr: Return correct event when media event code is 3
Date:   Tue, 10 Aug 2021 19:30:02 +0200
Message-Id: <20210810172944.463604205@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172944.179901509@linuxfoundation.org>
References: <20210810172944.179901509@linuxfoundation.org>
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
index acf0c244141f..84dd776d36c3 100644
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



