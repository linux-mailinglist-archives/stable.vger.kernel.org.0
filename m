Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCC5324FA73
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgHXIfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:35:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728147AbgHXIfm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:35:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1194204FD;
        Mon, 24 Aug 2020 08:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258142;
        bh=Sg+HY/SjwdFSUsZ8B4+SllnIJRTPqzEqXtxp20azwPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PMMqRkch9uMGIZKq26VWkyiltyNWPUxKccE4S/3sygciGhlz0qeu0mPXE3VuiqCyh
         DXMz1OQHdcdDI2uzMwxj+h/dt4LlIow9F9+MTZlGtG+8M68QnH/NtWE1VwvQPOyvgh
         ZOGmKaFltcqUShOg84lb62hvotRLWNaR4yJDBE0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evgeny Novikov <novikov@ispras.ru>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 051/148] media: vpss: clean up resources in init
Date:   Mon, 24 Aug 2020 10:29:09 +0200
Message-Id: <20200824082416.512536208@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evgeny Novikov <novikov@ispras.ru>

[ Upstream commit 9c487b0b0ea7ff22127fe99a7f67657d8730ff94 ]

If platform_driver_register() fails within vpss_init() resources are not
cleaned up. The patch fixes this issue by introducing the corresponding
error handling.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/davinci/vpss.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/davinci/vpss.c b/drivers/media/platform/davinci/vpss.c
index d38d2bbb6f0f8..7000f0bf0b353 100644
--- a/drivers/media/platform/davinci/vpss.c
+++ b/drivers/media/platform/davinci/vpss.c
@@ -505,19 +505,31 @@ static void vpss_exit(void)
 
 static int __init vpss_init(void)
 {
+	int ret;
+
 	if (!request_mem_region(VPSS_CLK_CTRL, 4, "vpss_clock_control"))
 		return -EBUSY;
 
 	oper_cfg.vpss_regs_base2 = ioremap(VPSS_CLK_CTRL, 4);
 	if (unlikely(!oper_cfg.vpss_regs_base2)) {
-		release_mem_region(VPSS_CLK_CTRL, 4);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err_ioremap;
 	}
 
 	writel(VPSS_CLK_CTRL_VENCCLKEN |
-		     VPSS_CLK_CTRL_DACCLKEN, oper_cfg.vpss_regs_base2);
+	       VPSS_CLK_CTRL_DACCLKEN, oper_cfg.vpss_regs_base2);
+
+	ret = platform_driver_register(&vpss_driver);
+	if (ret)
+		goto err_pd_register;
+
+	return 0;
 
-	return platform_driver_register(&vpss_driver);
+err_pd_register:
+	iounmap(oper_cfg.vpss_regs_base2);
+err_ioremap:
+	release_mem_region(VPSS_CLK_CTRL, 4);
+	return ret;
 }
 subsys_initcall(vpss_init);
 module_exit(vpss_exit);
-- 
2.25.1



