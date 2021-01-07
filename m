Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27BC52ED230
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728545AbhAGObP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:31:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:45220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbhAGObO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:31:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A93CC2333E;
        Thu,  7 Jan 2021 14:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029834;
        bh=SzRj85u4EWvnhcMiIPnewAZwC7JLCp9Z8H5oIlYyk/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d9xLdCNQQSMp/b7UOAZEIiPKAZTUtJgNAvq79ouuBauizbnGrShheM5lR7P9Pl/l9
         zDYfcNpAv1OPfC0KEVSlt21CuYXW5VFNWBv2/0E5go6Na9xGbDeU6SNrWq8w+jM/Uu
         nebt5Nw0L4kT+m7b5zxuKGl9p26ixC2Xn9APKSEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 10/29] s390/dasd: fix hanging device offline processing
Date:   Thu,  7 Jan 2021 15:31:25 +0100
Message-Id: <20210107143054.403017970@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107143052.973437064@linuxfoundation.org>
References: <20210107143052.973437064@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Haberland <sth@linux.ibm.com>

[ Upstream commit 658a337a606f48b7ebe451591f7681d383fa115e ]

For an LCU update a read unit address configuration IO is required.
This is started using sleep_on(), which has early exit paths in case the
device is not usable for IO. For example when it is in offline processing.

In those cases the LCU update should fail and not be retried.
Therefore lcu_update_work checks if EOPNOTSUPP is returned or not.

Commit 41995342b40c ("s390/dasd: fix endless loop after read unit address configuration")
accidentally removed the EOPNOTSUPP return code from
read_unit_address_configuration(), which in turn might lead to an endless
loop of the LCU update in offline processing.

Fix by returning EOPNOTSUPP again if the device is not able to perform the
request.

Fixes: 41995342b40c ("s390/dasd: fix endless loop after read unit address configuration")
Cc: stable@vger.kernel.org #5.3
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Reviewed-by: Jan Hoeppner <hoeppner@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/block/dasd_alias.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/block/dasd_alias.c b/drivers/s390/block/dasd_alias.c
index 487b16ace0060..0f70cae1c01e3 100644
--- a/drivers/s390/block/dasd_alias.c
+++ b/drivers/s390/block/dasd_alias.c
@@ -462,11 +462,19 @@ static int read_unit_address_configuration(struct dasd_device *device,
 	spin_unlock_irqrestore(&lcu->lock, flags);
 
 	rc = dasd_sleep_on(cqr);
-	if (rc && !suborder_not_supported(cqr)) {
+	if (!rc)
+		goto out;
+
+	if (suborder_not_supported(cqr)) {
+		/* suborder not supported or device unusable for IO */
+		rc = -EOPNOTSUPP;
+	} else {
+		/* IO failed but should be retried */
 		spin_lock_irqsave(&lcu->lock, flags);
 		lcu->flags |= NEED_UAC_UPDATE;
 		spin_unlock_irqrestore(&lcu->lock, flags);
 	}
+out:
 	dasd_kfree_request(cqr, cqr->memdev);
 	return rc;
 }
-- 
2.27.0



