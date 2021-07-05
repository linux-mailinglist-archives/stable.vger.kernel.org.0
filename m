Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB6083BBF87
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbhGEPcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:32:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:57076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231744AbhGEPcN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:32:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95DAC61981;
        Mon,  5 Jul 2021 15:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625498976;
        bh=LWU4pu6OizBLPVJAsbNsYYdP5CkSnwm3hZsUrnM0/Xg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JM09j9QL8YDnGpEIr1mNTU7RtAB0wXT7GGumRSY0ZPmIydHJwEwEPz45AVhtaECwV
         sQcUTKfJBWlllmSCmS5GdO6H3S1nUTo0rC0dGkd1CgpL2MG7iq+V8JvhX74MzaEHx+
         Pb7+m1qXsXAfpf6E26jvTj9u1cko83yL9OmfzorgK0mORfGELB7//K7Us3KXxECKUS
         DV6FGeQN6KytcIEb2azMfyEJilQ98uKj+RZSx1l90A1/ShjBD1SdSSQduA1szn9wuZ
         nXrJjYA1Ft9yWmDDygKDVbJXRVGKCiKC0uOPygXY6Uap4z8ByBOKW11FPmmgz4Ba+I
         osEDFHtN8HFHA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 18/52] drivers: hv: Fix missing error code in vmbus_connect()
Date:   Mon,  5 Jul 2021 11:28:39 -0400
Message-Id: <20210705152913.1521036-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705152913.1521036-1-sashal@kernel.org>
References: <20210705152913.1521036-1-sashal@kernel.org>
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
index c83612cddb99..425bf85ed1a0 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -229,8 +229,10 @@ int vmbus_connect(void)
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

