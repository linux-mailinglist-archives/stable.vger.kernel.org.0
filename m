Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8134A4F2C39
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350452AbiDEJ6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343996AbiDEJQo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:16:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57BC10FFB;
        Tue,  5 Apr 2022 02:02:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5479FB81BAE;
        Tue,  5 Apr 2022 09:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B352BC385A0;
        Tue,  5 Apr 2022 09:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149371;
        bh=q1UeRlLEWK3JLoRsaXN04m0q8F3HuCNVdsPigD7nWpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K6PVNIiv82Qe+3nuubNep0Y5mfYkBGt3eZLqgLIAKe+SGQDfpS9p9gmC6ZI1uOL4o
         TF2N8HTJVR041lzlVxaMkMGRhN+Ygu8u5a3eRCBcqHnstdFh3sZ5lYqnmkIqm+nD8V
         mP6FTKqYwcygpwQHAqwHL/e/5WEtGhu0JldxDrQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacky Bai <ping.bai@nxp.com>,
        Robin Gong <yibin.gong@nxp.com>, Peng Fan <peng.fan@nxp.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0690/1017] mailbox: imx: fix crash in resume on i.mx8ulp
Date:   Tue,  5 Apr 2022 09:26:43 +0200
Message-Id: <20220405070414.756491194@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Gong <yibin.gong@nxp.com>

[ Upstream commit 8219efd08a0aa1d7944bdb66d84ba57549258968 ]

check 'priv->clk' before 'imx_mu_read()' otherwise crash happens on
i.mx8ulp, since clock not enabled.

Fixes: 4f0b776ef5831 ("mailbox: imx-mailbox: support i.MX8ULP MU")
Reviewed-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Robin Gong <yibin.gong@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/imx-mailbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/imx-mailbox.c b/drivers/mailbox/imx-mailbox.c
index 544de2db6453..3c9c87b9c872 100644
--- a/drivers/mailbox/imx-mailbox.c
+++ b/drivers/mailbox/imx-mailbox.c
@@ -718,7 +718,7 @@ static int __maybe_unused imx_mu_resume_noirq(struct device *dev)
 	 * send failed, may lead to system freeze. This issue
 	 * is observed by testing freeze mode suspend.
 	 */
-	if (!imx_mu_read(priv, priv->dcfg->xCR[0]) && !priv->clk) {
+	if (!priv->clk && !imx_mu_read(priv, priv->dcfg->xCR[0])) {
 		for (i = 0; i < IMX_MU_xCR_MAX; i++)
 			imx_mu_write(priv, priv->xcr[i], priv->dcfg->xCR[i]);
 	}
-- 
2.34.1



