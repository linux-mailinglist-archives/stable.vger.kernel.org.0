Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 953404FD09E
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233506AbiDLGsd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350724AbiDLGrm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:47:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA7A324F04;
        Mon, 11 Apr 2022 23:39:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC26C61910;
        Tue, 12 Apr 2022 06:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E254FC385A1;
        Tue, 12 Apr 2022 06:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745558;
        bh=O4Q7iMYhGztqlp5ynInoHyNCuJYnTxVojEBSYkbHwHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1HeOhxkKffERb05/+JyVDrZgjE3Ohy/Y3fxpn4t3HrqLMQSDWjk9v4W3fiod13AEu
         m5TzMFl2pKZI24jjqVVYFXYwhIhacEIBipemQwK9XL8t/FIamyNfUtK1/kNtVgeBC5
         eiGZBmQul69s/6n/5SG/503UmxQwLVx1dRGui6S0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 137/171] mmc: renesas_sdhi: dont overwrite TAP settings when HS400 tuning is complete
Date:   Tue, 12 Apr 2022 08:30:28 +0200
Message-Id: <20220412062931.850991912@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
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

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

commit 03e59b1e2f56245163b14c69e0a830c24b1a3a47 upstream.

When HS400 tuning is complete and HS400 is going to be activated, we
have to keep the current number of TAPs and should not overwrite them
with a hardcoded value. This was probably a copy&paste mistake when
upporting HS400 support from the BSP.

Fixes: 26eb2607fa28 ("mmc: renesas_sdhi: add eMMC HS400 mode support")
Reported-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220404114902.12175-1-wsa+renesas@sang-engineering.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/renesas_sdhi_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/renesas_sdhi_core.c
+++ b/drivers/mmc/host/renesas_sdhi_core.c
@@ -390,10 +390,10 @@ static void renesas_sdhi_hs400_complete(
 			SH_MOBILE_SDHI_SCC_TMPPORT2_HS400OSEL) |
 			sd_scc_read32(host, priv, SH_MOBILE_SDHI_SCC_TMPPORT2));
 
-	/* Set the sampling clock selection range of HS400 mode */
 	sd_scc_write32(host, priv, SH_MOBILE_SDHI_SCC_DTCNTL,
 		       SH_MOBILE_SDHI_SCC_DTCNTL_TAPEN |
-		       0x4 << SH_MOBILE_SDHI_SCC_DTCNTL_TAPNUM_SHIFT);
+		       sd_scc_read32(host, priv,
+				     SH_MOBILE_SDHI_SCC_DTCNTL));
 
 	/* Avoid bad TAP */
 	if (bad_taps & BIT(priv->tap_set)) {


