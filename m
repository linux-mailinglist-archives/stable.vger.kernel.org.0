Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9B83C30A7
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235194AbhGJCgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:36:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235699AbhGJCe7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:34:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E06E6613DF;
        Sat, 10 Jul 2021 02:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884334;
        bh=PvYicS1MzkHzIS9KQy8XMlGrWB35iLyEPJpc6q/fTNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S/wen5Xz8UU9bJYNHtHzRRPrL96Ov9X+IppftqWnuTcjVZ9bSE9bs3rxlS+im3+Fi
         6p9u7gOdD+UsZbP37mgZiM8AbJ9gQ5TvQGe63aQi2+6BXkoEBNs+IszgZnR+3w9FAh
         BGqZNz581dBK/C0hc/Ikmu7b5kwL0En7+VQes20Yhu+kLGpwkhUOxLZplptHzO1Hrp
         za9XctHprQG2jMctN3XEnCAU+ZTbfPmsvZUmMpxiqvEL00lYgZeghg4Pd7DoGg1FVe
         x2rdxRDMi1fzHf5DRzYkvMIVW1E87o1X3g0FFQW48036iI+oCvDGoIW6ezdblUuubD
         4eDX8YfbysTWg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Garry <john.garry@huawei.com>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 08/39] scsi: core: Cap scsi_host cmd_per_lun at can_queue
Date:   Fri,  9 Jul 2021 22:31:33 -0400
Message-Id: <20210710023204.3171428-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023204.3171428-1-sashal@kernel.org>
References: <20210710023204.3171428-1-sashal@kernel.org>
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
index fa03be813f2c..9462564b2147 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -218,6 +218,9 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
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

