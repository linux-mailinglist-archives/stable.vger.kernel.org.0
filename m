Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB4806B46CE
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232891AbjCJOrA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:47:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbjCJOqv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:46:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB5810D31D
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:46:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B65C1B822DE
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:46:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285DEC4339B;
        Fri, 10 Mar 2023 14:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459584;
        bh=LDaJy4Bc+2oN7kq7ywF7BTVGjXNnKd1/9uCRA+fMpds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1DPVeFU1ykJFHvP+VIxB1cIJ91yCjDovgq9dPAl54yRWnp2BMlxVqlq+VIQFVAMya
         k+W7K89nOZs2nyP5SESKnlkXuxn20SsQNDTy0YOO2MGdB3wLcbV0sEdOaKGfVqj22q
         Bxk0dto8IN+cQ2+9saYpdYMe2WZWKLeh0izGAu+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/529] ARM: OMAP1: call platform_device_put() in error case in omap1_dm_timer_init()
Date:   Fri, 10 Mar 2023 14:32:45 +0100
Message-Id: <20230310133806.014928442@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 0414a100d6ab32721efa70ab55524540fdfe0ede ]

If platform_device_add() is not called or failed, it should call
platform_device_put() in error case.

Fixes: 97933d6ced60 ("ARM: OMAP1: dmtimer: conversion to platform devices")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Message-Id: <20220701094602.2365099-1-yangyingliang@huawei.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap1/timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap1/timer.c b/arch/arm/mach-omap1/timer.c
index 97fc2096b9709..05f016d5e9f67 100644
--- a/arch/arm/mach-omap1/timer.c
+++ b/arch/arm/mach-omap1/timer.c
@@ -165,7 +165,7 @@ static int __init omap1_dm_timer_init(void)
 	kfree(pdata);
 
 err_free_pdev:
-	platform_device_unregister(pdev);
+	platform_device_put(pdev);
 
 	return ret;
 }
-- 
2.39.2



