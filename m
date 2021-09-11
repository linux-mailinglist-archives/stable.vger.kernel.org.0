Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 564624077F1
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237106AbhIKNV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:21:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237551AbhIKNTZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:19:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 838DC61368;
        Sat, 11 Sep 2021 13:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631366054;
        bh=ikK+fCwpVJ0I4ssjiaeu6ehHoLneq/XFSaeWYe3coCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ir6ZEMSx5VKfguIOzfA7dzNeFzXLT0n2k+QcCuBmVNH4Ln3D0bfyGCOaUA+Bgn50x
         Um0bk1myzYXAcJ/37ptd5hX27ENS0RxkeT9ChIOJfiYY9guuWHToDTYw0ANCCQLG/b
         0ZL5m3bueqTEc7FPNH2YWe0fRGuqotpdO9lJYzU/UvKMA+agIx0zD7O5uHCSIyoQES
         HzgYQwaQ+wPAKD0wthcYifqzVSXtWYnayXnmbz12jS07MqjVwdxJNX8iZ+6/F9u3Q4
         TG/Q7emqVr+2c2CCqwNgrKFGe8/6r0FYCm3tfp5iN0hFBlkds1Rpva2DdXwPyJou4T
         +AxmikucAM4hw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Jon Mason <jdmason@kudzu.us>, Sasha Levin <sashal@kernel.org>,
        linux-ntb@googlegroups.com
Subject: [PATCH AUTOSEL 4.19 7/7] NTB: perf: Fix an error code in perf_setup_inbuf()
Date:   Sat, 11 Sep 2021 09:14:04 -0400
Message-Id: <20210911131404.286005-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131404.286005-1-sashal@kernel.org>
References: <20210911131404.286005-1-sashal@kernel.org>
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
index ad5d3919435c..87a41d0ededc 100644
--- a/drivers/ntb/test/ntb_perf.c
+++ b/drivers/ntb/test/ntb_perf.c
@@ -600,6 +600,7 @@ static int perf_setup_inbuf(struct perf_peer *peer)
 		return -ENOMEM;
 	}
 	if (!IS_ALIGNED(peer->inbuf_xlat, xlat_align)) {
+		ret = -EINVAL;
 		dev_err(&perf->ntb->dev, "Unaligned inbuf allocated\n");
 		goto err_free_inbuf;
 	}
-- 
2.30.2

