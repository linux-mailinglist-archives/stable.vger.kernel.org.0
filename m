Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C69B0113377
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731517AbfLDSLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:11:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:40200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731005AbfLDSLt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:11:49 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38CE120675;
        Wed,  4 Dec 2019 18:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575483108;
        bh=scB8O+eVXyBPc4/vjx0Hl/m2poIpD1+Ps8hKHZnlgZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2A5RcHXxm5OnqmYRZ/1R4tCfs9y5fuA/LY7NkUUPp5l/ZTpEEtzkAXDyImTOOPMv7
         HT1bm7wcSptHsFPjTQDrxXMMnXVnXEIiL4HfERrAuPRpVtAff4bf9euEtsZoNwJEJY
         X92LkEQsgUenu/TL/yscChNb1XOIjJHeDrUoOix0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Gorenko <sergeygo@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Laurence Oberman <loberman@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 055/125] RDMA/srp: Propagate ib_post_send() failures to the SCSI mid-layer
Date:   Wed,  4 Dec 2019 18:56:00 +0100
Message-Id: <20191204175322.319445733@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175308.377746305@linuxfoundation.org>
References: <20191204175308.377746305@linuxfoundation.org>
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
index 74de1ae48d4f7..af68be201c299 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2180,6 +2180,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 
 	if (srp_post_send(ch, iu, len)) {
 		shost_printk(KERN_ERR, target->scsi_host, PFX "Send failed\n");
+		scmnd->result = DID_ERROR << 16;
 		goto err_unmap;
 	}
 
-- 
2.20.1



