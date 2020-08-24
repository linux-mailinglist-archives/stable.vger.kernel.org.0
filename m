Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 394FA24F7FE
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725781AbgHXJYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:24:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730244AbgHXIxu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:53:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68030204FD;
        Mon, 24 Aug 2020 08:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259229;
        bh=s6qr3pBHDicYElbR0M0Yvr0h47oarzRdFZZA1GnplWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OaKG13vPDKnwxPe5lNK+mT91I0RU7OHioE5Urys4KjeXc4HQggpZf7ilnz1Dw12Xw
         LmdoI+y/fzmjNQCiu6EqD/Qsy/2z058WlfLmjkXQXyAY3MrGQzwgItkYsBOGiwKOAw
         PuqJXXWfGh7Z3AI9TGhr93S9VGtSJ4nzs5PDndoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Girish Basrur <gbasrur@marvell.com>,
        Santosh Vernekar <svernekar@marvell.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Shyam Sundar <ssundar@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 29/50] scsi: libfc: Free skb in fc_disc_gpn_id_resp() for valid cases
Date:   Mon, 24 Aug 2020 10:31:30 +0200
Message-Id: <20200824082353.513985817@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082351.823243923@linuxfoundation.org>
References: <20200824082351.823243923@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javed Hasan <jhasan@marvell.com>

[ Upstream commit ec007ef40abb6a164d148b0dc19789a7a2de2cc8 ]

In fc_disc_gpn_id_resp(), skb is supposed to get freed in all cases except
for PTR_ERR. However, in some cases it didn't.

This fix is to call fc_frame_free(fp) before function returns.

Link: https://lore.kernel.org/r/20200729081824.30996-2-jhasan@marvell.com
Reviewed-by: Girish Basrur <gbasrur@marvell.com>
Reviewed-by: Santosh Vernekar <svernekar@marvell.com>
Reviewed-by: Saurav Kashyap <skashyap@marvell.com>
Reviewed-by: Shyam Sundar <ssundar@marvell.com>
Signed-off-by: Javed Hasan <jhasan@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libfc/fc_disc.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 28b50ab2fbb01..62f83cc151b22 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -605,8 +605,12 @@ static void fc_disc_gpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	if (PTR_ERR(fp) == -FC_EX_CLOSED)
 		goto out;
-	if (IS_ERR(fp))
-		goto redisc;
+	if (IS_ERR(fp)) {
+		mutex_lock(&disc->disc_mutex);
+		fc_disc_restart(disc);
+		mutex_unlock(&disc->disc_mutex);
+		goto out;
+	}
 
 	cp = fc_frame_payload_get(fp, sizeof(*cp));
 	if (!cp)
@@ -633,7 +637,7 @@ static void fc_disc_gpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 				new_rdata->disc_id = disc->disc_id;
 				fc_rport_login(new_rdata);
 			}
-			goto out;
+			goto free_fp;
 		}
 		rdata->disc_id = disc->disc_id;
 		mutex_unlock(&rdata->rp_mutex);
@@ -650,6 +654,8 @@ redisc:
 		fc_disc_restart(disc);
 		mutex_unlock(&disc->disc_mutex);
 	}
+free_fp:
+	fc_frame_free(fp);
 out:
 	kref_put(&rdata->kref, fc_rport_destroy);
 	if (!IS_ERR(fp))
-- 
2.25.1



