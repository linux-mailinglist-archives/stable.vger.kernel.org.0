Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC14951A72B
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238498AbiEDRCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354578AbiEDQ6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:58:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BBA18E23;
        Wed,  4 May 2022 09:50:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E911CB8279F;
        Wed,  4 May 2022 16:50:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D300C385AA;
        Wed,  4 May 2022 16:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683032;
        bh=VGWrJMBsSJWCvY6Eyia1YHHjBx1J6WcAmycKjTLapLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h0DSob0j8pvFza690DqTFXDE5rt7XdGWt5O1SfzKIW/EK1V3Jz4lFcwd/T8uQ80Xl
         H2howAacZk7jrrON+owjGrPWaWujnU+4ktCxylG2vRgwDjGrXWOSTlwIgC+1tI1hM3
         7geymiR0aZBHrRhoe2kYtX5wVvtE+xYls/B7HIpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.10 023/129] usb: dwc3: core: Fix tx/rx threshold settings
Date:   Wed,  4 May 2022 18:43:35 +0200
Message-Id: <20220504153023.099065718@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
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
@@ -1277,10 +1277,10 @@ static void dwc3_get_properties(struct d
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


