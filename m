Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB0E2A5336
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733012AbgKCU6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:58:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:33508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733026AbgKCU6w (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:58:52 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11BA32053B;
        Tue,  3 Nov 2020 20:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437130;
        bh=lTsYLD4/3AZ0wNQQTQ9iTZNTU29uhtenMZP9Qvc8jRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MdBVxclrNxg/5aHYlHtwz8J16lQCeOvKBqCT2RAn7U6B9syNvjKDYMEn5H3CtVh/j
         6HqmdUOlmpl2FOOzfpwcEnpAVfNYTN80NOaD6rOlgQMFOeXSApQzAVbmfSFsbAKyw0
         zVEyebx8r+alxFfTucDSIMuHOLSv6fgJR1x1ZXRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 120/214] scsi: qla2xxx: Fix crash on session cleanup with unload
Date:   Tue,  3 Nov 2020 21:36:08 +0100
Message-Id: <20201103203302.131319515@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

commit 50457dab670f396557e60c07f086358460876353 upstream.

On unload, session cleanup prematurely gave the signal for driver unload
path to advance.

Link: https://lore.kernel.org/r/20200929102152.32278-6-njavali@marvell.com
Fixes: 726b85487067 ("qla2xxx: Add framework for async fabric discovery")
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_target.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1230,14 +1230,15 @@ void qlt_schedule_sess_for_deletion(stru
 	case DSC_DELETE_PEND:
 		return;
 	case DSC_DELETED:
-		if (tgt && tgt->tgt_stop && (tgt->sess_count == 0))
-			wake_up_all(&tgt->waitQ);
-		if (sess->vha->fcport_count == 0)
-			wake_up_all(&sess->vha->fcport_waitQ);
-
 		if (!sess->plogi_link[QLT_PLOGI_LINK_SAME_WWN] &&
-			!sess->plogi_link[QLT_PLOGI_LINK_CONFLICT])
+			!sess->plogi_link[QLT_PLOGI_LINK_CONFLICT]) {
+			if (tgt && tgt->tgt_stop && tgt->sess_count == 0)
+				wake_up_all(&tgt->waitQ);
+
+			if (sess->vha->fcport_count == 0)
+				wake_up_all(&sess->vha->fcport_waitQ);
 			return;
+		}
 		break;
 	case DSC_UPD_FCPORT:
 		/*


