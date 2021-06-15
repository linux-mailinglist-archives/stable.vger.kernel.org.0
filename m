Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF973A8585
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbhFOP4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:56:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232831AbhFOPyH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:54:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F7D9616EB;
        Tue, 15 Jun 2021 15:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772245;
        bh=obrXFzE0wTXwRUfTXhVvotpy5ciwL1FgcLyzysjYN7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F/gh5npAUmNmfk2cqNv2RXX/JzKTWb0pX0/yFl0I0mKC6pJSxTNpfNPll+HckYAsQ
         FwHfWEx0uUR99+40l0MCNYzvHGxNHr0khkvUQj67nW/uklaZNfXaDMvVtCB+5NJ3P7
         0HLYfFjKC3M1rsxxbwhlcQTFvVwjQoD6O3Kyal5D9WNWJClYNpPgDAdYkxP/H9CaZY
         PzMykw7hty5C0MI7Gk6fBtkDLT+V9Zq0cqGtlbSbC9S74GkTyOHXrNo6AgOxebiE1B
         1GeCfejrzrtitLlhmSo5jtShEnhMwpqlL9m0v5AOlRqV9wTvwp+e34ZFlWGqwgILrZ
         IkWqO0Hx31rQA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 4/5] scsi: core: Only put parent device if host state differs from SHOST_CREATED
Date:   Tue, 15 Jun 2021 11:50:38 -0400
Message-Id: <20210615155039.63348-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615155039.63348-1-sashal@kernel.org>
References: <20210615155039.63348-1-sashal@kernel.org>
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
index a44967436253..604cf3385aae 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -372,7 +372,7 @@ static void scsi_host_dev_release(struct device *dev)
 
 	ida_simple_remove(&host_index_ida, shost->host_no);
 
-	if (parent)
+	if (shost->shost_state != SHOST_CREATED)
 		put_device(parent);
 	kfree(shost);
 }
-- 
2.30.2

