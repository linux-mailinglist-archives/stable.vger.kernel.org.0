Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF1FA5FDFC9
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 19:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbiJMR6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 13:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbiJMR5o (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 13:57:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90911F032;
        Thu, 13 Oct 2022 10:56:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07C38B82037;
        Thu, 13 Oct 2022 17:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC4DC433C1;
        Thu, 13 Oct 2022 17:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665683805;
        bh=yfuwSu2LvEmBXUYabPLQFqgi4vteAQpkcYKtmacqVj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XFWRKjZI59t8i4+C+gXwM9x9zpz5faC9v27Xk5sfN3cpQrfLsgRaWcckHP2BbX1ko
         d5rDytqt8TNXxPVxW39VLM1O3urIDC0i7fEVOLJ9nvpjz2awwTxrrPqKDU3GBQAYst
         AdLkgxukpIYN/tKkoNRszI3Q241RHXuAyUL9OU1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Shunsuke Mie <mie@igel.co.jp>
Subject: [PATCH 5.10 54/54] misc: pci_endpoint_test: Fix pci_endpoint_test_{copy,write,read}() panic
Date:   Thu, 13 Oct 2022 19:52:48 +0200
Message-Id: <20221013175148.642238012@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175147.337501757@linuxfoundation.org>
References: <20221013175147.337501757@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shunsuke Mie <mie@igel.co.jp>

commit 8e30538eca016de8e252bef174beadecd64239f0 upstream.

The dma_map_single() doesn't permit zero length mapping. It causes a follow
panic.

A panic was reported on arm64:

[   60.137988] ------------[ cut here ]------------
[   60.142630] kernel BUG at kernel/dma/swiotlb.c:624!
[   60.147508] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
[   60.152992] Modules linked in: dw_hdmi_cec crct10dif_ce simple_bridge rcar_fdp1 vsp1 rcar_vin videobuf2_vmalloc rcar_csi2 v4l
2_mem2mem videobuf2_dma_contig videobuf2_memops pci_endpoint_test videobuf2_v4l2 videobuf2_common rcar_fcp v4l2_fwnode v4l2_asyn
c videodev mc gpio_bd9571mwv max9611 pwm_rcar ccree at24 authenc libdes phy_rcar_gen3_usb3 usb_dmac display_connector pwm_bl
[   60.186252] CPU: 0 PID: 508 Comm: pcitest Not tainted 6.0.0-rc1rpci-dev+ #237
[   60.193387] Hardware name: Renesas Salvator-X 2nd version board based on r8a77951 (DT)
[   60.201302] pstate: 00000005 (nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   60.208263] pc : swiotlb_tbl_map_single+0x2c0/0x590
[   60.213149] lr : swiotlb_map+0x88/0x1f0
[   60.216982] sp : ffff80000a883bc0
[   60.220292] x29: ffff80000a883bc0 x28: 0000000000000000 x27: 0000000000000000
[   60.227430] x26: 0000000000000000 x25: ffff0004c0da20d0 x24: ffff80000a1f77c0
[   60.234567] x23: 0000000000000002 x22: 0001000040000010 x21: 000000007a000000
[   60.241703] x20: 0000000000200000 x19: 0000000000000000 x18: 0000000000000000
[   60.248840] x17: 0000000000000000 x16: 0000000000000000 x15: ffff0006ff7b9180
[   60.255977] x14: ffff0006ff7b9180 x13: 0000000000000000 x12: 0000000000000000
[   60.263113] x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000000
[   60.270249] x8 : 0001000000000010 x7 : ffff0004c6754b20 x6 : 0000000000000000
[   60.277385] x5 : ffff0004c0da2090 x4 : 0000000000000000 x3 : 0000000000000001
[   60.284521] x2 : 0000000040000000 x1 : 0000000000000000 x0 : 0000000040000010
[   60.291658] Call trace:
[   60.294100]  swiotlb_tbl_map_single+0x2c0/0x590
[   60.298629]  swiotlb_map+0x88/0x1f0
[   60.302115]  dma_map_page_attrs+0x188/0x230
[   60.306299]  pci_endpoint_test_ioctl+0x5e4/0xd90 [pci_endpoint_test]
[   60.312660]  __arm64_sys_ioctl+0xa8/0xf0
[   60.316583]  invoke_syscall+0x44/0x108
[   60.320334]  el0_svc_common.constprop.0+0xcc/0xf0
[   60.325038]  do_el0_svc+0x2c/0xb8
[   60.328351]  el0_svc+0x2c/0x88
[   60.331406]  el0t_64_sync_handler+0xb8/0xc0
[   60.335587]  el0t_64_sync+0x18c/0x190
[   60.339251] Code: 52800013 d2e00414 35fff45c d503201f (d4210000)
[   60.345344] ---[ end trace 0000000000000000 ]---

To fix it, this patch adds a checking the payload length if it is zero.

Fixes: 343dc693f7b7 ("misc: pci_endpoint_test: Prevent some integer overflows")
Cc: stable <stable@kernel.org>
Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
Link: https://lore.kernel.org/r/20220907020100.122588-2-mie@igel.co.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/pci_endpoint_test.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/misc/pci_endpoint_test.c
+++ b/drivers/misc/pci_endpoint_test.c
@@ -334,6 +334,11 @@ static bool pci_endpoint_test_msi_irq(st
 static int pci_endpoint_test_validate_xfer_params(struct device *dev,
 		struct pci_endpoint_test_xfer_param *param, size_t alignment)
 {
+	if (!param->size) {
+		dev_dbg(dev, "Data size is zero\n");
+		return -EINVAL;
+	}
+
 	if (param->size > SIZE_MAX - alignment) {
 		dev_dbg(dev, "Maximum transfer data size exceeded\n");
 		return -EINVAL;


