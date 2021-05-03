Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C48371C79
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbhECQwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:52:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:60808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231580AbhECQuv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:50:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F237961934;
        Mon,  3 May 2021 16:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060075;
        bh=p8mI+Wuhtfl8p1E0bTgw9kbTE5SG8jh1j6N6+az7v8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GlmaPPni6Q6do2Y64xiZKEeHqxIuCXA6pSbOEn1wJuaqliAiQImzmeaVM4LJRAcvo
         X4RfXb38yHiODi7mNKtJVmup6k5j++FP3Vgup8VzFNZZ9TY5xd9U0JAgLrCQUNoL+J
         BR8JdV9bgDDrlroQeEOXAR+BoBbyH9gue2VkaPE/vegMULZBQL4V28XahKaNhPbwGN
         ww5LvakGnDJrpW7mYgcd+PGA4OJTR/t11rtKm1QLFupOVJ1cKKpjO5syE7+qkqqNHo
         tfHENSWJiLeH1sJPr4TiUMH+35r/MxxNpK0OUIC/YSvHN8IowXAtGdJcRYIrTfPheC
         T7YGCu6F6w2pA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Mike Christie <michael.christie@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 03/35] scsi: target: pscsi: Fix warning in pscsi_complete_cmd()
Date:   Mon,  3 May 2021 12:40:37 -0400
Message-Id: <20210503164109.2853838-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164109.2853838-1-sashal@kernel.org>
References: <20210503164109.2853838-1-sashal@kernel.org>
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
index 02c4e3beb264..1b52cd4d793f 100644
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

