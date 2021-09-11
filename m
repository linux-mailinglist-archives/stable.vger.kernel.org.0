Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5FF4077E8
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236287AbhIKNVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:21:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237198AbhIKNTR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:19:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62DBA6135E;
        Sat, 11 Sep 2021 13:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631366042;
        bh=U67OreaikvH+lcv14uvfEz8Sjs68iNs55ntpwLtf2aA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sXgfWvcl2Mp6+O026EzKBDQr2OKUHV/51QXREMb8aFpwukE69lnyLZEFE93jMglIS
         KMVxap5SAhEia6oCf5vkrWo/Z4hcT+AFXFP+j5jT8GRoZ6ffwBFiIy6uipOSLHX3Tc
         k9MzQWISfG0DpFzxmxkrfhW+tDFEOyYmjUvlepqdm6xNYmdX6Lya5JtAiF+w+HO/CS
         g1PW3aB/t6I2H7qvO0e4THNeoLj5I7rj7S2qwuIg7zixVU8ZRAdoSKYpaM64MEBexT
         Yo8PxwpsFesAN6nGBmkt2eEvvZnbsLZR64HBKk+132TA6ohVf4a7wVOL+KxGe1n3e+
         TQHf+iZ9Bg7Ag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Jon Mason <jdmason@kudzu.us>, Sasha Levin <sashal@kernel.org>,
        linux-ntb@googlegroups.com
Subject: [PATCH AUTOSEL 5.4 13/14] NTB: Fix an error code in ntb_msit_probe()
Date:   Sat, 11 Sep 2021 09:13:44 -0400
Message-Id: <20210911131345.285564-13-sashal@kernel.org>
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
index 99d826ed9c34..662067dc9ce2 100644
--- a/drivers/ntb/test/ntb_msi_test.c
+++ b/drivers/ntb/test/ntb_msi_test.c
@@ -372,8 +372,10 @@ static int ntb_msit_probe(struct ntb_client *client, struct ntb_dev *ntb)
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

