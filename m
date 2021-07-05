Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E00F43BBFE1
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbhGEPdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:33:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:58876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232003AbhGEPc7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:32:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69203619A1;
        Mon,  5 Jul 2021 15:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499022;
        bh=m3zx+ceVEdckWgNJJueuh3O9BRsErHXlMTL9Bs9H3U8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hXUu9X0I3sBw84FUjlizgHpZ+E+wgVdn4CSCVztMLORe/mjIrGqwL1SuHZNwgbwa8
         vWH8hOJtJYaDGXBhpanQKYVj3mkSMizIlmlqws9j9fLPy9Hh1htVe+kssgZSDvVRGY
         nZ2xJxu3/ITLZcx8D6wbIaIsdHA7/CwvI79q0II1eJlIcFhB2kMPDFvUDj5FZZuWMd
         IRKLLg1mK6wEKBz1DTtAX3q1smOhEOc+nQLqbGzI3BUO06bgoteiVEg1/vvOWdUCxb
         yT4ljfOksySZsdf80TnJ+Ms1UloFBGnldtgCr2Rdx5B1x69l0/ULcipk4uVHYaQcrB
         I2b41yCEFr6Eg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 16/41] drivers: hv: Fix missing error code in vmbus_connect()
Date:   Mon,  5 Jul 2021 11:29:36 -0400
Message-Id: <20210705153001.1521447-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153001.1521447-1-sashal@kernel.org>
References: <20210705153001.1521447-1-sashal@kernel.org>
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
index 11170d9a2e1a..bfd7f00a59ec 100644
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

