Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD093B6A51
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 23:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237946AbhF1V0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 17:26:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:36250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238005AbhF1VXp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 17:23:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78D9161D01;
        Mon, 28 Jun 2021 21:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624915272;
        bh=UCjLACdLHucLeCarpSYw3bXTOALiC6etRLDJz7CUIoQ=;
        h=From:To:Cc:Subject:Date:From;
        b=SHy3d9mGEwVlXDK28Sa6jRxqHd2sImUuZhtJZ3ThI3GWwAXVhFLE14rK8Iq3GK+Bj
         pIAIsEQWrDUzwWT1e4UNtxvbs+ap+quSVqS/ZsbhW62ixtysfxAx5RHlkO3/DVz31Q
         yAYmVPKrWJUiPhxhPgbtDuFVur96OFSPw4oOGEjU7rpyoIcTmitC8JRuNaPB5RgmmN
         cyzmnRyArKWpaGOf2YH5R7xqGe92ewWcSQb6NhcIglzXmFnk0+Q+1IHgPzlYPwBKbV
         E8/G0LoiXMx6Q+wjPwwVatfngcV5xh2zxQ751RtsIwosoF8qsQ+fU9uLsznffYryBF
         vBddgWA2t/NcA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     ManYi Li <limanyi@uniontech.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 1/2] scsi: sr: Return appropriate error code when disk is ejected
Date:   Mon, 28 Jun 2021 17:21:09 -0400
Message-Id: <20210628212110.43532-1-sashal@kernel.org>
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

