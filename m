Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C39214F2F4E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241480AbiDEKsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244528AbiDEJl1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:41:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0885BB935;
        Tue,  5 Apr 2022 02:26:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C9C161684;
        Tue,  5 Apr 2022 09:26:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BCC9C385A2;
        Tue,  5 Apr 2022 09:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150799;
        bh=zRmSmzz9vDRdCW6CbMwaehqfUXppBLkYD3vwE3+vKG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gXNlzMfKcT+wDUA5zvKnf+K9XprpbdnDNLz8d+KnUo7bS2g72x08q6xJdxfwd1GRf
         cEt4dhswI8caf0gbCYvn2PU3ZvdCRgTL0BYPAcnBduISwIhwwx43sz/1haHH+Ww56v
         fWqQZHyo5JFz02ipFUx2SLaGJ/7gOjgNZUz70Das=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Richard Zhu <hongxing.zhu@nxp.com>
Subject: [PATCH 5.15 186/913] PCI: imx6: Allow to probe when dw_pcie_wait_for_link() fails
Date:   Tue,  5 Apr 2022 09:20:48 +0200
Message-Id: <20220405070345.431700530@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Fabio Estevam <festevam@gmail.com>

commit f81f095e87715e198471f4653952fe5e3f824874 upstream.

The intention of commit 886a9c134755 ("PCI: dwc: Move link handling into
common code") was to standardize the behavior of link down as explained
in its commit log:

"The behavior for a link down was inconsistent as some drivers would fail
probe in that case while others succeed. Let's standardize this to
succeed as there are usecases where devices (and the link) appear later
even without hotplug. For example, a reconfigured FPGA device."

The pci-imx6 still fails to probe when the link is not present, which
causes the following warning:

imx6q-pcie 8ffc000.pcie: Phy link never came up
imx6q-pcie: probe of 8ffc000.pcie failed with error -110
------------[ cut here ]------------
WARNING: CPU: 0 PID: 30 at drivers/regulator/core.c:2257 _regulator_put.part.0+0x1b8/0x1dc
Modules linked in:
CPU: 0 PID: 30 Comm: kworker/u2:2 Not tainted 5.15.0-next-20211103 #1
Hardware name: Freescale i.MX6 SoloX (Device Tree)
Workqueue: events_unbound async_run_entry_fn
[<c0111730>] (unwind_backtrace) from [<c010bb74>] (show_stack+0x10/0x14)
[<c010bb74>] (show_stack) from [<c0f90290>] (dump_stack_lvl+0x58/0x70)
[<c0f90290>] (dump_stack_lvl) from [<c012631c>] (__warn+0xd4/0x154)
[<c012631c>] (__warn) from [<c0f87b00>] (warn_slowpath_fmt+0x74/0xa8)
[<c0f87b00>] (warn_slowpath_fmt) from [<c076b4bc>] (_regulator_put.part.0+0x1b8/0x1dc)
[<c076b4bc>] (_regulator_put.part.0) from [<c076b574>] (regulator_put+0x2c/0x3c)
[<c076b574>] (regulator_put) from [<c08c3740>] (release_nodes+0x50/0x178)

Fix this problem by ignoring the dw_pcie_wait_for_link() error like
it is done on the other dwc drivers.

Tested on imx6sx-sdb and imx6q-sabresd boards.

Link: https://lore.kernel.org/r/20220106103645.2790803-1-festevam@gmail.com
Fixes: 886a9c134755 ("PCI: dwc: Move link handling into common code")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Richard Zhu <hongxing.zhu@nxp.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-imx6.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -779,9 +779,7 @@ static int imx6_pcie_start_link(struct d
 	/* Start LTSSM. */
 	imx6_pcie_ltssm_enable(dev);
 
-	ret = dw_pcie_wait_for_link(pci);
-	if (ret)
-		goto err_reset_phy;
+	dw_pcie_wait_for_link(pci);
 
 	if (pci->link_gen == 2) {
 		/* Allow Gen2 mode after the link is up. */
@@ -817,11 +815,7 @@ static int imx6_pcie_start_link(struct d
 		}
 
 		/* Make sure link training is finished as well! */
-		ret = dw_pcie_wait_for_link(pci);
-		if (ret) {
-			dev_err(dev, "Failed to bring link up!\n");
-			goto err_reset_phy;
-		}
+		dw_pcie_wait_for_link(pci);
 	} else {
 		dev_info(dev, "Link: Gen2 disabled\n");
 	}


