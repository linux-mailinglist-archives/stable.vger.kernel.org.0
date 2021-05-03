Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65031371BFF
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbhECQvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:51:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:32774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233369AbhECQru (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:47:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29D3B6137D;
        Mon,  3 May 2021 16:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059993;
        bh=mLGJBaQAfuA/+IOhEU4qh/p0ufoOZWLFfpTLJIhCyOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m2NLAF7K5yYzmV3ZJFq4PjOYKlBkGnwBejxHtSEV+wUofGJIdwisjXVSw+q89Z6QG
         7SCJ2g6QsbPZ2Tt6DMkw2AYCs8uP1OORnoUEqaOFyqAq3lJgXxlr99oP1q/CgWp/A3
         bEoS9HRFJ8qWi+x+Mz+8Q2PAHWvnRTzLbSyoyrOLYTPWf/U8HCW80HDfTW+FdF+qGw
         Lkqkavaf4SJOiB00q4/zPDB+9Lwgt/T5jETndQ5+9Uizt0h/apCaRGmN3APhYoFs1B
         Ur6/SXxOcx1V0poepK6FGXkdjnVGkY2cJB3LmQkS364ovi7WrwC+1623TFQNT43ahZ
         KwlM0LMhE+g0Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Mike Christie <michael.christie@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 07/57] scsi: target: pscsi: Fix warning in pscsi_complete_cmd()
Date:   Mon,  3 May 2021 12:38:51 -0400
Message-Id: <20210503163941.2853291-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163941.2853291-1-sashal@kernel.org>
References: <20210503163941.2853291-1-sashal@kernel.org>
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
index 5a047ce77bc0..55fe93296deb 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -620,8 +620,9 @@ static void pscsi_complete_cmd(struct se_cmd *cmd, u8 scsi_status,
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

