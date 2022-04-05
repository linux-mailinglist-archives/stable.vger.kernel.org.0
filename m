Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFFD74F25B7
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbiDEHvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233572AbiDEHr6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:47:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2821B6;
        Tue,  5 Apr 2022 00:45:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A2C0B81A22;
        Tue,  5 Apr 2022 07:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E4CC3410F;
        Tue,  5 Apr 2022 07:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144746;
        bh=7Rkrs3sSrSyd8jDFyNshJ53iysc72CbfSpCQdoARRUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M0abJs02pVdj7cAKOvNJKUYIa9WhPbNdb982bu20Uzg9HSDM8CjYlNn4RY7eVU27d
         24jhg9ZJ647zNxPCkMpaPwNQLLKvHcWrJxE2RKjaCvb9MKNc+ABLduTVlziUi2IxZ5
         QdnCPKwRZOSMacrALQqypLmnSTRzJfzVOxYgFavU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pekka Pessi <ppessi@nvidia.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Jassi Brar <jaswinder.singh@linaro.org>
Subject: [PATCH 5.17 0139/1126] mailbox: tegra-hsp: Flush whole channel
Date:   Tue,  5 Apr 2022 09:14:46 +0200
Message-Id: <20220405070411.659077323@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
 


