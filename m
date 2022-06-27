Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 682C655C3E4
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236265AbiF0LgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236076AbiF0LfY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:35:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD23DF1C;
        Mon, 27 Jun 2022 04:31:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FD50B81122;
        Mon, 27 Jun 2022 11:31:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B473C3411D;
        Mon, 27 Jun 2022 11:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329497;
        bh=uCms7sCXhbllyuq1NDeao1p5ydnZQ1Te9CfA6z5pYAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ATUa5CTFSnfSrzzIk/8FZxKNPeBSd15YiflameRjWHFNfHeoSxSFioWICa5Q0zzqg
         ZKUE+6jiMti2ZQxc9PWQcFHYMPbh7sptVlprK80FYz2q1ZmkwuoXriIj7w/XF6Uv7P
         /rB3StaMpxGUsptLTsX4M2S4ti2wVAKRlSkmGQp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chevron Li <chevron.li@bayhubtech.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 019/135] mmc: sdhci-pci-o2micro: Fix card detect by dealing with debouncing
Date:   Mon, 27 Jun 2022 13:20:26 +0200
Message-Id: <20220627111938.719601904@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chevron Li <chevron.li@bayhubtech.com>

commit e591fcf6b4e39335c9b128b17738fcd2fdd278ae upstream.

The result from ->get_cd() may be incorrect as the card detect debouncing
isn't managed correctly. Let's fix it.

Signed-off-by: Chevron Li<chevron.li@bayhubtech.com>
Fixes: 7d44061704dd ("mmc: sdhci-pci-o2micro: Fix O2 Host data read/write DLL Lock phase shift issue")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220602132543.596-1-chevron.li@bayhubtech.com
[Ulf: Updated the commit message]
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pci-o2micro.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mmc/host/sdhci-pci-o2micro.c
+++ b/drivers/mmc/host/sdhci-pci-o2micro.c
@@ -147,6 +147,8 @@ static int sdhci_o2_get_cd(struct mmc_ho
 
 	if (!(sdhci_readw(host, O2_PLL_DLL_WDT_CONTROL1) & O2_PLL_LOCK_STATUS))
 		sdhci_o2_enable_internal_clock(host);
+	else
+		sdhci_o2_wait_card_detect_stable(host);
 
 	return !!(sdhci_readl(host, SDHCI_PRESENT_STATE) & SDHCI_CARD_PRESENT);
 }


