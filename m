Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABDE3C24C4
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbhGINZB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:25:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232512AbhGINYq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:24:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2D8F6128A;
        Fri,  9 Jul 2021 13:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836922;
        bh=UCjLACdLHucLeCarpSYw3bXTOALiC6etRLDJz7CUIoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SwPHjhuflpaYg3d1mEXeel4PbayCEirMJZmxKpVhbtTK05P9CEH4uaPYDX8bnWenc
         3bvwx2+d+KnsEbFydQB+PYbg5ms4OYVkQUOogB7jORPrrylMT/OnRLzQyMLNvyqTpj
         tBXfxcYey+cSgiPdBjRVVI8IcUy8PffDFQXCikOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ManYi Li <limanyi@uniontech.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 22/34] scsi: sr: Return appropriate error code when disk is ejected
Date:   Fri,  9 Jul 2021 15:20:38 +0200
Message-Id: <20210709131656.482199541@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131644.969303901@linuxfoundation.org>
References: <20210709131644.969303901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 45c8bf39ad23..acf0c244141f 100644
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



