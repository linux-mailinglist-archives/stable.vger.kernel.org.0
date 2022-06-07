Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7474254199D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378141AbiFGVX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379116AbiFGVUC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:20:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBC5169DCB;
        Tue,  7 Jun 2022 11:59:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94710612F2;
        Tue,  7 Jun 2022 18:59:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C246C385A2;
        Tue,  7 Jun 2022 18:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628380;
        bh=enDk63P51EW+pA7YZE3qadFlH+8bEQ6EbgSaATVfMHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZDDhnC4yijarkzbkFEx8Z9nSCl6EsePjdpi51V6RRfm57nSbq0VOEucs4ISuT1xQZ
         eLgHvPYA+Zu5uQOVfzgVST7xkRt7r6peWS65W0jXTF9ONfZ7EKa26NtzR7pKfvp1cO
         ETEJCNEqXNEd4YKH6kGMn37eDo3kmLjmNKwEaRrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Lv Ruyi <lv.ruyi@zte.com.cn>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 308/879] ixp4xx_eth: fix error check return value of platform_get_irq()
Date:   Tue,  7 Jun 2022 18:57:06 +0200
Message-Id: <20220607165011.788341254@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Ruyi <lv.ruyi@zte.com.cn>

[ Upstream commit f45ba67eb74ab4b775616af731bdf8944afce3f1 ]

platform_get_irq() return negative value on failure, so null check of
return value is incorrect. Fix it by comparing whether it is less than
zero.

Fixes: 9055a2f59162 ("ixp4xx_eth: make ptp support a platform driver")
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20220412085126.2532924-1-lv.ruyi@zte.com.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xscale/ptp_ixp46x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xscale/ptp_ixp46x.c b/drivers/net/ethernet/xscale/ptp_ixp46x.c
index 1f382777aa5a..9abbdb71e629 100644
--- a/drivers/net/ethernet/xscale/ptp_ixp46x.c
+++ b/drivers/net/ethernet/xscale/ptp_ixp46x.c
@@ -271,7 +271,7 @@ static int ptp_ixp_probe(struct platform_device *pdev)
 	ixp_clock.master_irq = platform_get_irq(pdev, 0);
 	ixp_clock.slave_irq = platform_get_irq(pdev, 1);
 	if (IS_ERR(ixp_clock.regs) ||
-	    !ixp_clock.master_irq || !ixp_clock.slave_irq)
+	    ixp_clock.master_irq < 0 || ixp_clock.slave_irq < 0)
 		return -ENXIO;
 
 	ixp_clock.caps = ptp_ixp_caps;
-- 
2.35.1



