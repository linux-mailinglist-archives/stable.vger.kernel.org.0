Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEB534BE974
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348131AbiBUJON (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:14:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349892AbiBUJNB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:13:01 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4072DA84;
        Mon, 21 Feb 2022 01:06:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 490D0CE0E95;
        Mon, 21 Feb 2022 09:06:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30FB0C340EB;
        Mon, 21 Feb 2022 09:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434363;
        bh=yuq7N6KXFH+m2wC+MZgvdB7GI5U4Ag5FX7Z/OFPQx8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q2ij6y27JBkqv5Ioz38pKCK30FmZb+NXKhwP1PPzTS+2yS/ddNAUA6IAjkRcZNq0Z
         K7KZXEar5g0NfAAb9mLXzew991dBpddvqsks+w50GTSjNffYaT7kEzFUYI7e1aqkJx
         Bj5NAm4ksyv7Ni7ufUcRXLkHoO4INY9Vvwr4wAmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jae Hyun Yoo <jae.hyun.yoo@linux.intel.com>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Iwona Winiarska <iwona.winiarska@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 104/121] soc: aspeed: lpc-ctrl: Block error printing on probe defer cases
Date:   Mon, 21 Feb 2022 09:49:56 +0100
Message-Id: <20220221084924.694568480@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
References: <20220221084921.147454846@linuxfoundation.org>
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

From: Jae Hyun Yoo <jae.hyun.yoo@linux.intel.com>

[ Upstream commit 301a5d3ad2432d7829f59432ca0a93a6defbb9a1 ]

Add a checking code when it gets -EPROBE_DEFER while getting a clock
resource. In this case, it doesn't need to print out an error message
because the probing will be re-visited.

Signed-off-by: Jae Hyun Yoo <jae.hyun.yoo@linux.intel.com>
Signed-off-by: Joel Stanley <joel@jms.id.au>
Reviewed-by: Andrew Jeffery <andrew@aj.id.au>
Reviewed-by: Iwona Winiarska <iwona.winiarska@intel.com>
Link: https://lore.kernel.org/r/20211104173709.222912-1-jae.hyun.yoo@intel.com
Link: https://lore.kernel.org/r/20220201070118.196372-1-joel@jms.id.au'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/aspeed/aspeed-lpc-ctrl.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/soc/aspeed/aspeed-lpc-ctrl.c b/drivers/soc/aspeed/aspeed-lpc-ctrl.c
index 040c7dc1d4792..71b555c715d2e 100644
--- a/drivers/soc/aspeed/aspeed-lpc-ctrl.c
+++ b/drivers/soc/aspeed/aspeed-lpc-ctrl.c
@@ -251,10 +251,9 @@ static int aspeed_lpc_ctrl_probe(struct platform_device *pdev)
 	}
 
 	lpc_ctrl->clk = devm_clk_get(dev, NULL);
-	if (IS_ERR(lpc_ctrl->clk)) {
-		dev_err(dev, "couldn't get clock\n");
-		return PTR_ERR(lpc_ctrl->clk);
-	}
+	if (IS_ERR(lpc_ctrl->clk))
+		return dev_err_probe(dev, PTR_ERR(lpc_ctrl->clk),
+				     "couldn't get clock\n");
 	rc = clk_prepare_enable(lpc_ctrl->clk);
 	if (rc) {
 		dev_err(dev, "couldn't enable clock\n");
-- 
2.34.1



