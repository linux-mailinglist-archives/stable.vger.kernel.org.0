Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F24505432
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239291AbiDRNEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241358AbiDRNDA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:03:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0937727155;
        Mon, 18 Apr 2022 05:43:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3182B80EC3;
        Mon, 18 Apr 2022 12:43:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01193C385A1;
        Mon, 18 Apr 2022 12:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285792;
        bh=Qem81bJBJ4bXuldztS3i1EFkoRvyIMTGFYIioO0Ei+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NC3pC4Uwpopo2dm0/gqKPU2cQf9LfQsuustWNUIxhggVoLzVRtjNqIKuXyc5tqvVF
         fzmx9oRfeeIHEM1nzrJeK7rAxLzQq5xe92gtfSm8sqGaIvbVTZFPI4NoijramzeXCw
         psUbVcx4pO8pKk4RcVXpAlwAsDNOy0eyjLLkNqNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leo Ruan <tingquan.ruan@cn.bosch.com>,
        Mark Jonas <mark.jonas@de.bosch.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 26/63] gpu: ipu-v3: Fix dev_dbg frequency output
Date:   Mon, 18 Apr 2022 14:13:23 +0200
Message-Id: <20220418121135.876117592@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121134.149115109@linuxfoundation.org>
References: <20220418121134.149115109@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Leo Ruan <tingquan.ruan@cn.bosch.com>

[ Upstream commit 070a88fd4a03f921b73a2059e97d55faaa447dab ]

This commit corrects the printing of the IPU clock error percentage if
it is between -0.1% to -0.9%. For example, if the pixel clock requested
is 27.2 MHz but only 27.0 MHz can be achieved the deviation is -0.8%.
But the fixed point math had a flaw and calculated error of 0.2%.

Before:
  Clocks: IPU 270000000Hz DI 24716667Hz Needed 27200000Hz
  IPU clock can give 27000000 with divider 10, error 0.2%
  Want 27200000Hz IPU 270000000Hz DI 24716667Hz using IPU, 27000000Hz

After:
  Clocks: IPU 270000000Hz DI 24716667Hz Needed 27200000Hz
  IPU clock can give 27000000 with divider 10, error -0.8%
  Want 27200000Hz IPU 270000000Hz DI 24716667Hz using IPU, 27000000Hz

Signed-off-by: Leo Ruan <tingquan.ruan@cn.bosch.com>
Signed-off-by: Mark Jonas <mark.jonas@de.bosch.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://lore.kernel.org/r/20220207151411.5009-1-mark.jonas@de.bosch.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/ipu-v3/ipu-di.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-di.c b/drivers/gpu/ipu-v3/ipu-di.c
index b4a31d506fcc..74eca68891ad 100644
--- a/drivers/gpu/ipu-v3/ipu-di.c
+++ b/drivers/gpu/ipu-v3/ipu-di.c
@@ -451,8 +451,9 @@ static void ipu_di_config_clock(struct ipu_di *di,
 
 		error = rate / (sig->mode.pixelclock / 1000);
 
-		dev_dbg(di->ipu->dev, "  IPU clock can give %lu with divider %u, error %d.%u%%\n",
-			rate, div, (signed)(error - 1000) / 10, error % 10);
+		dev_dbg(di->ipu->dev, "  IPU clock can give %lu with divider %u, error %c%d.%d%%\n",
+			rate, div, error < 1000 ? '-' : '+',
+			abs(error - 1000) / 10, abs(error - 1000) % 10);
 
 		/* Allow a 1% error */
 		if (error < 1010 && error >= 990) {
-- 
2.35.1



