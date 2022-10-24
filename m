Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2DE060A612
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233891AbiJXMbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234241AbiJXM3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:29:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7468A868B4;
        Mon, 24 Oct 2022 05:03:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5DF8612BE;
        Mon, 24 Oct 2022 12:02:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7EDCC433D6;
        Mon, 24 Oct 2022 12:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612967;
        bh=J5kxD+IcyiLjueojU6BHKyBWY1G0nIvUI3uXZKpvxz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=spjDvkWrXYnbEaWe464ksIydaOY6eQ2c4SNmi0YJGLD30VrkSdOULVqIwqOfnk/Zf
         Hec1APiHN0XyMjYXw6AE2PM9TgxNwbnWG2jLkWXf0lcQltOneunZc1f8TSSfUNdWLP
         bFea9V2PF9NTeWMSXCkrEAThhpR7tnq7kFPr2d0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Wahren <stefan.wahren@i2se.com>,
        "Ivan T. Ivanov" <iivanov@suse.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 156/229] clk: bcm2835: fix bcm2835_clock_rate_from_divisor declaration
Date:   Mon, 24 Oct 2022 13:31:15 +0200
Message-Id: <20221024113004.055435333@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <stefan.wahren@i2se.com>

[ Upstream commit 0b919a3728691c172312dee99ba654055ccd8c84 ]

The return value of bcm2835_clock_rate_from_divisor is always unsigned
and also all caller expect this. So fix the declaration accordingly.

Fixes: 41691b8862e2 ("clk: bcm2835: Add support for programming the audio domain clocks")
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Link: https://lore.kernel.org/r/20220904141037.38816-1-stefan.wahren@i2se.com
Reviewed-by: Ivan T. Ivanov <iivanov@suse.de>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/bcm/clk-bcm2835.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/bcm/clk-bcm2835.c b/drivers/clk/bcm/clk-bcm2835.c
index fd78dd5356ed..5a2f8d5d8d7a 100644
--- a/drivers/clk/bcm/clk-bcm2835.c
+++ b/drivers/clk/bcm/clk-bcm2835.c
@@ -950,9 +950,9 @@ static u32 bcm2835_clock_choose_div(struct clk_hw *hw,
 	return div;
 }
 
-static long bcm2835_clock_rate_from_divisor(struct bcm2835_clock *clock,
-					    unsigned long parent_rate,
-					    u32 div)
+static unsigned long bcm2835_clock_rate_from_divisor(struct bcm2835_clock *clock,
+						     unsigned long parent_rate,
+						     u32 div)
 {
 	const struct bcm2835_clock_data *data = clock->data;
 	u64 temp;
-- 
2.35.1



