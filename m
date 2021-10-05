Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA5574228D9
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235760AbhJENyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:54:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235185AbhJENxS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:53:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9EEA615E3;
        Tue,  5 Oct 2021 13:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633441887;
        bh=IrqeVLXJRZKyB/ZBKpBviLDofZGUINKKSezgTapA/UI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OmvdwBLm4spccishN1oP0k1NboTJ9xFB17xvvM86BLx5fgak9RRq7hxW2CNj7M4LC
         Ax/wZ5dnMfITvm7y46nTZrOwR6Pfr9KP1EFxQ1XDqj+ZibjyvPjjaKsbb7Ki4cAPst
         yFCgnU5r4rrFO+jFrDbwR4shDMNKHf16kmL/7ZWHTxsKFuJYIdqwlgjXXWGElynwfZ
         O+5Q3lt+BtzlNqTjNOYiXaKMVqlaLfBCe3+k7wFZCQID68ofKsfPPrKJ14wYq2j8+1
         mrcyHLE7F9cUK3a4DENJbsyr8YTn3jD/WweWTYf6la4MrbvRcursy9CgTlU1hPHpDv
         zWHmJesbdDqnw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 33/40] scsi: ses: Fix unsigned comparison with less than zero
Date:   Tue,  5 Oct 2021 09:50:12 -0400
Message-Id: <20211005135020.214291-33-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135020.214291-1-sashal@kernel.org>
References: <20211005135020.214291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit dd689ed5aa905daf4ba4c99319a52aad6ea0a796 ]

Fix the following coccicheck warning:

./drivers/scsi/ses.c:137:10-16: WARNING: Unsigned expression compared
with zero: result > 0.

Link: https://lore.kernel.org/r/1632477113-90378-1-git-send-email-jiapeng.chong@linux.alibaba.com
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ses.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index c2afba2a5414..d155a7329b07 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -111,7 +111,7 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 static int ses_send_diag(struct scsi_device *sdev, int page_code,
 			 void *buf, int bufflen)
 {
-	u32 result;
+	int result;
 
 	unsigned char cmd[] = {
 		SEND_DIAGNOSTIC,
-- 
2.33.0

