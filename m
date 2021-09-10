Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1954A406218
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233587AbhIJAoo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:44:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233641AbhIJAUc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:20:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E25761101;
        Fri, 10 Sep 2021 00:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233162;
        bh=IDQFCtoyLckoFTCR2vpRmp21F1qYhxGe8k2EAQuWfPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k7paJ9TKePyAQPblPbSGjXcWGkMX28saI5YK+mZUCBkme7Pzvtd7CHg8er70pavaX
         5/TJvntWEmIPH/eSBoCenyhfOjqaz2+4XUTUSLAjEvIqVZ34iGoN5P+kWHIxX84W6V
         +6mZII+iHWlZ2lo6EcVsCEdL6cnYeZfrs3fsHSZjiufFbq17GOWC9t6El4f25pgEyO
         ahsVNfZAdrkTDlK86fshpu1qb3cFZF5W7yw1fxN9xcTlh+GcSuxQ7UgVezBRigEKL9
         b6VlFPtCXbdMNs5Zye5wbUOAPaH71b1v8jHTEw73nxRKgWuwuyXfgof3sK+MLmkv7O
         W76QZDfPe7OmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tuo Li <islituo@gmail.com>, TOTE Robot <oslab@tsinghua.edu.cn>,
        Bodo Stroesser <bostroesser@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 43/88] scsi: target: pscsi: Fix possible null-pointer dereference in pscsi_complete_cmd()
Date:   Thu,  9 Sep 2021 20:17:35 -0400
Message-Id: <20210910001820.174272-43-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tuo Li <islituo@gmail.com>

[ Upstream commit 0f99792c01d1d6d35b86e850e9ccadd98d6f3e0c ]

The return value of transport_kmap_data_sg() is assigned to the variable
buf:

  buf = transport_kmap_data_sg(cmd);

And then it is checked:

  if (!buf) {

This indicates that buf can be NULL. However, it is dereferenced in the
following statements:

  if (!(buf[3] & 0x80))
    buf[3] |= 0x80;
  if (!(buf[2] & 0x80))
    buf[2] |= 0x80;

To fix these possible null-pointer dereferences, dereference buf and call
transport_kunmap_data_sg() only when buf is not NULL.

Link: https://lore.kernel.org/r/20210810040414.248167-1-islituo@gmail.com
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>
Signed-off-by: Tuo Li <islituo@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_pscsi.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index f2a11414366d..da5de58bd3bb 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -620,17 +620,17 @@ static void pscsi_complete_cmd(struct se_cmd *cmd, u8 scsi_status,
 			buf = transport_kmap_data_sg(cmd);
 			if (!buf) {
 				; /* XXX: TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE */
-			}
-
-			if (cdb[0] == MODE_SENSE_10) {
-				if (!(buf[3] & 0x80))
-					buf[3] |= 0x80;
 			} else {
-				if (!(buf[2] & 0x80))
-					buf[2] |= 0x80;
-			}
+				if (cdb[0] == MODE_SENSE_10) {
+					if (!(buf[3] & 0x80))
+						buf[3] |= 0x80;
+				} else {
+					if (!(buf[2] & 0x80))
+						buf[2] |= 0x80;
+				}
 
-			transport_kunmap_data_sg(cmd);
+				transport_kunmap_data_sg(cmd);
+			}
 		}
 	}
 after_mode_sense:
-- 
2.30.2

