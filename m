Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B010D13F912
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729394AbgAPQxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:53:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:37214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729889AbgAPQxX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:53:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E965214AF;
        Thu, 16 Jan 2020 16:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193602;
        bh=7+gjoVYPKPnT4tj9n23NpvKEumOwWVHOE8EGjGny3z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zEdj61yc2t+ravsvf4LnqutfwIn7003h+nn8QnF8aEC0+V5/Pc0A6xc5s+wMMhqwM
         4+k0t/kHKCvnTPW7Css+TMYUhl3FWQV8afR66RPeO6/PhlTHfyM6Mdyl+CzJS6S0IN
         aDSROM5cQyHuiPuZrIwH2inIsZ6KyFNv1WjbrgEc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        Hulk Robot <hulkci@huawei.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 141/205] firmware: arm_scmi: Fix doorbell ring logic for !CONFIG_64BIT
Date:   Thu, 16 Jan 2020 11:41:56 -0500
Message-Id: <20200116164300.6705-141-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 7bd39bc6bfdf96f5df0f92199bbc1a3ee2f2adb8 ]

The logic to ring the scmi performance fastchannel ignores the
value read from the doorbell register in case of !CONFIG_64BIT.
This bug also shows up as warning with '-Wunused-but-set-variable' gcc
flag:

drivers/firmware/arm_scmi/perf.c: In function scmi_perf_fc_ring_db:
drivers/firmware/arm_scmi/perf.c:323:7: warning: variable val set but
			not used [-Wunused-but-set-variable]

Fix the same by aligning the logic with CONFIG_64BIT as used in the
macro SCMI_PERF_FC_RING_DB().

Fixes: 823839571d76 ("firmware: arm_scmi: Make use SCMI v2.0 fastchannel for performance protocol")
Reported-by: Hulk Robot <hulkci@huawei.com>
Reported-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/perf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_scmi/perf.c b/drivers/firmware/arm_scmi/perf.c
index 4a8012e3cb8c..601af4edad5e 100644
--- a/drivers/firmware/arm_scmi/perf.c
+++ b/drivers/firmware/arm_scmi/perf.c
@@ -323,7 +323,7 @@ static void scmi_perf_fc_ring_db(struct scmi_fc_db_info *db)
 
 		if (db->mask)
 			val = ioread64_hi_lo(db->addr) & db->mask;
-		iowrite64_hi_lo(db->set, db->addr);
+		iowrite64_hi_lo(db->set | val, db->addr);
 	}
 #endif
 }
-- 
2.20.1

