Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F56D521771
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242941AbiEJNZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242918AbiEJNZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:25:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A3B53A48;
        Tue, 10 May 2022 06:18:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D96761668;
        Tue, 10 May 2022 13:18:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CAEC385A6;
        Tue, 10 May 2022 13:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188698;
        bh=+grnLIzZYxR/nMl7yAVFrelR1Lzn8s2vGyxaI23KT5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SN+gw1V2vWdtwEsC9h25w0gqkfq9eQyoKiPY3swXwLkzxjQUKMMUMStmxvRRPnEH7
         yMAFDU/jKrRh+wR6J7ogvQsP/MjN/X9IZ/6VHiicfJxo0lY8F5CpXz9Evx4w6G9PPu
         aUk7p1Wi9WDeb5UhlZsijdH3aDelf/bJ+PC/Ij3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 4.19 15/88] usb: dwc3: core: Fix tx/rx threshold settings
Date:   Tue, 10 May 2022 15:07:00 +0200
Message-Id: <20220510130734.190151470@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130733.735278074@linuxfoundation.org>
References: <20220510130733.735278074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit f28ad9069363dec7deb88032b70612755eed9ee6 upstream.

The current driver logic checks against 0 to determine whether the
periodic tx/rx threshold settings are set, but we may get bogus values
from uninitialized variables if no device property is set. Properly
default these variables to 0.

Fixes: 938a5ad1d305 ("usb: dwc3: Check for ESS TX/RX threshold config")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/cccfce990b11b730b0dae42f9d217dc6fb988c90.1649727139.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1213,10 +1213,10 @@ static void dwc3_get_properties(struct d
 	u8			lpm_nyet_threshold;
 	u8			tx_de_emphasis;
 	u8			hird_threshold;
-	u8			rx_thr_num_pkt_prd;
-	u8			rx_max_burst_prd;
-	u8			tx_thr_num_pkt_prd;
-	u8			tx_max_burst_prd;
+	u8			rx_thr_num_pkt_prd = 0;
+	u8			rx_max_burst_prd = 0;
+	u8			tx_thr_num_pkt_prd = 0;
+	u8			tx_max_burst_prd = 0;
 
 	/* default to highest possible threshold */
 	lpm_nyet_threshold = 0xf;


