Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5B7D4B47BB
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245662AbiBNJwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:52:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344537AbiBNJvs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:51:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5D366FBD;
        Mon, 14 Feb 2022 01:42:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8F72B80DC9;
        Mon, 14 Feb 2022 09:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E650AC340EF;
        Mon, 14 Feb 2022 09:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831776;
        bh=2bxlapIbZ7DOSdflx2EZloe76yIzRk8iWg3zk2A8E8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iDo2sk7567eAoMNYurRD6EAveASgk8R6mvl5yrpuBDq3OIAnuMQeyQ+Lvy+5Ndp1J
         gWmFFbcRL3w0ZcskFTGFt91E1PG4m3z+R/z/dQxzttLGOZuthPyEO2FxhPhVyIqdhK
         McyaLOie/H3qO8Fp7byyJCMUBeHsGpTfkVbIgTkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        stable@kernel.org, Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Subject: [PATCH 5.10 092/116] Revert "usb: dwc2: drd: fix soft connect when gadget is unconfigured"
Date:   Mon, 14 Feb 2022 10:26:31 +0100
Message-Id: <20220214092501.943849604@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 736e8d89044c1c330967fb938fa766cd9e0d8af0 upstream.

This reverts commit 269cbcf7b72de6f0016806d4a0cec1d689b55a87.

It causes build errors as reported by the kernel test robot.

Link: https://lore.kernel.org/r/202202112236.AwoOTtHO-lkp@intel.com
Reported-by: kernel test robot <lkp@intel.com>
Fixes: 269cbcf7b72d ("usb: dwc2: drd: fix soft connect when gadget is unconfigured")
Cc: stable@kernel.org
Cc: Amelie Delaunay <amelie.delaunay@foss.st.com>
Cc: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Cc: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/drd.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/usb/dwc2/drd.c
+++ b/drivers/usb/dwc2/drd.c
@@ -109,10 +109,8 @@ static int dwc2_drd_role_sw_set(struct u
 		already = dwc2_ovr_avalid(hsotg, true);
 	} else if (role == USB_ROLE_DEVICE) {
 		already = dwc2_ovr_bvalid(hsotg, true);
-		if (hsotg->enabled) {
-			/* This clear DCTL.SFTDISCON bit */
-			dwc2_hsotg_core_connect(hsotg);
-		}
+		/* This clear DCTL.SFTDISCON bit */
+		dwc2_hsotg_core_connect(hsotg);
 	} else {
 		if (dwc2_is_device_mode(hsotg)) {
 			if (!dwc2_ovr_bvalid(hsotg, false))


