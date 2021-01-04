Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAEE82E9A9C
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729668AbhADQML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:12:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:37132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728197AbhADQAF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:00:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2EED207AE;
        Mon,  4 Jan 2021 15:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609775926;
        bh=HStfKwrmpAr5P2MqB/ZHorfFw3JQjsPXE9k4Orej4Mc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a6y9j4Ij6haYN0/Td3HiEFdn/TBd2L7Wc6pN3PyUY+SBP2hgeIjnJWK7z6JGg1KzP
         R8VD6iyRCZ0BN5SIQB964421k4G0OUKScMXPHYCin6k62pUtbpm4t3gH1T49r3zE8h
         BgvmFwUlZmMJ1BoFC6+b64bl5Bu/3md2/3SBrrGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 28/35] rtc: sun6i: Fix memleak in sun6i_rtc_clk_init
Date:   Mon,  4 Jan 2021 16:57:31 +0100
Message-Id: <20210104155704.766192222@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155703.375788488@linuxfoundation.org>
References: <20210104155703.375788488@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 28d211919e422f58c1e6c900e5810eee4f1ce4c8 ]

When clk_hw_register_fixed_rate_with_accuracy() fails,
clk_data should be freed. It's the same for the subsequent
two error paths, but we should also unregister the already
registered clocks in them.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20201020061226.6572-1-dinghao.liu@zju.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-sun6i.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-sun6i.c b/drivers/rtc/rtc-sun6i.c
index 2cd5a7b1a2e30..e85abe8056064 100644
--- a/drivers/rtc/rtc-sun6i.c
+++ b/drivers/rtc/rtc-sun6i.c
@@ -232,7 +232,7 @@ static void __init sun6i_rtc_clk_init(struct device_node *node)
 								300000000);
 	if (IS_ERR(rtc->int_osc)) {
 		pr_crit("Couldn't register the internal oscillator\n");
-		return;
+		goto err;
 	}
 
 	parents[0] = clk_hw_get_name(rtc->int_osc);
@@ -248,7 +248,7 @@ static void __init sun6i_rtc_clk_init(struct device_node *node)
 	rtc->losc = clk_register(NULL, &rtc->hw);
 	if (IS_ERR(rtc->losc)) {
 		pr_crit("Couldn't register the LOSC clock\n");
-		return;
+		goto err_register;
 	}
 
 	of_property_read_string_index(node, "clock-output-names", 1,
@@ -259,7 +259,7 @@ static void __init sun6i_rtc_clk_init(struct device_node *node)
 					  &rtc->lock);
 	if (IS_ERR(rtc->ext_losc)) {
 		pr_crit("Couldn't register the LOSC external gate\n");
-		return;
+		goto err_register;
 	}
 
 	clk_data->num = 2;
@@ -268,6 +268,8 @@ static void __init sun6i_rtc_clk_init(struct device_node *node)
 	of_clk_add_hw_provider(node, of_clk_hw_onecell_get, clk_data);
 	return;
 
+err_register:
+	clk_hw_unregister_fixed_rate(rtc->int_osc);
 err:
 	kfree(clk_data);
 }
-- 
2.27.0



