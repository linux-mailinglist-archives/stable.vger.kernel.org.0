Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5475499B55
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1575137AbiAXVvE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:51:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1572925AbiAXVmv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:42:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CEC1C07A960;
        Mon, 24 Jan 2022 12:31:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8D58B81229;
        Mon, 24 Jan 2022 20:31:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A9DC340E7;
        Mon, 24 Jan 2022 20:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056294;
        bh=VJaVJEP2pnmf2hrnN+bNMJSsTptTmnZEfFyAfQj2aoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nfoAfanaQhu2XdVx2mXwzdcdZa/whSLkkt23ce/Vlmi5zlcuAuFJaSofgiDDybhEo
         WbPuiIdK15aKr4BR4DbIYjyZ98xYXmPRICZpsjezyu89pozuPXRFio2GKzDBGPW0Q4
         XT/3pXqKVqRJI88w5jKAExIptPY4me5i8C42wx2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        Bean Huo <beanhuo@micron.com>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 404/846] scsi: core: Fix scsi_device_max_queue_depth()
Date:   Mon, 24 Jan 2022 19:38:41 +0100
Message-Id: <20220124184114.906915693@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 4bc3bffc1a885eb5cb259e4a25146a4c7b1034e3 ]

The comment above scsi_device_max_queue_depth() and also the description of
commit ca4453213951 ("scsi: core: Make sure sdev->queue_depth is <=
max(shost->can_queue, 1024)") contradict the implementation of the function
scsi_device_max_queue_depth(). Additionally, the maximum queue depth of a
SCSI LUN never exceeds host->can_queue. Fix scsi_device_max_queue_depth()
by changing max_t() into min_t().

Link: https://lore.kernel.org/r/20211203231950.193369-2-bvanassche@acm.org
Fixes: ca4453213951 ("scsi: core: Make sure sdev->queue_depth is <= max(shost->can_queue, 1024)")
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Tested-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 291ecc33b1fe6..4fc9466d820a7 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -209,11 +209,11 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 
 
 /*
- * 1024 is big enough for saturating the fast scsi LUN now
+ * 1024 is big enough for saturating fast SCSI LUNs.
  */
 int scsi_device_max_queue_depth(struct scsi_device *sdev)
 {
-	return max_t(int, sdev->host->can_queue, 1024);
+	return min_t(int, sdev->host->can_queue, 1024);
 }
 
 /**
-- 
2.34.1



