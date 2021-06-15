Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5F23A8565
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbhFOPzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:55:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232614AbhFOPxP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:53:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B94326148E;
        Tue, 15 Jun 2021 15:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772233;
        bh=BXqbO/3hSN0O+87xxgMK2Wo2HMEZbe4wHZhYsHfIvJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NdPplwchECYwfvm8O0XamMhNRhuwNwOjjdRbyNm+BLFOjkbZh6DUoBobuxNd3up11
         sL3lOCa3oAJSZPz2fRQpPOJB9J7yuoogZ++6SDzXSVsP0BVENJOrUGOTECChzoJorL
         LCMu8E/OOIfcwEeGDaAY5ViOYLv0+30Cize7ZoYi8w1uPE2BEiQDEJqd9fIS8jfVL9
         ZiN698v39tNwYFvEce6QISDEMMhofzs5yXN+BNBHTOiu7kBFPV4IFn3Yld0WV4de58
         +PlxX4uLWFsUboALgN3LsVXe9m4YrcOITQA5bmMhw4lFf/RAqaEwgYWF2gTL668P+h
         HFoe9EmT86/mw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 4/8] scsi: core: Only put parent device if host state differs from SHOST_CREATED
Date:   Tue, 15 Jun 2021 11:50:23 -0400
Message-Id: <20210615155027.63048-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615155027.63048-1-sashal@kernel.org>
References: <20210615155027.63048-1-sashal@kernel.org>
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
index ff92df3fe401..5788a2ce3571 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -355,7 +355,7 @@ static void scsi_host_dev_release(struct device *dev)
 
 	ida_simple_remove(&host_index_ida, shost->host_no);
 
-	if (parent)
+	if (shost->shost_state != SHOST_CREATED)
 		put_device(parent);
 	kfree(shost);
 }
-- 
2.30.2

