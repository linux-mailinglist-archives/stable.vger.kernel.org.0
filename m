Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 482193C51DE
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345530AbhGLHny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:43:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348029AbhGLHkd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:40:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3232E611F2;
        Mon, 12 Jul 2021 07:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075463;
        bh=LSg+7uqgLmXmAyAAsiTLfdHSDeUD1WeA8ubJ5SDsZL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c1U66EiYKPifzkIbXQ6lib7MlseAwrVK68CIsQI+YGAL0iK4DGMeQen+aIvazqsVG
         0yJh5CZPLJJD0djxPVVCQLIEZ6qSWpCgX1wEeo4gkHkKwchDAxSre9BUZgYXkLnZFJ
         NxK27xuaKzjJH+C1yZBdAp32tFnr8eNwvazTuWvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 228/800] drivers: hv: Fix missing error code in vmbus_connect()
Date:   Mon, 12 Jul 2021 08:04:11 +0200
Message-Id: <20210712060945.918224950@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



