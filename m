Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF6D4076FB
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236331AbhIKNOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:14:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236327AbhIKNNk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:13:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AA67611C3;
        Sat, 11 Sep 2021 13:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631365948;
        bh=W067M9YuUs/H/l/wOW2OpgBb+e2lq9U28N6uJgw6CEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RlYKeFDpf0rqGqrD+RDd+g3RZ7TTgFL0jcvWvg+o/RaOvbyhV29vOXCbVe9tiUubc
         dS7P2zKgCzb5ru+Kryr0Tu2utxoWkkgumDOH/ynsf6U5G/TxOYwjU4w2MVonUISDPS
         ACDh4QTMTIKoeCQN3k+9Ews/fGZArRDNuhl1M0mCtT4vwSrvpRmc0umvueGCSmKD9G
         B51heaO2CrU+K+Bg4y420+vsw9Kwuc1fjMkAhYC9eQon1So8LCkfZh1x3u6QaCLJfP
         ZADmsp7JQjOh4AdBDxUQcA3kXoRR42Pz6+FUzofpE03QJ8khFOzWDGmdprszYv7swB
         mthwFX9gf3igQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Jon Mason <jdmason@kudzu.us>, Sasha Levin <sashal@kernel.org>,
        linux-ntb@googlegroups.com
Subject: [PATCH AUTOSEL 5.14 29/32] NTB: Fix an error code in ntb_msit_probe()
Date:   Sat, 11 Sep 2021 09:11:46 -0400
Message-Id: <20210911131149.284397-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131149.284397-1-sashal@kernel.org>
References: <20210911131149.284397-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Li <yang.lee@linux.alibaba.com>

[ Upstream commit 319f83ac98d7afaabab84ce5281a819a358b9895 ]

When the value of nm->isr_ctx is false, the value of ret is 0.
So, we set ret to -ENOMEM to indicate this error.

Clean up smatch warning:
drivers/ntb/test/ntb_msi_test.c:373 ntb_msit_probe() warn: missing
error code 'ret'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/test/ntb_msi_test.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ntb/test/ntb_msi_test.c b/drivers/ntb/test/ntb_msi_test.c
index 7095ecd6223a..4e18e08776c9 100644
--- a/drivers/ntb/test/ntb_msi_test.c
+++ b/drivers/ntb/test/ntb_msi_test.c
@@ -369,8 +369,10 @@ static int ntb_msit_probe(struct ntb_client *client, struct ntb_dev *ntb)
 	if (ret)
 		goto remove_dbgfs;
 
-	if (!nm->isr_ctx)
+	if (!nm->isr_ctx) {
+		ret = -ENOMEM;
 		goto remove_dbgfs;
+	}
 
 	ntb_link_enable(ntb, NTB_SPEED_AUTO, NTB_WIDTH_AUTO);
 
-- 
2.30.2

