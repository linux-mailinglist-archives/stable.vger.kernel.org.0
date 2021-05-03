Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E333371D0E
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234519AbhECQ5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:57:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235087AbhECQzr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:55:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06E7C61955;
        Mon,  3 May 2021 16:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060175;
        bh=kJ+6IGZst7C98XZZn6p9kF14JIzeHsem3vgCqByeiA8=;
        h=From:To:Cc:Subject:Date:From;
        b=ffFRGBRj7EO8OaEIAPnc9ivV8gPWXnEiDcF2FSxdko+z4bGPZdIuYXEz4+Mpnus6u
         dckYaW7SO/e/r/nrabaUxqnE0sLABm6zonq+x7eMoCfKUo9Re9vYfbMz/IJRGwfT4h
         5mAeD9jvFIt8NPJEoKoZRhBN6v/MHMLfr0GBuFSv3GHQykaP/XJ4Itoil483BSBYqa
         shcOUR5F7CGO8mXE449IhRb/GJk+Bcx9QHBJCucRhGtXA/J/heNu3v4GRmYsBX0LNl
         W8LZq1TelINQpdgI3fIs+m4ra3AoipaJkRVt+0TEnahVyb0+/OekvM17TXPQlU0wIo
         gahXRXQdyNtIg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Mike Christie <michael.christie@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 01/24] scsi: target: pscsi: Fix warning in pscsi_complete_cmd()
Date:   Mon,  3 May 2021 12:42:29 -0400
Message-Id: <20210503164252.2854487-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
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
index 079db0bd3917..089ba39f76a2 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -629,8 +629,9 @@ static void pscsi_transport_complete(struct se_cmd *cmd, struct scatterlist *sg,
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

