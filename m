Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE155830E3
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242685AbiG0RnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242926AbiG0Rmu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:42:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC41B89AA4;
        Wed, 27 Jul 2022 09:52:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6DDFB821C5;
        Wed, 27 Jul 2022 16:52:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A09C433C1;
        Wed, 27 Jul 2022 16:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940736;
        bh=fuBdEORhVUHgoKP0511WtVTCy7BoG+RleVc/OuNVrLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CFr85k42K/0hzjbJFLDHewwTBHiZ2u8kEthZ60V+YrErEwAP0UpcvzKzuksq3ajM7
         GBcanww6RBcpyzx4Ivv0T6+xi0ijE8QrBH7AE4CmCVV7gtI4BhX+U1G4OaHWzSemZg
         TuNILn6atLq4S3yIrLoueQBssJu5iwNYZGPAuSr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Srinivas Neeli <srinivas.neeli@xilinx.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 129/158] gpio: gpio-xilinx: Fix integer overflow
Date:   Wed, 27 Jul 2022 18:13:13 +0200
Message-Id: <20220727161026.580717761@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Neeli <srinivas.neeli@xilinx.com>

[ Upstream commit 32c094a09d5829ad9b02cdf667569aefa8de0ea6 ]

Current implementation is not able to configure more than 32 pins
due to incorrect data type. So type casting with unsigned long
to avoid it.

Fixes: 02b3f84d9080 ("xilinx: Switch to use bitmap APIs")
Signed-off-by: Srinivas Neeli <srinivas.neeli@xilinx.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-xilinx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-xilinx.c b/drivers/gpio/gpio-xilinx.c
index b6d3a57e27ed..7f8e2fed2988 100644
--- a/drivers/gpio/gpio-xilinx.c
+++ b/drivers/gpio/gpio-xilinx.c
@@ -99,7 +99,7 @@ static inline void xgpio_set_value32(unsigned long *map, int bit, u32 v)
 	const unsigned long offset = (bit % BITS_PER_LONG) & BIT(5);
 
 	map[index] &= ~(0xFFFFFFFFul << offset);
-	map[index] |= v << offset;
+	map[index] |= (unsigned long)v << offset;
 }
 
 static inline int xgpio_regoffset(struct xgpio_instance *chip, int ch)
-- 
2.35.1



