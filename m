Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187642ED201
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728822AbhAGOQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:16:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:38992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727673AbhAGOQs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:16:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EA932333E;
        Thu,  7 Jan 2021 14:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610028944;
        bh=gqNFQm2+DbRwmiPRjBDtcYpaQD4m2cK6FFMB1yO9f44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lCyMEBWXe8kIVkLbRKWROX4SpVbP/TLdn4qI29rd9oDXBBkRGwIPP2R2vgjINi8KJ
         GnS76bQjOcpRjMuXsLfoXR05NSpTxsBlYMSAKbS8rKhFKTDlO1waUC2G+HtaZsv1qV
         Yprj0Gh5/9h0zY1OgCBb9fSmAhznYu559kv7ZZNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 07/19] s390/dasd: fix hanging device offline processing
Date:   Thu,  7 Jan 2021 15:16:32 +0100
Message-Id: <20210107140827.922950451@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107140827.584658199@linuxfoundation.org>
References: <20210107140827.584658199@linuxfoundation.org>
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
index 89b708135000c..03543c0a2dd0f 100644
--- a/drivers/s390/block/dasd_alias.c
+++ b/drivers/s390/block/dasd_alias.c
@@ -475,11 +475,19 @@ static int read_unit_address_configuration(struct dasd_device *device,
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



