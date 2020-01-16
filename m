Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF07E13F023
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404199AbgAPR2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:28:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:39270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404186AbgAPR2U (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:28:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2A4C246EB;
        Thu, 16 Jan 2020 17:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195699;
        bh=joScUPhdfCP23b6S5EFY5hYk38+64+HbNEWlfegz5v4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dIHaJUG+ZrMTkQL0gCzkvwnPhvPyJfpY1NUMDnuRo6N6DO3uwdaeuduefFZrpTqEb
         2XUHJ9FnvJ3z1bupMIfRs9081um3ey+GxQmbITH/OfFhiu18wvYM59FRR9DiyuMoha
         Ixaclaq5HcLwa6b1WuyKmhx7bKaLkEpTwJ44v/LY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Hannes Reinecke <hare@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 248/371] scsi: libfc: fix null pointer dereference on a null lport
Date:   Thu, 16 Jan 2020 12:22:00 -0500
Message-Id: <20200116172403.18149-191-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 41a6bf6529edd10a6def42e3b2c34a7474bcc2f5 ]

Currently if lport is null then the null lport pointer is dereference when
printing out debug via the FC_LPORT_DB macro. Fix this by using the more
generic FC_LIBFC_DBG debug macro instead that does not use lport.

Addresses-Coverity: ("Dereference after null check")
Fixes: 7414705ea4ae ("libfc: Add runtime debugging with debug_logging module parameter")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libfc/fc_exch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 42bcf7f3a0f9..6ba257cbc6d9 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -2603,7 +2603,7 @@ void fc_exch_recv(struct fc_lport *lport, struct fc_frame *fp)
 
 	/* lport lock ? */
 	if (!lport || lport->state == LPORT_ST_DISABLED) {
-		FC_LPORT_DBG(lport, "Receiving frames for an lport that "
+		FC_LIBFC_DBG("Receiving frames for an lport that "
 			     "has not been initialized correctly\n");
 		fc_frame_free(fp);
 		return;
-- 
2.20.1

