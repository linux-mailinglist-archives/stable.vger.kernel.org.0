Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD51418E70
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 18:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfEIQu6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 12:50:58 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:50945 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726653AbfEIQu5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 12:50:57 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 965C7289B8;
        Thu,  9 May 2019 12:50:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 09 May 2019 12:50:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=WrewWK
        Ssbl0A79niWCNuMMRASbUQ6C3kuICIV7bgT5g=; b=rTdPW/vMr7g50z38yg8QlH
        UxqmHZ5mtpxf2fMRqfS5cks2o0ZksTCrQ+iit7ZljJnF52//FWdEQM4oTFdTEkes
        STKrMgb5hJNNr5Ynmavr9fo10SY59Sc/OcYlVeBkEcfjx9dtgZRga9ep0m3iPsQV
        V+G+NLnyEBxi+uOhTi1rmCl5SzJUDfK3rgZyi8eU9rSV80JYPm6x0s/IYCx2Jrwr
        P3tfg93a18pBMmh9Hgbuz5DHG4tCAnS60+yfd+/IvKUy5nEdi2mbLkZN1v6IRqWj
        Js/2ZsI6P4imeVU1bo0BLd/X2C7N5qwjnvTB+LWb0Tz52OaIMKe7725rqcSgCAUQ
        ==
X-ME-Sender: <xms:cFrUXIPKHeW4XdZlsI86l5lUXgx6fde1d_Y_DhHFi-niGO1gLOQRNQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrkeeigdeghecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:cFrUXGsuN3fCVBavMSKq5xLC8R3ELDm2oqhRNbKyLRd_NmwAXSWP-A>
    <xmx:cFrUXERV6kHm-oqgdckq2vEngQn1SjZ0w3VIJR0fyh7ll15havUm5g>
    <xmx:cFrUXIsg5i3OPSxWAS9aXOXiVxgbcR3-YnS-q7g9mCnwIXpxCmk8_A>
    <xmx:cFrUXGOOtQg2TGfk0dKK8dgmEtmHQeKvF6Em8757iuUBklJbkw_NdA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9F165103CB;
        Thu,  9 May 2019 12:50:55 -0400 (EDT)
Subject: FAILED: patch "[PATCH] scsi: qla2xxx: Fix device staying in blocked state" failed to apply to 4.14-stable tree
To:     qtran@marvell.com, emilne@redhat.com, hmadhani@marvell.com,
        martin.petersen@oracle.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 09 May 2019 18:50:54 +0200
Message-ID: <15574206544024@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2137490f2147a8d0799b72b9a1023efb012d40c7 Mon Sep 17 00:00:00 2001
From: Quinn Tran <qtran@marvell.com>
Date: Tue, 23 Apr 2019 14:52:35 -0700
Subject: [PATCH] scsi: qla2xxx: Fix device staying in blocked state

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

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 57cdd762230d..fc8914dd9dde 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -982,6 +982,8 @@ void qlt_free_session_done(struct work_struct *work)
 		sess->send_els_logo);
 
 	if (!IS_SW_RESV_ADDR(sess->d_id)) {
+		qla2x00_mark_device_lost(vha, sess, 0, 0);
+
 		if (sess->send_els_logo) {
 			qlt_port_logo_t logo;
 
@@ -1163,8 +1165,6 @@ void qlt_unreg_sess(struct fc_port *sess)
 	if (sess->se_sess)
 		vha->hw->tgt.tgt_ops->clear_nacl_from_fcport_map(sess);
 
-	qla2x00_mark_device_lost(vha, sess, 0, 0);
-
 	sess->deleted = QLA_SESS_DELETION_IN_PROGRESS;
 	sess->disc_state = DSC_DELETE_PEND;
 	sess->last_rscn_gen = sess->rscn_gen;

