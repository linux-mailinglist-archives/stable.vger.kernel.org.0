Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E465627CA4C
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730135AbgI2MSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:18:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729901AbgI2Lgv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:36:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65BE623A6C;
        Tue, 29 Sep 2020 11:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379101;
        bh=i8udMsq7B91YRlinCGJcAolZi31wX66Zkhx3F3Z/lnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BL958McyL7WvUd2nL3LZ8LVBn9PZMJx5xOamPlLklUglj/wNuUGklln18FNh6GAQk
         dZAHvbzXF7ZZhwOcX927BnehaxxyJ8f2d9ygFAqN9gMuWMYbSwENI8Dd5UKUSPqgz1
         Kl7teJqXrqV3FWwAxDLLDtVLFfYBInHN3QkHb3Xg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fuqian Huang <huangfq.daxian@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 015/388] m68k: q40: Fix info-leak in rtc_ioctl
Date:   Tue, 29 Sep 2020 12:55:46 +0200
Message-Id: <20200929110011.220784133@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fuqian Huang <huangfq.daxian@gmail.com>

[ Upstream commit 7cf78b6b12fd5550545e4b73b35dca18bd46b44c ]

When the option is RTC_PLL_GET, pll will be copied to userland
via copy_to_user. pll is initialized using mach_get_rtc_pll indirect
call and mach_get_rtc_pll is only assigned with function
q40_get_rtc_pll in arch/m68k/q40/config.c.
In function q40_get_rtc_pll, the field pll_ctrl is not initialized.
This will leak uninitialized stack content to userland.
Fix this by zeroing the uninitialized field.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
Link: https://lore.kernel.org/r/20190927121544.7650-1-huangfq.daxian@gmail.com
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/q40/config.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/m68k/q40/config.c b/arch/m68k/q40/config.c
index e63eb5f069995..f31890078197e 100644
--- a/arch/m68k/q40/config.c
+++ b/arch/m68k/q40/config.c
@@ -264,6 +264,7 @@ static int q40_get_rtc_pll(struct rtc_pll_info *pll)
 {
 	int tmp = Q40_RTC_CTRL;
 
+	pll->pll_ctrl = 0;
 	pll->pll_value = tmp & Q40_RTC_PLL_MASK;
 	if (tmp & Q40_RTC_PLL_SIGN)
 		pll->pll_value = -pll->pll_value;
-- 
2.25.1



