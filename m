Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD144077CD
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237090AbhIKNUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:20:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236960AbhIKNRk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:17:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B875261212;
        Sat, 11 Sep 2021 13:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631366023;
        bh=P8tuf+tDy2pcR8mAryvwRZSmAXGTiQWLnb3UXVnShc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f94983ScAoNSFyy44f6IQAARyfu7E1DstyJDz9z0w59ma0v21maue1y4qgGhYh1av
         HcdbwpOYSeObOsiZN5KsDKL5SNUHmdLMgSz0na4WmxBS7X/sjM7oplnH+7isH2c8Vs
         9bs33/44sndLTgoKQCdOA6M1tcNpe3YWal4sRdNu9gTOewsUJM1yYUDanhTz+Mm0VI
         RGDj+SOgXV1y+nWAxDsOMnSKeaP2KByYi1FOOcrPRLz76vK33QSr9bBdQWBFmUCTMf
         h0QYZaYjn91CNq2TiEsa42m4FYE2ycE8ioVxc3xyfTY3ksjFzztj2XuteYAHwX+Xtm
         QhYU0I+O3cueQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Jon Mason <jdmason@kudzu.us>, Sasha Levin <sashal@kernel.org>,
        linux-ntb@googlegroups.com
Subject: [PATCH AUTOSEL 5.10 24/25] NTB: perf: Fix an error code in perf_setup_inbuf()
Date:   Sat, 11 Sep 2021 09:13:11 -0400
Message-Id: <20210911131312.285225-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131312.285225-1-sashal@kernel.org>
References: <20210911131312.285225-1-sashal@kernel.org>
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

