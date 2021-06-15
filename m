Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3673A8511
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbhFOPxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:53:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231975AbhFOPwI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:52:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3E986191E;
        Tue, 15 Jun 2021 15:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772203;
        bh=QoilR5SZGcDiLfYtyO/1+0MNkQiN1hFEBm7sp/fX188=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VGps5kVZrR0Z3aPzCcWQ0wumf2+LNa9pqL+DJcTiS1C8Xct10P7lmbs3t78S1yT2F
         tgwql2A8Q+JLOkkSad8gG2JZbn82B8BIf5GIEFvyM+iYabzy70cTDMNCqrt9ZBr7yk
         jto+/6qTvdR8RtUywjrfUHTnwSOo4xYwNSRXm5nQ4hEOtujQTLpfTiF+DlkZMQJBxk
         gm1eptCWrpHnxoP93fPfiCa5n4iHbq25rVbnBhY4BacL13a0zuS9f4FH5XBLBQONjJ
         PG2B8QwBDGw/6bqW7zKsai6DhCBz6vAA5tQumFKwms3UD0U0FfcxlgrbNMSpq3NoWu
         zFdNg6PC+YVRw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 11/15] scsi: core: Only put parent device if host state differs from SHOST_CREATED
Date:   Tue, 15 Jun 2021 11:49:43 -0400
Message-Id: <20210615154948.62711-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615154948.62711-1-sashal@kernel.org>
References: <20210615154948.62711-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 1e0d4e6225996f05271de1ebcb1a7c9381af0b27 ]

get_device(shost->shost_gendev.parent) is called after host state has
switched to SHOST_RUNNING. scsi_host_dev_release() shouldn't release the
parent device if host state is still SHOST_CREATED.

Link: https://lore.kernel.org/r/20210602133029.2864069-5-ming.lei@redhat.com
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: John Garry <john.garry@huawei.com>
Cc: Hannes Reinecke <hare@suse.de>
Tested-by: John Garry <john.garry@huawei.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hosts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 3689b5e6afd5..ff36432c8fbc 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -344,7 +344,7 @@ static void scsi_host_dev_release(struct device *dev)
 
 	ida_simple_remove(&host_index_ida, shost->host_no);
 
-	if (parent)
+	if (shost->shost_state != SHOST_CREATED)
 		put_device(parent);
 	kfree(shost);
 }
-- 
2.30.2

