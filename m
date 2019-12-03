Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCC8111CF2
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbfLCWsw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:48:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:39712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729497AbfLCWsw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:48:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDAA720881;
        Tue,  3 Dec 2019 22:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413331;
        bh=4UX+CxSvf6A7dtQ3cbPv4or4ULQtD3+cNrsIJxvQDp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k5cgL800+Q/g4TIROiUyoVbM4Un2il+dxRZeltF64+sLpxIGlb2iIqf+B9JDH4yvc
         p61XgBfsPhIvhWScP15YZH+LUX8CQLlAIqtymxjQ609TvZH3coF/UfXCQ17lOYmyif
         TxfoZ5ijEzxN40B6AAGjAnSKL8Ze0Gp/6cexSEYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Disseldorp <ddiss@suse.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Mike Christie <mchristi@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 047/321] scsi: target/tcmu: Fix queue_cmd_ring() declaration
Date:   Tue,  3 Dec 2019 23:31:53 +0100
Message-Id: <20191203223429.556192152@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit e7f411049f5164ee6db6c3434c07302846f09990 ]

This patch does not change any functionality but avoids that sparse
complains about the queue_cmd_ring() function and its callers.

Fixes: 6fd0ce79724d ("tcmu: prep queue_cmd_ring to be used by unmap wq")
Reviewed-by: David Disseldorp <ddiss@suse.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 7159e8363b83b..7ee0a75ce4526 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -962,7 +962,7 @@ static int add_to_qfull_queue(struct tcmu_cmd *tcmu_cmd)
  *  0 success
  *  1 internally queued to wait for ring memory to free.
  */
-static sense_reason_t queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, int *scsi_err)
+static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 {
 	struct tcmu_dev *udev = tcmu_cmd->tcmu_dev;
 	struct se_cmd *se_cmd = tcmu_cmd->se_cmd;
-- 
2.20.1



