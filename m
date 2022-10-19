Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC692604756
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbiJSNhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232126AbiJSNgj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:36:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295AD18B4BF;
        Wed, 19 Oct 2022 06:25:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3558EB82472;
        Wed, 19 Oct 2022 09:04:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D4EC433C1;
        Wed, 19 Oct 2022 09:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170286;
        bh=hp2uKnZxl95or/B7zQYyBfDUtgIF706uAcUo2gKA3mI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UrS/PB5hDDJ4wq3mK42h2SzyLQ3eWWn6fDu6RhvI7qPxtaS+bhpdjGLoANHmmgA9w
         QGCvgHL0P8CXD04hulq8O9pQQgRHo7sDnGofDUY5l3uKLiGAyt7ita1TiYRop54OoY
         /aMMcPJwT4FF4axc9aaE1h2A95IZPvSH4PjKWXyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Wahren <stefan.wahren@i2se.com>,
        "Ivan T. Ivanov" <iivanov@suse.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 596/862] clk: bcm2835: fix bcm2835_clock_rate_from_divisor declaration
Date:   Wed, 19 Oct 2022 10:31:23 +0200
Message-Id: <20221019083316.304157786@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 19de0e83b65d..f1102b4c7e88 100644
--- a/drivers/clk/bcm/clk-bcm2835.c
+++ b/drivers/clk/bcm/clk-bcm2835.c
@@ -966,9 +966,9 @@ static u32 bcm2835_clock_choose_div(struct clk_hw *hw,
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



