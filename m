Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1C81FE828
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbgFRBKc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:10:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728521AbgFRBKa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:10:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9272D2089D;
        Thu, 18 Jun 2020 01:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442629;
        bh=IYJNKOK5cBTrSDuxAQOv5bJd8WQAogwI6p6Osfy88qk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QKKuKD5bI6pyGPFnYRfaVrAXpjoxsFVl31K+EykBKNhfhsIp1Dew9zV9pyfl+II+x
         Jrdo5e7eAc8fOnYsYgJWvdRgb2sGXz/kj5q65YjRuC/zB7mt6kbjn0O4urSW1Nq1vt
         Med7Sif/1pPAw+/yqZfdAIG6rkJxkSkngtrQOG1Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.7 107/388] scsi: ibmvscsi: Don't send host info in adapter info MAD after LPM
Date:   Wed, 17 Jun 2020 21:03:24 -0400
Message-Id: <20200618010805.600873-107-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyrel Datwyler <tyreld@linux.ibm.com>

[ Upstream commit 4919b33b63c8b69d8dcf2b867431d0e3b6dc6d28 ]

The adapter info MAD is used to send the client info and receive the host
info as a response. A persistent buffer is used and as such the client info
is overwritten after the response. During the course of a normal adapter
reset the client info is refreshed in the buffer in preparation for sending
the adapter info MAD.

However, in the special case of LPM where we reenable the CRQ instead of a
full CRQ teardown and reset we fail to refresh the client info in the
adapter info buffer. As a result, after Live Partition Migration (LPM) we
erroneously report the host's info as our own.

[mkp: typos]

Link: https://lore.kernel.org/r/20200603203632.18426-1-tyreld@linux.ibm.com
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 59f0f1030c54..c5711c659b51 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -415,6 +415,8 @@ static int ibmvscsi_reenable_crq_queue(struct crq_queue *queue,
 	int rc = 0;
 	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
 
+	set_adapter_info(hostdata);
+
 	/* Re-enable the CRQ */
 	do {
 		if (rc)
-- 
2.25.1

