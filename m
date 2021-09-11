Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 767644077F7
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237110AbhIKNWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:22:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237524AbhIKNTY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:19:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 989026135F;
        Sat, 11 Sep 2021 13:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631366043;
        bh=vZ2tKc+2Xa7Zsse5l2RmsGfKa3kyAD+Q4A8y/hduqEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BnChKO3/M6c7vHHVoGOukKMRJaG61O7CNJ0aBVcs4prYw5+MMNHKs5WdFHuPq5aIQ
         +d9m3Okb+f5XMxiqMx7X2cC6uKvcOluS1qLDtfA4xBKEydiTHQE1ljEFHFJKOoyA4h
         6QjmTRAC+lwzIeIRkiYdhkT/T577MqTWG65viJelsBuDDvpBqFvPl3n/rJjpgB6wv6
         1MizRZXAkAAxeURXeGO0hchCSJtmSO+rhQ0BcHY6Whm0RlUuGEflhI/znTbQoA4YiB
         KcSjQgyOKQnz9HHa+6CXN1s/wGjWPuWxiV4TkRi3qYsXRVAQGGOz025HVrJB8I9zfC
         8TTiusgLkssaw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Jon Mason <jdmason@kudzu.us>, Sasha Levin <sashal@kernel.org>,
        linux-ntb@googlegroups.com
Subject: [PATCH AUTOSEL 5.4 14/14] NTB: perf: Fix an error code in perf_setup_inbuf()
Date:   Sat, 11 Sep 2021 09:13:45 -0400
Message-Id: <20210911131345.285564-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131345.285564-1-sashal@kernel.org>
References: <20210911131345.285564-1-sashal@kernel.org>
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
index 5ce4766a6c9e..251fe75798c1 100644
--- a/drivers/ntb/test/ntb_perf.c
+++ b/drivers/ntb/test/ntb_perf.c
@@ -597,6 +597,7 @@ static int perf_setup_inbuf(struct perf_peer *peer)
 		return -ENOMEM;
 	}
 	if (!IS_ALIGNED(peer->inbuf_xlat, xlat_align)) {
+		ret = -EINVAL;
 		dev_err(&perf->ntb->dev, "Unaligned inbuf allocated\n");
 		goto err_free_inbuf;
 	}
-- 
2.30.2

