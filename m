Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D528A191A5
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbfEIS6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:58:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728450AbfEISxX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:53:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C7E620578;
        Thu,  9 May 2019 18:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557428002;
        bh=K6Crj5qIPiEOEheoj0CX+J/8kS3zZBd/dhua6TODmiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KZaFLQRAvtBYAh0VdEFQPHnXbrSF/fzR2bEtCLqNXo/XY0kh5Dkn/6TQ8E14YSkt/
         dG8tcuhTzbm+pFa586aWFeWV7/NVe6cvGOpoFWMIyrjp/V69wJGbeIlySa1EZVg4ba
         OTVR84CPd1YJcZ5aZaTCx/w3ZmHDm8R6ScQ3agxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qtran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Ewan D. Milne" <emilne@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.0 86/95] scsi: qla2xxx: Fix device staying in blocked state
Date:   Thu,  9 May 2019 20:42:43 +0200
Message-Id: <20190509181315.280012213@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qtran@marvell.com>

commit 2137490f2147a8d0799b72b9a1023efb012d40c7 upstream.

This patch fixes issue reported by some of the customers, who discovered
that after cable pull scenario the devices disappear and path seems to
remain in blocked state. Once the device reappears, driver does not seem to
update path to online. This issue appears because of the defer flag
creating race condition where the same session reappears.  This patch fixes
this issue by indicating SCSI-ML of device lost when
qlt_free_session_done() is called from qlt_unreg_sess().

Fixes: 41dc529a4602a ("qla2xxx: Improve RSCN handling in driver")
Signed-off-by: Quinn Tran <qtran@marvell.com>
Cc: stable@vger.kernel.org #4.19
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_target.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -977,6 +977,8 @@ void qlt_free_session_done(struct work_s
 		sess->send_els_logo);
 
 	if (!IS_SW_RESV_ADDR(sess->d_id)) {
+		qla2x00_mark_device_lost(vha, sess, 0, 0);
+
 		if (sess->send_els_logo) {
 			qlt_port_logo_t logo;
 
@@ -1157,8 +1159,6 @@ void qlt_unreg_sess(struct fc_port *sess
 	if (sess->se_sess)
 		vha->hw->tgt.tgt_ops->clear_nacl_from_fcport_map(sess);
 
-	qla2x00_mark_device_lost(vha, sess, 0, 0);
-
 	sess->deleted = QLA_SESS_DELETION_IN_PROGRESS;
 	sess->disc_state = DSC_DELETE_PEND;
 	sess->last_rscn_gen = sess->rscn_gen;


