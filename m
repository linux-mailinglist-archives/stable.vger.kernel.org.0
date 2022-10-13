Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09A895FD0C1
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbiJMAaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbiJMA1d (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:27:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B651285DD;
        Wed, 12 Oct 2022 17:25:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E3DEB81AD1;
        Thu, 13 Oct 2022 00:21:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B02C43470;
        Thu, 13 Oct 2022 00:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620507;
        bh=sW2TOH8kBe4cOEFZHrcmXrRvugOzIf3vR71qytDvtIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZsXmI3n2Wa0DnTvyJP6GOZjzaiYfcF3yqsTbsFXx+u0RJbkMFjzU8/bU6UOBB53QW
         6Jt291nncEtasShq1veV1UdEMMlnbHiTAHEViOa2wi8+WsDXvRQ/TxRd1PQBDTJhsl
         948eUYTNxgtCt17Koleivxlt4ENa5ZLdgUCghfIdmlG6DC/iFPWuGQ54Y4wXE2C7rV
         kYq/LZrITDc6GhEobUL/FT4jxiyzP2Lm+cZe1lNqkuq8m4VdJsZigwXvIAV3zeldKl
         3zPI10RfUcSjgol46x4qUuwcfDlrYEQSxz0ApAzyJc051kkidLZjmjgK3liClS9g74
         01j9ZsHgTjIHg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Justin Chen <justinpopo6@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, mathias.nyman@intel.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 05/47] usb: host: xhci-plat: suspend and resume clocks
Date:   Wed, 12 Oct 2022 20:20:40 -0400
Message-Id: <20221013002124.1894077-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013002124.1894077-1-sashal@kernel.org>
References: <20221013002124.1894077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Justin Chen <justinpopo6@gmail.com>

[ Upstream commit 8bd954c56197caf5e3a804d989094bc3fe6329aa ]

Introduce XHCI_SUSPEND_RESUME_CLKS quirk as a means to suspend and resume
clocks if the hardware is capable of doing so. We assume that clocks will
be needed if the device may wake.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Justin Chen <justinpopo6@gmail.com>
Link: https://lore.kernel.org/r/1660170455-15781-2-git-send-email-justinpopo6@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-plat.c | 16 +++++++++++++++-
 drivers/usb/host/xhci.h      |  1 +
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index dc570ce4e831..2687662f26b6 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -447,7 +447,16 @@ static int __maybe_unused xhci_plat_suspend(struct device *dev)
 	 * xhci_suspend() needs `do_wakeup` to know whether host is allowed
 	 * to do wakeup during suspend.
 	 */
-	return xhci_suspend(xhci, device_may_wakeup(dev));
+	ret = xhci_suspend(xhci, device_may_wakeup(dev));
+	if (ret)
+		return ret;
+
+	if (!device_may_wakeup(dev) && (xhci->quirks & XHCI_SUSPEND_RESUME_CLKS)) {
+		clk_disable_unprepare(xhci->clk);
+		clk_disable_unprepare(xhci->reg_clk);
+	}
+
+	return 0;
 }
 
 static int __maybe_unused xhci_plat_resume(struct device *dev)
@@ -456,6 +465,11 @@ static int __maybe_unused xhci_plat_resume(struct device *dev)
 	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
 	int ret;
 
+	if (!device_may_wakeup(dev) && (xhci->quirks & XHCI_SUSPEND_RESUME_CLKS)) {
+		clk_prepare_enable(xhci->clk);
+		clk_prepare_enable(xhci->reg_clk);
+	}
+
 	ret = xhci_priv_resume_quirk(hcd);
 	if (ret)
 		return ret;
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 10a4230d95c3..3b39501f26ea 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1903,6 +1903,7 @@ struct xhci_hcd {
 #define XHCI_NO_SOFT_RETRY	BIT_ULL(40)
 #define XHCI_BROKEN_D3COLD	BIT_ULL(41)
 #define XHCI_EP_CTX_BROKEN_DCS	BIT_ULL(42)
+#define XHCI_SUSPEND_RESUME_CLKS	BIT_ULL(43)
 
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
-- 
2.35.1

