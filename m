Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1496C54151B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359496AbiFGU2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359672AbiFGUZN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:25:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859121D6860;
        Tue,  7 Jun 2022 11:32:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7EFAB81AEC;
        Tue,  7 Jun 2022 18:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549E8C385A5;
        Tue,  7 Jun 2022 18:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626740;
        bh=bYutRTyCZx340hOqd5JJwkoFAuQUP33ThESNoJBGSPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IrlXvPKBEZz+tDMU6i7QRVLcd9LY+FVVa2TBmZn9WnmKtKCsUrQcfPnJflmYn9ceU
         pvoTB0cXuWIALr/gXxCgFyXBKUhU1LT3O0R39N8C6Yw28jtvci2RRwpruQC2E6BPQy
         agGvN8Vq2qiMYH6enY4hQDKvS3WNDzFVQowUoMdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuanhong Guo <gch981213@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 488/772] arm: mediatek: select arch timer for mt7629
Date:   Tue,  7 Jun 2022 19:01:20 +0200
Message-Id: <20220607165003.365880088@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuanhong Guo <gch981213@gmail.com>

[ Upstream commit d66aea197d534e23d4989eb72fca9c0c114b97c9 ]

This chip has an armv7 arch timer according to the dts. Select it in
Kconfig to enforce the support for it.
Otherwise the system time is just completely wrong if user forget to
enable ARM_ARCH_TIMER in kernel config.

Fixes: a43379dddf1b ("arm: mediatek: add MT7629 smp bring up code")
Signed-off-by: Chuanhong Guo <gch981213@gmail.com>
Link: https://lore.kernel.org/r/20220409091347.2473449-1-gch981213@gmail.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-mediatek/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-mediatek/Kconfig b/arch/arm/mach-mediatek/Kconfig
index 9e0f592d87d8..35a3430c7942 100644
--- a/arch/arm/mach-mediatek/Kconfig
+++ b/arch/arm/mach-mediatek/Kconfig
@@ -30,6 +30,7 @@ config MACH_MT7623
 config MACH_MT7629
 	bool "MediaTek MT7629 SoCs support"
 	default ARCH_MEDIATEK
+	select HAVE_ARM_ARCH_TIMER
 
 config MACH_MT8127
 	bool "MediaTek MT8127 SoCs support"
-- 
2.35.1



