Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 083DF4F33B9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237878AbiDEJEY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242794AbiDEItd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:49:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B4674DEE;
        Tue,  5 Apr 2022 01:37:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 317A1B81C19;
        Tue,  5 Apr 2022 08:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96157C385A0;
        Tue,  5 Apr 2022 08:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147853;
        bh=7Rkrs3sSrSyd8jDFyNshJ53iysc72CbfSpCQdoARRUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b9e87uoSquDRaT56EJKvhdH8/aUes8C/o+qQKiDgywRkVw69w5r8gWeOIghDH5Van
         vqzVa8b1WfhYY/F63E+M8QMtkWOLOt5tf71NQ3Zgm1d7n2/K+WLEVnbBhbKl2nIaAs
         1WZKoeqe8iytUEFyx+86N3gQ4hcIEWCNMOntvruw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pekka Pessi <ppessi@nvidia.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Jassi Brar <jaswinder.singh@linaro.org>
Subject: [PATCH 5.16 0144/1017] mailbox: tegra-hsp: Flush whole channel
Date:   Tue,  5 Apr 2022 09:17:37 +0200
Message-Id: <20220405070358.478359288@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
@@ -412,6 +412,11 @@ static int tegra_hsp_mailbox_flush(struc
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
 


