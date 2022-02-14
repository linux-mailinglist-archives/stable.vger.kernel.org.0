Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 298CD4B4C2D
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240355AbiBNKhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:37:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348374AbiBNKfH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:35:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21CF0E0DA;
        Mon, 14 Feb 2022 02:02:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B333060DD9;
        Mon, 14 Feb 2022 10:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832F0C340EF;
        Mon, 14 Feb 2022 10:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832922;
        bh=2bxlapIbZ7DOSdflx2EZloe76yIzRk8iWg3zk2A8E8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CiLXei9GrM3w2SrHjf/ruxX4KE6zm/7WCFvLIy91mXNkkoseSK8Q9bsF9ndOC1bxk
         Yen7mIpmunNUx+x8xOsLT9tC+I/xxP3IObtslAhJXU92gynJ5bCjsYt+kUvkiUDVFy
         QvpiLc1or0c5eCtmZ9ra2qvFI2RbD8+oebPIGafM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        stable@kernel.org, Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Subject: [PATCH 5.16 167/203] Revert "usb: dwc2: drd: fix soft connect when gadget is unconfigured"
Date:   Mon, 14 Feb 2022 10:26:51 +0100
Message-Id: <20220214092515.921302103@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
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


