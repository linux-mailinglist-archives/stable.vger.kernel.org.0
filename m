Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4682A55AA
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387718AbgKCVV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:21:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:45098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387567AbgKCVGO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:06:14 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C02BF206B5;
        Tue,  3 Nov 2020 21:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437573;
        bh=1fbcIFxrSxbsxE7puIGdERneeBVNw/c+3hPM+2HsZSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r2RgqaTwxP3K3EdCu6cUGZztHWczGNtlsuWYLQshtytmWpN8rmnxjkPLzxybP1H5t
         jF1QM5HR0kxa/srhky44sa39Sx2EE1EL7MxuKeZRN29bCLkx49xIapFgHsKjo8PeZR
         6aaUwtzsu23k3+s0vXe1KTnukN3C645iAHEwv9KU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 127/191] scsi: qla2xxx: Fix crash on session cleanup with unload
Date:   Tue,  3 Nov 2020 21:36:59 +0100
Message-Id: <20201103203245.060056528@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
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
@@ -1228,14 +1228,15 @@ void qlt_schedule_sess_for_deletion(stru
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


