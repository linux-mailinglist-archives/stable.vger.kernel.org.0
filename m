Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E873259A503
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353893AbiHSQqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354001AbiHSQpj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:45:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A2E12A1DF;
        Fri, 19 Aug 2022 09:11:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2A29B8280D;
        Fri, 19 Aug 2022 16:11:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02546C433C1;
        Fri, 19 Aug 2022 16:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925488;
        bh=Tb0e6xMNt//1x5UfU5ZNfc2D7Ql4KchN4AOJtashIJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=noGYNRGIeMold4fZBCEj9gqWhIe74YZGUppzRMc+q4KeDeOtFQQ3TIkdA5D6yhbGg
         3HKS+t79dtI67Xr2UabAx+iv5u4KPhOnw44f7Nad+bl22HZ2GFdwH23wRtXH/MDUaX
         ons/LOygaL0XsLn9Tcaqc2PpZbEKzGNgpV36p35c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean V Kelley <sean.v.kelley@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 476/545] PCI/ERR: Simplify by using pci_upstream_bridge()
Date:   Fri, 19 Aug 2022 17:44:06 +0200
Message-Id: <20220819153850.717142295@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Sean V Kelley <sean.v.kelley@intel.com>

[ Upstream commit 5d69dcc9f839bd2d5cac7a098712f52149e1673f ]

Use pci_upstream_bridge() in place of dev->bus->self.  No functional change
intended.

Link: https://lore.kernel.org/r/20201121001036.8560-6-sean.v.kelley@intel.com
Tested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com> # non-native/no RCEC
Signed-off-by: Sean V Kelley <sean.v.kelley@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/err.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pcie/err.c b/drivers/pci/pcie/err.c
index db149c6ce4fb..05f61da5ed9d 100644
--- a/drivers/pci/pcie/err.c
+++ b/drivers/pci/pcie/err.c
@@ -159,7 +159,7 @@ pci_ers_result_t pcie_do_recovery(struct pci_dev *dev,
 	 */
 	if (!(pci_pcie_type(dev) == PCI_EXP_TYPE_ROOT_PORT ||
 	      pci_pcie_type(dev) == PCI_EXP_TYPE_DOWNSTREAM))
-		dev = dev->bus->self;
+		dev = pci_upstream_bridge(dev);
 	bus = dev->subordinate;
 
 	pci_dbg(dev, "broadcast error_detected message\n");
-- 
2.35.1



