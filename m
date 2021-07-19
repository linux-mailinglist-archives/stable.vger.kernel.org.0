Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71AA13CE0A9
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346660AbhGSPRs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:17:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:48928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346391AbhGSPOk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:14:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E86A36127C;
        Mon, 19 Jul 2021 15:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710063;
        bh=/Ywzl3YnQBCIkG6s/ugnov4Z859kjCR/5Z0M6eTuF58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MOpaXoextBWnjqSHaFdJTwNgoFphu+fEA28yLbWt78633R6ov4Q+rsfLOLYtEfDXC
         oMXt8h/5d4/Oxep12oL17CJFUmlrQHMaBmIWHgKG2XOrlGr2c2blX/EREXIyXSlHNK
         idANIXKJM+jFZGtwpigrp7X79d3/u+PhFpNYPew4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manish Rangankar <mrangankar@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/243] scsi: qedi: Fix null ref during abort handling
Date:   Mon, 19 Jul 2021 16:51:29 +0200
Message-Id: <20210719144942.854998522@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 5777b7f0f03ce49372203b6521631f62f2810c8f ]

If qedi_process_cmd_cleanup_resp finds the cmd it frees the work and sets
list_tmf_work to NULL, so qedi_tmf_work should check if list_tmf_work is
non-NULL when it wants to force cleanup.

Link: https://lore.kernel.org/r/20210525181821.7617-20-michael.christie@oracle.com
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedi/qedi_fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 440ddd2309f1..cf57b4e49700 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -1453,7 +1453,7 @@ abort_ret:
 
 ldel_exit:
 	spin_lock_bh(&qedi_conn->tmf_work_lock);
-	if (!qedi_cmd->list_tmf_work) {
+	if (qedi_cmd->list_tmf_work) {
 		list_del_init(&list_work->list);
 		qedi_cmd->list_tmf_work = NULL;
 		kfree(list_work);
-- 
2.30.2



