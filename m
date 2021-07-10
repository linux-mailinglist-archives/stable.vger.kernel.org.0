Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2C23C2DAC
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbhGJCYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:24:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:41524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231682AbhGJCYr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:24:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADBDC613E1;
        Sat, 10 Jul 2021 02:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883723;
        bh=IYoubfj/OlkMZZB5SY71eKlG6nEiNmDXtp7ZUMa6i/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kSN68q9aJfosiipUly22QxG1u/NBe8yWJ1T/1usJ64h+iPtDMxUzNkQ8RdKmsXz7w
         kJoctkEEn8HB0phnEqxZ4ZNv2z5Rc6bpT8nCY09Dy2VP5TnGpfT4qdrY0tdpluHrGl
         BP6daETZeMEc0ng23sth0ZTUewAVFjpgnS8EDszoS1okMeu2Hg4JPqAfkiUM+HipbU
         lNGxKHtrEsNFFd+/wo0bXH57b5qBWffUwcNg99YXIPRBOMFdTqXwHtWmI1XG7+vqs8
         Y4Ut7tH0E8/zmRonPQmb42TLW/y7Bo8evV1p7gPtYkJzX7gs3+crOdOeN9Nvp5Xg3i
         w1fOkk725p60g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     ching Huang <ching2048@areca.com.tw>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 005/104] scsi: arcmsr: Fix the wrong CDB payload report to IOP
Date:   Fri,  9 Jul 2021 22:20:17 -0400
Message-Id: <20210710022156.3168825-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ching Huang <ching2048@areca.com.tw>

[ Upstream commit 5b8644968d2ca85abb785e83efec36934974b0c2 ]

This patch fixes the wrong CDB payload report to IOP.

Link: https://lore.kernel.org/r/d2c97df3c817595c6faf582839316209022f70da.camel@areca.com.tw
Signed-off-by: ching Huang <ching2048@areca.com.tw>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 4b79661275c9..930972cda38c 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1923,8 +1923,12 @@ static void arcmsr_post_ccb(struct AdapterControlBlock *acb, struct CommandContr
 
 		if (ccb->arc_cdb_size <= 0x300)
 			arc_cdb_size = (ccb->arc_cdb_size - 1) >> 6 | 1;
-		else
-			arc_cdb_size = (((ccb->arc_cdb_size + 0xff) >> 8) + 2) << 1 | 1;
+		else {
+			arc_cdb_size = ((ccb->arc_cdb_size + 0xff) >> 8) + 2;
+			if (arc_cdb_size > 0xF)
+				arc_cdb_size = 0xF;
+			arc_cdb_size = (arc_cdb_size << 1) | 1;
+		}
 		ccb_post_stamp = (ccb->smid | arc_cdb_size);
 		writel(0, &pmu->inbound_queueport_high);
 		writel(ccb_post_stamp, &pmu->inbound_queueport_low);
-- 
2.30.2

