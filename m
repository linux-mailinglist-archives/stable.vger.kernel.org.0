Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E88A42DCF2
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 17:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbhJNPDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:03:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:45090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232480AbhJNPBl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:01:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6CCC611ED;
        Thu, 14 Oct 2021 14:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223542;
        bh=LylHOIffVcIqYdv0d4jIzGgDNgrPeLs5cf1VoCqVESU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ckU1gN4K+yhSrKFxmWW2ecb7oEinjCYapHhl8S+6MGUiYWZXtG2j4n/5sjVkfidjX
         JlaHnP+0wBkkaCF0m3gqs5YAr8uDc6AsDusMeOAa2RtUQkRX4nHfLi1hssQA0jDII2
         nHfKBLLujUwF+DWcUuUvRfOQVd/ezuYb6W2lYc/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 14/16] scsi: ses: Fix unsigned comparison with less than zero
Date:   Thu, 14 Oct 2021 16:54:17 +0200
Message-Id: <20211014145207.775550640@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145207.314256898@linuxfoundation.org>
References: <20211014145207.314256898@linuxfoundation.org>
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
index 43e682297fd5..0a1734f34587 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -118,7 +118,7 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 static int ses_send_diag(struct scsi_device *sdev, int page_code,
 			 void *buf, int bufflen)
 {
-	u32 result;
+	int result;
 
 	unsigned char cmd[] = {
 		SEND_DIAGNOSTIC,
-- 
2.33.0



