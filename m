Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93FD010186F
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729224AbfKSFbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:31:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:50108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729220AbfKSFbM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:31:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4537D21939;
        Tue, 19 Nov 2019 05:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141471;
        bh=/NQtkOkpEuUWMY3f+/lnoDmUzsLbRI5O/I0APk7Ai9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tiobBttRtKMFCvipOYamelyteYdCMqCVODs8rtsl4svHHu7FthcU+xIzM974xJqKE
         ItcayawKcfM/kwjBqHQGtXuuuQwME7J+sUbFxqfaX7yrG5rHLmilfOwGcQnzjXqWFV
         kWLHt0Eea5XBWt4ZVTf//Ebmuf0k8OaGXy5Z2BJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <quinn.tran@cavium.com>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 171/422] scsi: qla2xxx: Terminate Plogi/PRLI if WWN is 0
Date:   Tue, 19 Nov 2019 06:16:08 +0100
Message-Id: <20191119051409.500973773@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

[ Upstream commit aa9e6d7b9643fc50a88c7b7aa1e34be8dc032749 ]

When driver receive PLOGI/PRLI from FW, the WWPN value will be provided.  If
it is not, then driver will terminate it.  The WWPN allows driver to locate
the session or create a new session.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_target.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index d6dc320f81a7a..078d124533247 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4703,6 +4703,12 @@ static int qlt_handle_login(struct scsi_qla_host *vha,
 		sess = qlt_find_sess_invalidate_other(vha, wwn,
 		    port_id, loop_id, &conflict_sess);
 		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
+	} else {
+		ql_dbg(ql_dbg_disc, vha, 0xffff,
+		    "%s %d Term INOT due to WWN=0 lid=%d, NportID %06X ",
+		    __func__, __LINE__, loop_id, port_id.b24);
+		qlt_send_term_imm_notif(vha, iocb, 1);
+		goto out;
 	}
 
 	if (IS_SW_RESV_ADDR(port_id)) {
-- 
2.20.1



