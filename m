Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F353BBF16
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbhGEPbW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:31:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232016AbhGEPbV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:31:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D03B61986;
        Mon,  5 Jul 2021 15:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625498924;
        bh=LSg+7uqgLmXmAyAAsiTLfdHSDeUD1WeA8ubJ5SDsZL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S+KGxEbPR9sYSnAzAoAZIfhgZTrAGI/dDGW5qXDBzbniINMb3gPP8spHspIVE47jt
         8YC0guH/hyGJdtlFtmXzADq5jkIY/84qdiAARATBCcUAQme+vo5jaUIVJGA1Hj1TtP
         hRkaz40WTWcmy7cdnw5g1Qr2sJpEotZEGMGk2ySXHvDRTf7trPr+M1uCmry3fVbkO8
         2q0WJbvrv7XEVsAiAz5L4+V8WCkOkn8LMRtymmnjYmwp5hMXV1Jw0cA8ZvoDESqVfL
         ZySthH/0B0K4ecvd9tLJT5qwuBvzG/TS4eI2YP3mnC9go9pMPtLzdd9G0U//X0xzky
         krtwi6J/OGhKw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 21/59] drivers: hv: Fix missing error code in vmbus_connect()
Date:   Mon,  5 Jul 2021 11:27:37 -0400
Message-Id: <20210705152815.1520546-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705152815.1520546-1-sashal@kernel.org>
References: <20210705152815.1520546-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit 9de6655cc5a6a1febc514465c87c24a0e96d8dba ]

Eliminate the follow smatch warning:

drivers/hv/connection.c:236 vmbus_connect() warn: missing error code
'ret'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/1621940321-72353-1-git-send-email-jiapeng.chong@linux.alibaba.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/connection.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 311cd005b3be..5e479d54918c 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -232,8 +232,10 @@ int vmbus_connect(void)
 	 */
 
 	for (i = 0; ; i++) {
-		if (i == ARRAY_SIZE(vmbus_versions))
+		if (i == ARRAY_SIZE(vmbus_versions)) {
+			ret = -EDOM;
 			goto cleanup;
+		}
 
 		version = vmbus_versions[i];
 		if (version > max_version)
-- 
2.30.2

