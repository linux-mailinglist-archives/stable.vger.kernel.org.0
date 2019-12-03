Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA8C1111D4C
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729972AbfLCWwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:52:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:44586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729965AbfLCWwB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:52:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4D8B20862;
        Tue,  3 Dec 2019 22:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413520;
        bh=2x30nZXFV0sUECMoA1FbWjsjuLWBzowiKIpvdc/4eTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wiUOMzY4Bwsone0Xway2YNoQb9d+12RIX2QlFoxvs6IKECkt/k24crpBuqKWgPyhs
         qB7jCEEWVZvGSnGHXYyIs9RVLnx+zxoqRnmR84KQuqiyj1SdJ0RH94p2oWfz/VwjzI
         j0LY2N6r3hYQTNFDd6IVxuBsnK6IfFxuUM2LXgxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Gorenko <sergeygo@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Laurence Oberman <loberman@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 158/321] RDMA/srp: Propagate ib_post_send() failures to the SCSI mid-layer
Date:   Tue,  3 Dec 2019 23:33:44 +0100
Message-Id: <20191203223435.363244872@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 2ee00f6a98c36f7e4ba07cc33f24cc5a69060cc9 ]

This patch avoids that the SCSI mid-layer keeps retrying forever if
ib_post_send() fails. This was discovered while testing immediate
data support and passing a too large num_sge value to ib_post_send().

Cc: Sergey Gorenko <sergeygo@mellanox.com>
Cc: Max Gurtovoy <maxg@mellanox.com>
Cc: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index bc6a44a16445c..03ee53adaacd2 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2357,6 +2357,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 
 	if (srp_post_send(ch, iu, len)) {
 		shost_printk(KERN_ERR, target->scsi_host, PFX "Send failed\n");
+		scmnd->result = DID_ERROR << 16;
 		goto err_unmap;
 	}
 
-- 
2.20.1



