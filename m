Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC8502E40BC
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441205AbgL1OQd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:16:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:51598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441193AbgL1OQ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:16:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5893222B2A;
        Mon, 28 Dec 2020 14:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164947;
        bh=XN9h/n7d0dlZQAeGsr1xE1rKp7jDSmvSkmJ5je6ujrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cgMbLFB11iSaP4icLru3rQGYZL97zZK/HvuuxLuIBG6zCK1sdPXO59riZD5fXYUag
         dfasDqRvLWV344FRhEHWg4c7zeQBmT/ZuemJ6XW5d2nJtMZVh8MdBZcX9Nf9DYOSGY
         9cfJwCjTxmTA3VPhJ40IRUgTBNUW4d1vs/G6dWYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 356/717] scsi: qedi: Fix missing destroy_workqueue() on error in __qedi_probe
Date:   Mon, 28 Dec 2020 13:45:54 +0100
Message-Id: <20201228125038.075355614@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit 62eebd5247c4e4ce08826ad5995cf4dd7ce919dd ]

Add the missing destroy_workqueue() before return from __qedi_probe in the
error handling case when fails to create workqueue qedi->offload_thread.

Link: https://lore.kernel.org/r/20201109091518.55941-1-miaoqinglang@huawei.com
Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI driver framework.")
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedi/qedi_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 61fab01d2d527..f5fc7f518f8af 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2766,7 +2766,7 @@ retry_probe:
 			QEDI_ERR(&qedi->dbg_ctx,
 				 "Unable to start offload thread!\n");
 			rc = -ENODEV;
-			goto free_cid_que;
+			goto free_tmf_thread;
 		}
 
 		INIT_DELAYED_WORK(&qedi->recovery_work, qedi_recovery_handler);
@@ -2790,6 +2790,8 @@ retry_probe:
 
 	return 0;
 
+free_tmf_thread:
+	destroy_workqueue(qedi->tmf_thread);
 free_cid_que:
 	qedi_release_cid_que(qedi);
 free_uio:
-- 
2.27.0



