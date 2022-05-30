Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 512CF537F57
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235829AbiE3NxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239311AbiE3Nv1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:51:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC1984A36;
        Mon, 30 May 2022 06:36:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96DDCB80AE8;
        Mon, 30 May 2022 13:36:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DEEAC3411A;
        Mon, 30 May 2022 13:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917783;
        bh=G45LbsVsKGm/veOUJ8V2dv8LiU/3OcCdVZgGMgEciHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VWY+/g8qzzej0RxXDDca/y/7PL+ggwbLNLG0su+M10LAAqDrBgoL1HHnKe4PDAOnR
         Z8o9kuA2VqWjdNS+P4F3+bvSLhD2DFRqbycquuwI1U9FCdnijucY0kNm4aCJrVYg4s
         ghD1r6H4lnent3tOUiH53JQdDyxt+OjbWhU21fpBK8hRFIviVdhgNta7CeXeFZwsDj
         gswYb9Cv6EeGa4hnAAmgQA32gtiG2d1y8ivADDWgNUYg3Hz591Sdku4aHeXfW3OXwJ
         qgq0zDbvjmNiu58I2SLoSmFeh/BO46PtPbEXW6kI+nM/f/HhaZYmLKt/NMh+S86rIV
         QUnsXFn0omEHw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 096/135] media: ccs-core.c: fix failure to call clk_disable_unprepare
Date:   Mon, 30 May 2022 09:30:54 -0400
Message-Id: <20220530133133.1931716-96-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit eca89cf60b040ee2cae693ea72a0364284f3084c ]

Fixes smatch warning:

drivers/media/i2c/ccs/ccs-core.c:1676 ccs_power_on() warn: 'sensor->ext_clk' from clk_prepare_enable() not released on lines: 1606.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ccs/ccs-core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ccs/ccs-core.c b/drivers/media/i2c/ccs/ccs-core.c
index 9158d3ce45c0..1649b7a9ff72 100644
--- a/drivers/media/i2c/ccs/ccs-core.c
+++ b/drivers/media/i2c/ccs/ccs-core.c
@@ -1603,8 +1603,11 @@ static int ccs_power_on(struct device *dev)
 			usleep_range(1000, 2000);
 		} while (--retry);
 
-		if (!reset)
-			return -EIO;
+		if (!reset) {
+			dev_err(dev, "software reset failed\n");
+			rval = -EIO;
+			goto out_cci_addr_fail;
+		}
 	}
 
 	if (sensor->hwcfg.i2c_addr_alt) {
-- 
2.35.1

