Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9A9F6ECDCC
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbjDXN0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232215AbjDXN0y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:26:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99707618B
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:26:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 326ED622D7
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:26:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F07C433EF;
        Mon, 24 Apr 2023 13:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342811;
        bh=f+RfwfcYOEofk3mFyHM16hFlSGfFoGNS42yTFlfIl4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bwtXe4sJvHYEXuzcGkLeyqcTZ0AQnbxrjCguimw4dv+1mqINUnuulnNOSlHM/rVMv
         Rbo67IK9syn9FbpnPGw5NVJK+is9wTMOFAnmLTajbMNIUAzBZPywpxOC4NNvbGEysN
         2FQXHrUP5Q+o2h/Ft6MgXjKgA66Kk+xINz4KsUXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bhavya Kapoor <b-kapoor@ti.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 66/98] mmc: sdhci_am654: Set HIGH_SPEED_ENA for SDR12 and SDR25
Date:   Mon, 24 Apr 2023 15:17:29 +0200
Message-Id: <20230424131136.396648676@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bhavya Kapoor <b-kapoor@ti.com>

commit 2265098fd6a6272fde3fd1be5761f2f5895bd99a upstream.

Timing Information in Datasheet assumes that HIGH_SPEED_ENA=1 should be
set for SDR12 and SDR25 modes. But sdhci_am654 driver clears
HIGH_SPEED_ENA register. Thus, Modify sdhci_am654 to not clear
HIGH_SPEED_ENA (HOST_CONTROL[2]) bit for SDR12 and SDR25 speed modes.

Fixes: e374e87538f4 ("mmc: sdhci_am654: Clear HISPD_ENA in some lower speed modes")
Signed-off-by: Bhavya Kapoor <b-kapoor@ti.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230317092711.660897-1-b-kapoor@ti.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci_am654.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -351,8 +351,6 @@ static void sdhci_am654_write_b(struct s
 		 */
 		case MMC_TIMING_SD_HS:
 		case MMC_TIMING_MMC_HS:
-		case MMC_TIMING_UHS_SDR12:
-		case MMC_TIMING_UHS_SDR25:
 			val &= ~SDHCI_CTRL_HISPD;
 		}
 	}


