Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A9A496E56
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 01:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235081AbiAWAL1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jan 2022 19:11:27 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35500 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231288AbiAWAL1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jan 2022 19:11:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAFFA60F77;
        Sun, 23 Jan 2022 00:11:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429DAC004E1;
        Sun, 23 Jan 2022 00:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642896686;
        bh=HYKxLJMRC2uGjUuszv/ikOC4jFTFiRxAuWKQfKrpBl8=;
        h=From:To:Cc:Subject:Date:From;
        b=P3oe9fTkkPzzBEc2XYYpmUaIT96PpdJW71PtomoNVeA/2+eSL0q8ORtPg+q5FOuho
         yHnhNIlCeEf2HBvcAx2uqZI9HZmj/w2ka0zNx63i6g2Db4ne8AkHny0PsD0CU/ulSU
         lj1ickoVJZevSyn6QDF7rG0G1E+daXhZ0YeNUryxRfTc46QgKY7FmndrMU7nw6C5hp
         hOlxeDcZkmA+xXb0WyQLvp0b2iOPOErMULyWDLjNRbGBUKZBWzV0sXNFgtw6w3gyQn
         gK+dj70MWJ4/FwfTJeEefsh79yUI1bQJ3J7nvGPeT/9CYmOMauywtaK7fl9yacDvji
         MIeW59UZslzHw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peng Fan <peng.fan@nxp.com>, kernel test robot <lkp@intel.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>, bjorn.andersson@linaro.org,
        linux-remoteproc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 01/19] remoteproc: coredump: Correct argument 2 type for memcpy_fromio
Date:   Sat, 22 Jan 2022 19:10:54 -0500
Message-Id: <20220123001113.2460140-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 876e0b26ccd211ca92607d83c87cc1f097784c6d ]

Address the sparse check warning:
>> drivers/remoteproc/remoteproc_coredump.c:169:53:
sparse: warning: incorrect type in argument 2 (different address spaces)
sparse:    expected void const volatile [noderef] __iomem *src
sparse:    got void *[assigned] ptr

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/20211110032101.517487-1-peng.fan@oss.nxp.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_coredump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/remoteproc_coredump.c b/drivers/remoteproc/remoteproc_coredump.c
index c892f433a323e..4b093420d98aa 100644
--- a/drivers/remoteproc/remoteproc_coredump.c
+++ b/drivers/remoteproc/remoteproc_coredump.c
@@ -166,7 +166,7 @@ static void rproc_copy_segment(struct rproc *rproc, void *dest,
 			memset(dest, 0xff, size);
 		} else {
 			if (is_iomem)
-				memcpy_fromio(dest, ptr, size);
+				memcpy_fromio(dest, (void const __iomem *)ptr, size);
 			else
 				memcpy(dest, ptr, size);
 		}
-- 
2.34.1

