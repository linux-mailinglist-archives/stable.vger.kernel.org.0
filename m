Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48CA1407703
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236654AbhIKNOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:14:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:38124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236337AbhIKNNm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:13:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD63961206;
        Sat, 11 Sep 2021 13:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631365949;
        bh=P8tuf+tDy2pcR8mAryvwRZSmAXGTiQWLnb3UXVnShc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AkJCGrkHLMgiBDFbqP6BPYucp96LVnWi7QWE00NDT6jbf0594HfwGr034sqLNtS6L
         +Egk+1h2jBo+uhH2vwU4JKYsAb53Mc2gPuFKFG3VyOyXg0XJ7Hw9Sa1WT4/FUtJpgB
         5jSvBiDJLbMseuGJ42+YcWf2p5CEb1mi2WFDGeFVwbJuh4C7BLre/IK0hxbN+ha1QU
         KQhe9+bA4MEIC8rQbuWOnx/IiWhfwryreuzniBYUP+QqL0UZAQLqv4tCrxelshzWps
         wcs6qY+Zg2VpfT/vbsmPyo9MuSdPvj+JzBsprl9KrChwb5vesp16NDZhMVBHIAy7Rs
         1d2bjsNKdy5iA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Jon Mason <jdmason@kudzu.us>, Sasha Levin <sashal@kernel.org>,
        linux-ntb@googlegroups.com
Subject: [PATCH AUTOSEL 5.14 30/32] NTB: perf: Fix an error code in perf_setup_inbuf()
Date:   Sat, 11 Sep 2021 09:11:47 -0400
Message-Id: <20210911131149.284397-30-sashal@kernel.org>
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

[ Upstream commit 0097ae5f7af5684f961a5f803ff7ad3e6f933668 ]

When the function IS_ALIGNED() returns false, the value of ret is 0.
So, we set ret to -EINVAL to indicate this error.

Clean up smatch warning:
drivers/ntb/test/ntb_perf.c:602 perf_setup_inbuf() warn: missing error
code 'ret'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/test/ntb_perf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ntb/test/ntb_perf.c b/drivers/ntb/test/ntb_perf.c
index 89df1350fefd..65e1e5cf1b29 100644
--- a/drivers/ntb/test/ntb_perf.c
+++ b/drivers/ntb/test/ntb_perf.c
@@ -598,6 +598,7 @@ static int perf_setup_inbuf(struct perf_peer *peer)
 		return -ENOMEM;
 	}
 	if (!IS_ALIGNED(peer->inbuf_xlat, xlat_align)) {
+		ret = -EINVAL;
 		dev_err(&perf->ntb->dev, "Unaligned inbuf allocated\n");
 		goto err_free_inbuf;
 	}
-- 
2.30.2

