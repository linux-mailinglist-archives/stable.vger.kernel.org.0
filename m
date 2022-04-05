Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5C904F3ABC
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237371AbiDELrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355248AbiDEKSn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:18:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D8FFD3A;
        Tue,  5 Apr 2022 03:04:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E633FB81C8B;
        Tue,  5 Apr 2022 10:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425AEC385A2;
        Tue,  5 Apr 2022 10:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153073;
        bh=CLWf3OMHKzeZvde0sUqk3oNEVx0H7Xs+0c0PJsByIdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YSm5xkFUkayn6nZEAuWe5/Uqv1Ga1MBxQSR+bKv1Reqj56WS6jYqVbPtBV25L81R3
         92n/WnjMs3nuATnm8o/FKBlsCkKQ8Mxo/PhFHBmRhO8R64IZqxtI0BpHMeFqw66pu/
         n7NKasoh0mO4zFUNfeLHfyVclaZsNuiA5Smj3rqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pekka Pessi <ppessi@nvidia.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Jassi Brar <jaswinder.singh@linaro.org>
Subject: [PATCH 5.10 093/599] mailbox: tegra-hsp: Flush whole channel
Date:   Tue,  5 Apr 2022 09:26:27 +0200
Message-Id: <20220405070301.595991009@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

From: Pekka Pessi <ppessi@nvidia.com>

commit 60de2d2dc284e0dd1c2c897d08625bde24ef3454 upstream.

The txdone can re-fill the mailbox. Keep polling the mailbox during the
flush until all the messages have been delivered.

This fixes an issue with the Tegra Combined UART (TCU) where output can
get truncated under high traffic load.

Signed-off-by: Pekka Pessi <ppessi@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Fixes: 91b1b1c3da8a ("mailbox: tegra-hsp: Add support for shared mailboxes")
Cc: stable@vger.kernel.org
Signed-off-by: Thierry Reding <treding@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mailbox/tegra-hsp.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/mailbox/tegra-hsp.c
+++ b/drivers/mailbox/tegra-hsp.c
@@ -410,6 +410,11 @@ static int tegra_hsp_mailbox_flush(struc
 		value = tegra_hsp_channel_readl(ch, HSP_SM_SHRD_MBOX);
 		if ((value & HSP_SM_SHRD_MBOX_FULL) == 0) {
 			mbox_chan_txdone(chan, 0);
+
+			/* Wait until channel is empty */
+			if (chan->active_req != NULL)
+				continue;
+
 			return 0;
 		}
 


