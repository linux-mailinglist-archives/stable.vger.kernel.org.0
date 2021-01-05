Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46FE62EA76C
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 10:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbhAEJ3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 04:29:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:49192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728310AbhAEJ32 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Jan 2021 04:29:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3546E22A83;
        Tue,  5 Jan 2021 09:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609838910;
        bh=HStfKwrmpAr5P2MqB/ZHorfFw3JQjsPXE9k4Orej4Mc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b9YX0npMntiPGsU+sdlZ+Cu5oynR60G7ffOTLsAan34AF3bDD0bSlo6I741gvfOCY
         b/O8zHTBaZGyhWG22hMw43BbnQcPwwsL5dPZkVOdpXHzZM0D9w3x7NjNYZ8GlLkp2N
         TjF2avmT/JjtymiytF5Wwilx4qrzCrO59Q7HMwL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 22/29] rtc: sun6i: Fix memleak in sun6i_rtc_clk_init
Date:   Tue,  5 Jan 2021 10:29:08 +0100
Message-Id: <20210105090821.395352321@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210105090818.518271884@linuxfoundation.org>
References: <20210105090818.518271884@linuxfoundation.org>
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



