Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E866C3CDF66
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344050AbhGSPKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:10:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344689AbhGSPH3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:07:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FC4760FD7;
        Mon, 19 Jul 2021 15:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709665;
        bh=iifnX91AN+L2jLWiw4nnHxUcq6QolYgUh6Mjh5RIBdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sag/CqF36LXrylHrL/ay/u5V/od+g5MTZwGeW+Uxurnt3G/pbHyJGlyRPgnoHHf9/
         UJbIQNTAW2hB5HHpwwUD7gHlVG5W+O1anFOyTupY8K3Cz/D4sVxEBADHlIVQfvU1h4
         oNGB+S7qSfzfdX0043U4/nP9Ihx+AnXOLyXPxnH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 022/149] scsi: core: Cap scsi_host cmd_per_lun at can_queue
Date:   Mon, 19 Jul 2021 16:52:10 +0200
Message-Id: <20210719144906.767188521@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

[ Upstream commit ea2f0f77538c50739b9fb4de4700cee5535e1f77 ]

The sysfs handling function sdev_store_queue_depth() enforces that the sdev
queue depth cannot exceed shost can_queue. The initial sdev queue depth
comes from shost cmd_per_lun. However, the LLDD may manually set
cmd_per_lun to be larger than can_queue, which leads to an initial sdev
queue depth greater than can_queue.

Such an issue was reported in [0], which caused a hang. That has since been
fixed in commit fc09acb7de31 ("scsi: scsi_debug: Fix cmd_per_lun, set to
max_queue").

Stop this possibly happening for other drivers by capping shost cmd_per_lun
at shost can_queue.

[0] https://lore.kernel.org/linux-scsi/YHaez6iN2HHYxYOh@T590/

Link: https://lore.kernel.org/r/1621434662-173079-1-git-send-email-john.garry@huawei.com
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hosts.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 119c292cdb8f..7c736e4ddafe 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -219,6 +219,9 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 		goto fail;
 	}
 
+	shost->cmd_per_lun = min_t(short, shost->cmd_per_lun,
+				   shost->can_queue);
+
 	error = scsi_init_sense_cache(shost);
 	if (error)
 		goto fail;
-- 
2.30.2



