Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541F0205E9F
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390422AbgFWUY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:24:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390419AbgFWUY0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:24:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3DFD2070E;
        Tue, 23 Jun 2020 20:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943866;
        bh=xw5JK02itgcMsIpRhkXA2usII7j09CBG0B41PyTPPik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oxzdzA+j5zqNzNRjmTxNrCe9S4vIp+oU2M64RHPepbUamnMSRyXKF1TmkqhsjCYrL
         EFIB6vXJr5L3vgT5ETj8u4rMMfQgmAfTsPN00Xkx9RmsfG8R/c4eMOOJ8wwD01yJ+Z
         K8Q6KVoF9B/ys6Fb+4S9J0uE5UMLjujB486sUyK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyrel Datwyler <tyreld@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 081/314] scsi: ibmvscsi: Dont send host info in adapter info MAD after LPM
Date:   Tue, 23 Jun 2020 21:54:36 +0200
Message-Id: <20200623195342.729019242@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 59f0f1030c54a..c5711c659b517 100644
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



