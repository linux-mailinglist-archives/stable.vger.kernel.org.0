Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFAF4FCBE9
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 03:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239536AbiDLBgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 21:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbiDLBgG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 21:36:06 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B9819C21;
        Mon, 11 Apr 2022 18:33:50 -0700 (PDT)
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 3A276404CA;
        Tue, 12 Apr 2022 01:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1649727230; bh=b9rZPdo/xNFCKfdrAM8qTsXc1lxV16YeecqOvKcWCbY=;
        h=Date:From:Subject:To:Cc:From;
        b=IGK5Dos4N4vKeey6PVzC7uSLyRClw3xRqwMxrkbdYNoWiFqAftDwv4dIYrLgJFGo8
         zTVutN2YMjdUD/BpFRqhx2PzV67qjqQefvD1tuCji2i0xnJlQfJqU+1CIj389PAPML
         0Z4BChGDLhhL23gFbBKVYVtmnQGL8uTqt7lhICVPdlcH3a+qQW8RjqvQr8X1Jw5AsV
         P2f2/wwLk9gpT+iCEZuxcg+zg3Trhc27r85Gi0pIY8fWngd9dcNNbsn7xMBQquWjKh
         WiFbPOCuvlRmv1Q8/aF2Plcscb9IGqc1xPZFaAoz7G5KjLgjoOy6RwtyzHREhRURHL
         LAF1FCUGSs39A==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 47D5AA0065;
        Tue, 12 Apr 2022 01:33:47 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Mon, 11 Apr 2022 18:33:47 -0700
Date:   Mon, 11 Apr 2022 18:33:47 -0700
Message-Id: <cccfce990b11b730b0dae42f9d217dc6fb988c90.1649727139.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH] usb: dwc3: core: Fix tx/rx threshold settings
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        <stable@vger.kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The current driver logic checks against 0 to determine whether the
periodic tx/rx threshold settings are set, but we may get bogus values
from uninitialized variables if no device property is set. Properly
default these variables to 0.

Cc: <stable@vger.kernel.org>
Fixes: 938a5ad1d305 ("usb: dwc3: Check for ESS TX/RX threshold config")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/dwc3/core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 1170b800acdc..1e068551dc7a 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1377,10 +1377,10 @@ static void dwc3_get_properties(struct dwc3 *dwc)
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
 	u8			tx_fifo_resize_max_num;
 	const char		*usb_psy_name;
 	int			ret;

base-commit: b3fa25de31fb7e9afebe9599b8ff32eda13d7c94
-- 
2.28.0

