Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45A81F7DDC
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfKKSy7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:54:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:51466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729539AbfKKSy6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:54:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21008204EC;
        Mon, 11 Nov 2019 18:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498497;
        bh=pUWKp8naBDs9sjU+E0WOyTLJfsG5GyDZCVxfypsKw5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fk0sUEygIIdxD3eOQCSVH82w9bSMi9lX+BtZH7o5Wr7WThLu35yNx5vyBPYcC67f+
         TolrLnQ6KeShtPRHZ1B2LB8YVZQzXeFBJbd7tR9L0ioP6Nx5IAT31wi4D3tDnIrhc4
         Y79S/1h/vndQPzTSpgfVy+NLtG6m7vn2+08Xv7IE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 136/193] scsi: sd: define variable dif as unsigned int instead of bool
Date:   Mon, 11 Nov 2019 19:28:38 +0100
Message-Id: <20191111181511.204518731@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

[ Upstream commit 0cf9f4e547cebb5f5d2d046437c71ddcc8ea4a39 ]

Variable dif in function sd_setup_read_write_cmnd() is the return value of
function scsi_host_dif_capable() which returns dif capability of disks.  If
define it as bool, even for the disks which support DIF3, the function
still return dif=1, which causes IO error. So define variable dif as
unsigned int instead of bool.

Fixes: e249e42d277e ("scsi: sd: Clean up sd_setup_read_write_cmnd()")
Link: https://lore.kernel.org/r/1571725628-132736-1-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2d77f32e13d5e..9dc367e2e742d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1166,11 +1166,12 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 	sector_t lba = sectors_to_logical(sdp, blk_rq_pos(rq));
 	sector_t threshold;
 	unsigned int nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
-	bool dif, dix;
 	unsigned int mask = logical_to_sectors(sdp, 1) - 1;
 	bool write = rq_data_dir(rq) == WRITE;
 	unsigned char protect, fua;
 	blk_status_t ret;
+	unsigned int dif;
+	bool dix;
 
 	ret = scsi_init_io(cmd);
 	if (ret != BLK_STS_OK)
-- 
2.20.1



