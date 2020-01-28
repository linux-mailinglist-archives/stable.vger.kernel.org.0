Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3225D14B9FD
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732442AbgA1OYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:24:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:50458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731386AbgA1OYB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:24:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D990E24686;
        Tue, 28 Jan 2020 14:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221440;
        bh=Ie4jcGFAb0xxjgmm9qal0iuc6BSGnHMiGldwTz30QUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JYvEfdUXfcE88uiC8X4L12bIf/frKimzF2WnrpGR5nUEASEW9fmFT08I6i7is3qRe
         4UlbymjVxJfkwQWspjDVc4waWN7rkbcBfpf1wcn9HRYL1CINVV5CoVX3xlFxcHFea8
         KPLA6HEk8J9Y8FGt7wEmVZm2mqZY+DQy0itPcL2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tiezhu Yang <yangtiezhu@loongson.cn>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Huacai Chen <chenhc@lemote.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        linux-mips@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 224/271] MIPS: Loongson: Fix return value of loongson_hwmon_init
Date:   Tue, 28 Jan 2020 15:06:13 +0100
Message-Id: <20200128135909.231827436@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit dece3c2a320b0a6d891da6ff774ab763969b6860 ]

When call function hwmon_device_register failed, use the actual
return value instead of always -ENOMEM.

Fixes: 64f09aa967e1 ("MIPS: Loongson-3: Add CPU Hwmon platform driver")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Paul Burton <paulburton@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: Huacai Chen <chenhc@lemote.com>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mips/cpu_hwmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/mips/cpu_hwmon.c b/drivers/platform/mips/cpu_hwmon.c
index 4300a558d0f39..d02214a3f8e3f 100644
--- a/drivers/platform/mips/cpu_hwmon.c
+++ b/drivers/platform/mips/cpu_hwmon.c
@@ -155,7 +155,7 @@ static int __init loongson_hwmon_init(void)
 
 	cpu_hwmon_dev = hwmon_device_register(NULL);
 	if (IS_ERR(cpu_hwmon_dev)) {
-		ret = -ENOMEM;
+		ret = PTR_ERR(cpu_hwmon_dev);
 		pr_err("hwmon_device_register fail!\n");
 		goto fail_hwmon_device_register;
 	}
-- 
2.20.1



