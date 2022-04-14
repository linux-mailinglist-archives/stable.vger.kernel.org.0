Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A90F5013AB
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244562AbiDNNqX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245587AbiDNNio (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:38:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95FD4A56F6;
        Thu, 14 Apr 2022 06:33:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3279361CEE;
        Thu, 14 Apr 2022 13:33:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411A9C385A5;
        Thu, 14 Apr 2022 13:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943180;
        bh=5gMEj3ZWj3J619D91+lITZa60DsE37BTIQg8AHTGWuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dL9lbYyNPZkGd33TI2wGh8VbPZm907AdC9P26BIncLa4T6NsvcG8HxCEemKykt8CI
         Ajbj5dbcYw0l3wmv6Kvi4gdIXFZ5OzRJofQOP3ZDphPTIYiL3VGqrkYsck1MRZ6vsK
         vig+WpXLuXZClof/qdeMZoKQb6+9kH7kNV6xPwCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pekka Pessi <ppessi@nvidia.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Jassi Brar <jaswinder.singh@linaro.org>
Subject: [PATCH 5.4 064/475] mailbox: tegra-hsp: Flush whole channel
Date:   Thu, 14 Apr 2022 15:07:29 +0200
Message-Id: <20220414110856.944824177@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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
@@ -403,6 +403,11 @@ static int tegra_hsp_mailbox_flush(struc
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
 


