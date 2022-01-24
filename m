Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A4649A336
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2366172AbiAXXw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:52:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1844845AbiAXXK3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:10:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA7BAC0A02A2;
        Mon, 24 Jan 2022 13:18:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73ADFB811A2;
        Mon, 24 Jan 2022 21:18:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E53C340E4;
        Mon, 24 Jan 2022 21:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059122;
        bh=sucli1En9E5u5z1IFzbW2r+q38biCmwZYxb30OlR7yk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kL7Fy10sQnqKnu4NDhJvaE4DxZVWJG24y0EnhlEPZd4Scp4yTesFemRAl3T3jkLlG
         KOEaEMlJ8iXvYzLxh71pXZhDBfCAEMO4p0QvJrUjQE6LOJf4v7vlixr9sC18COdzg3
         webFSXJboG2BrBFUN+SirGgk6w9GixAltKGXoBDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        Bean Huo <beanhuo@micron.com>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0478/1039] scsi: core: Fix scsi_device_max_queue_depth()
Date:   Mon, 24 Jan 2022 19:37:47 +0100
Message-Id: <20220124184141.339832686@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index f6af1562cba49..10e5bffc34aaf 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -201,11 +201,11 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 
 
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



