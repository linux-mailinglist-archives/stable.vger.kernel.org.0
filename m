Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48F90147B43
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733123AbgAXJmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:42:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:39840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731535AbgAXJmJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:42:09 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2847222D9;
        Fri, 24 Jan 2020 09:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858928;
        bh=/XJ7uoeV3ZBLOj9+bODHJzvOanxWzqQdMHNnOhLskPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WP66bRFpkxW4hllPkG0Hwn8kK+hdwR6edFOBztYll6ctgl+P+7EUGKXHIYUkabGN3
         5C7tmmeoin5UtEAeJIJMVQFco3MB/kQ9BC9zWnAQ3o4cXi8vu+GrWlFgdTNZ0XWAlF
         Z8o43rbfzttxC1Xy15onVcb+3tiOs0ofpfe8hdSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 082/102] firmware: arm_scmi: Fix doorbell ring logic for !CONFIG_64BIT
Date:   Fri, 24 Jan 2020 10:31:23 +0100
Message-Id: <20200124092819.042059075@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 4a8012e3cb8c3..601af4edad5e6 100644
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



