Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC461AF14A
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 16:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbgDROzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 10:55:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726855AbgDROlB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 10:41:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89C5C21D7E;
        Sat, 18 Apr 2020 14:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587220861;
        bh=zxMAMCUGege0v8kJLkpgkDzKu7rKYEby4bGm0U/va+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bu768MNnikwlFPXSoGbGPu8xxswG5ZIkHaKOSJ4MSaUZdzwWAGEZMhfjysDDC2nQf
         JJ+j8Yu6c5MYdsYqZ5vMtjPt0a3ctJ86OhgzgzkTfkXB37FtnYNMBTQDPMRsCuYG16
         iLxql8GOqxP6rElv9TTaYkwDO6KTziB5rZV0B7po=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Javed Hasan <jhasan@marvell.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 11/78] scsi: libfc: If PRLI rejected, move rport to PLOGI state
Date:   Sat, 18 Apr 2020 10:39:40 -0400
Message-Id: <20200418144047.9013-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418144047.9013-1-sashal@kernel.org>
References: <20200418144047.9013-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javed Hasan <jhasan@marvell.com>

[ Upstream commit 45e544bfdab2014d11c7595b8ccc3c4715a09015 ]

If PRLI reject code indicates "rejected status", move rport state machine
back to PLOGI state.

Link: https://lore.kernel.org/r/20200327060208.17104-2-skashyap@marvell.com
Signed-off-by: Javed Hasan <jhasan@marvell.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libfc/fc_rport.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index da6e97d8dc3bb..6bb8917b99a19 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1208,9 +1208,15 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 		rjt = fc_frame_payload_get(fp, sizeof(*rjt));
 		if (!rjt)
 			FC_RPORT_DBG(rdata, "PRLI bad response\n");
-		else
+		else {
 			FC_RPORT_DBG(rdata, "PRLI ELS rejected, reason %x expl %x\n",
 				     rjt->er_reason, rjt->er_explan);
+			if (rjt->er_reason == ELS_RJT_UNAB &&
+			    rjt->er_explan == ELS_EXPL_PLOGI_REQD) {
+				fc_rport_enter_plogi(rdata);
+				goto out;
+			}
+		}
 		fc_rport_error_retry(rdata, FC_EX_ELS_RJT);
 	}
 
-- 
2.20.1

