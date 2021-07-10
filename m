Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8ED03C2EEA
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234930AbhGJC3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:29:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:41906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234004AbhGJC2K (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:28:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAE9E613FC;
        Sat, 10 Jul 2021 02:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883904;
        bh=Hy9kKlJWwUkCQ/3hWKbyzb+3jJ97A1OvJQWsXTDd0n8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WlSlfqV7/NpWUWDLyT6Hkww0JTNMnbRrZ0xWDRmC+T4Umc26HqStEUpE7WlODfX1G
         xtiroG/ZVAT/MuOX2iwlB3CWLS9aJCC4AulnSr0MYRnWxTOPdU22ZzoQnxmRU7fqa+
         OBa8nM8yIpuyavxRaNIdPiv8oaBxzxBqDRxdsjMyEP349QL0H81fgOYJlDE6Xx1zUC
         G5Pn/9yhc6iept/Iodr2MJUjbYd/WYhFFbUEegcyXFMi9jxP5yYBVgjbqrudYXTwY4
         YGWuIfXco7mPqeTUZ4FNyiV8kiabTeMgYcLLEo46uOrY1jmFNx19q6w1HQIuPq/Qqx
         2AUBwPf7QWLWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Garry <john.garry@huawei.com>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 27/93] scsi: core: Cap scsi_host cmd_per_lun at can_queue
Date:   Fri,  9 Jul 2021 22:23:21 -0400
Message-Id: <20210710022428.3169839-27-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022428.3169839-1-sashal@kernel.org>
References: <20210710022428.3169839-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index b93dd8ef4ac8..ce34da53af1b 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -220,6 +220,9 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
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

