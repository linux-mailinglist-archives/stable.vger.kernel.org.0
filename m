Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE6DA4BDBD5
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350621AbiBUJtq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:49:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352978AbiBUJsF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:48:05 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4386BF25;
        Mon, 21 Feb 2022 01:22:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A50D1CE0E8B;
        Mon, 21 Feb 2022 09:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8C2C340E9;
        Mon, 21 Feb 2022 09:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435329;
        bh=mc0aKOxSsDuTXpmJoC/IG9w3zf1N4r0QHjUEA7j//a4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W6YOrFc9EjaJOeL+Qxfp1il7YRCjFa8+dc1lkTCbDUD9suRhDkMC8OzAeK9A2US0x
         4GBz0zjhwwU8IMSuqotR8fmtiD/ynJaMjaIbyuc5DYrgpQNDDSzgDhcbtmUMjwLL6Y
         Nmg4AXsXLT4KZPMzJIqIWzuZ9YUt2ZOzDdlg9vYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gatis Peisenieks <gatis@mikrotik.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.16 126/227] atl1c: fix tx timeout after link flap on Mikrotik 10/25G NIC
Date:   Mon, 21 Feb 2022 09:49:05 +0100
Message-Id: <20220221084939.035155227@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
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

From: Gatis Peisenieks <gatis@mikrotik.com>

commit bf8e59fd315f304eb538546e35de6dc603e4709f upstream.

If NIC had packets in tx queue at the moment link down event
happened, it could result in tx timeout when link got back up.

Since device has more than one tx queue we need to reset them
accordingly.

Fixes: 057f4af2b171 ("atl1c: add 4 RX/TX queue support for Mikrotik 10/25G NIC")
Signed-off-by: Gatis Peisenieks <gatis@mikrotik.com>
Link: https://lore.kernel.org/r/20220211065123.4187615-1-gatis@mikrotik.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -900,7 +900,7 @@ static void atl1c_clean_tx_ring(struct a
 		atl1c_clean_buffer(pdev, buffer_info);
 	}
 
-	netdev_reset_queue(adapter->netdev);
+	netdev_tx_reset_queue(netdev_get_tx_queue(adapter->netdev, queue));
 
 	/* Zero out Tx-buffers */
 	memset(tpd_ring->desc, 0, sizeof(struct atl1c_tpd_desc) *


