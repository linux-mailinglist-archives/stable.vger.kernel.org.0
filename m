Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEBB608A30
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234851AbiJVIr5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234877AbiJVIqb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:46:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9234B9A3;
        Sat, 22 Oct 2022 01:09:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5305B82E1A;
        Sat, 22 Oct 2022 08:06:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3D3C4314B;
        Sat, 22 Oct 2022 08:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425991;
        bh=COvMImI5EhtK7DDUN4rrlXlj6Olbp9bHPrM5fbNPEo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RwTqQDoT9ysKXYqtbughlfOaBbqosNziKaz5M32/TZSV00jL0+JPeUceMTXcibsVn
         WAW+DleQGn4FubijEzD4tOz/5fQSsnBqyb7X4vTp/x7y7by2JmDXFhqwMgmpYWgjO3
         zUBu+h8Dj8I+v4aHm9p0+DUj0+VLacZFpU56qqDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Justin Chen <justinpopo6@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 655/717] usb: host: xhci-plat: suspend and resume clocks
Date:   Sat, 22 Oct 2022 09:28:54 +0200
Message-Id: <20221022072527.371600576@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index a8641b6536ee..ef10982ad482 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -437,7 +437,16 @@ static int __maybe_unused xhci_plat_suspend(struct device *dev)
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
@@ -446,6 +455,11 @@ static int __maybe_unused xhci_plat_resume(struct device *dev)
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
index 7caa0db5e826..6dfbf73ee840 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1899,6 +1899,7 @@ struct xhci_hcd {
 #define XHCI_NO_SOFT_RETRY	BIT_ULL(40)
 #define XHCI_BROKEN_D3COLD	BIT_ULL(41)
 #define XHCI_EP_CTX_BROKEN_DCS	BIT_ULL(42)
+#define XHCI_SUSPEND_RESUME_CLKS	BIT_ULL(43)
 
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
-- 
2.35.1



