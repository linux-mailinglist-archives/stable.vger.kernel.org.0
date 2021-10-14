Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1D0A42DC82
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 16:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbhJNO7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 10:59:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232380AbhJNO6q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 10:58:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE7A861214;
        Thu, 14 Oct 2021 14:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223401;
        bh=Y4qvT3j+35BeZRrB7t9DXOF+Cor8kWff8qHy8u8g3/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i0Sni+tIXCz9TFB/ggg16Bu8nLMwp1IRGf/IG2HVcdFwDDYwo4b1v3B/WSjqGsObZ
         UYYqI5r/xLxZfzQD5A5oaeBsgTwhLfy5ioY0M6Z/Wtgll8qQS5UJmcvnfZ9I6ByYU1
         6YTCK2OBnL4UD9q0XUOaKYv9jzUj+ruCoGzaDePc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 23/25] scsi: ses: Fix unsigned comparison with less than zero
Date:   Thu, 14 Oct 2021 16:53:54 +0200
Message-Id: <20211014145208.325960664@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145207.575041491@linuxfoundation.org>
References: <20211014145207.575041491@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 69046d342bc5..39396548f9b5 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -120,7 +120,7 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 static int ses_send_diag(struct scsi_device *sdev, int page_code,
 			 void *buf, int bufflen)
 {
-	u32 result;
+	int result;
 
 	unsigned char cmd[] = {
 		SEND_DIAGNOSTIC,
-- 
2.33.0



