Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4829B371CD3
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbhECQ5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:44506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234323AbhECQxo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:53:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B23A361278;
        Mon,  3 May 2021 16:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060129;
        bh=dd0vDeJHtFz2d1EP7LUdQgPLk9wSejx9cpXoGNXKWeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sipv577AODlyk7ST88uge+/vn1u667z07AX/ESFnQ01MJDw1N/t1N/o1KByZoyxWB
         EDdG7W066W4pJHoapO2ORhEqBbADIvyvo/4dxP3ixEWAKOh49kdEBMk8PyDSPzdNas
         u27JwSoV3m5STKpCs0NzkfDBGGiSaL6PRSE2NnFx0ahS3jdmDF39/z198SyZ/4NdGV
         IALQ4KTO/gqlbTmMlLAukvV/C9pp9VQuUb5wwrYO8QIJ9GDLqVr93W7h+CA1KpmlSq
         3R75bcHPuoFztcsv2hjDb3R+POMhuvbcZlVDpZM/tao2aK6xh4UoP5SUyixxGlshO4
         zqdlPZEmSWEWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Mike Christie <michael.christie@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 03/31] scsi: target: pscsi: Fix warning in pscsi_complete_cmd()
Date:   Mon,  3 May 2021 12:41:36 -0400
Message-Id: <20210503164204.2854178-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164204.2854178-1-sashal@kernel.org>
References: <20210503164204.2854178-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

[ Upstream commit fd48c056a32ed6e7754c7c475490f3bed54ed378 ]

This fixes a compilation warning in pscsi_complete_cmd():

     drivers/target/target_core_pscsi.c: In function ‘pscsi_complete_cmd’:
     drivers/target/target_core_pscsi.c:624:5: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
     ; /* XXX: TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE */

Link: https://lore.kernel.org/r/20210228055645.22253-5-chaitanya.kulkarni@wdc.com
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_pscsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index f80b31b35a0d..a127608a4809 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -633,8 +633,9 @@ static void pscsi_complete_cmd(struct se_cmd *cmd, u8 scsi_status,
 			unsigned char *buf;
 
 			buf = transport_kmap_data_sg(cmd);
-			if (!buf)
+			if (!buf) {
 				; /* XXX: TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE */
+			}
 
 			if (cdb[0] == MODE_SENSE_10) {
 				if (!(buf[3] & 0x80))
-- 
2.30.2

