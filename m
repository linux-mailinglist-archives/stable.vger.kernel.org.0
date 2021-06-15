Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A573A8496
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbhFOPvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:51:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:45314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231941AbhFOPvD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:51:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43FA1614A7;
        Tue, 15 Jun 2021 15:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772139;
        bh=vM6v0CyRahQxZxOVgXeP95P1j5Mm9X4FoDH590B7kFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sR5b2RgZd0zmX5BHjWet86rVp/HlVGO+wk2p4RXBo3xRvBfw9xH9qz1UxrxKg+qGI
         e4Wqe9iSintXOHG1guWg90LYbwXck1dK4JWbtGgYMvk10AEvzynY98amLGFtlBhVn/
         4I3rcLjcoLk4bH92XKRY6Qewg81bL2CHYEbDG5RVzUwaLeRwXhZpsrmLlUZs/gHdKG
         WfKS4Id2qO32qJGbJnvEdKBr4g4xExUI1iN9m+ginMQvLEKHP9cacQCto5LzNoTlzw
         13xus3PEtHKSM0LkcJHyahzu+scXqzUUg7hbHzC1mHgDF1EmORsWvI1JIF/3lMX7e/
         88mK7rE8RU9zw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 27/33] scsi: core: Only put parent device if host state differs from SHOST_CREATED
Date:   Tue, 15 Jun 2021 11:48:18 -0400
Message-Id: <20210615154824.62044-27-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615154824.62044-1-sashal@kernel.org>
References: <20210615154824.62044-1-sashal@kernel.org>
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
index a64d0c6f1c4a..b93dd8ef4ac8 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -347,7 +347,7 @@ static void scsi_host_dev_release(struct device *dev)
 
 	ida_simple_remove(&host_index_ida, shost->host_no);
 
-	if (parent)
+	if (shost->shost_state != SHOST_CREATED)
 		put_device(parent);
 	kfree(shost);
 }
-- 
2.30.2

