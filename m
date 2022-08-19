Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3764159A434
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354112AbiHSQr6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353987AbiHSQqx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:46:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91289113DCE;
        Fri, 19 Aug 2022 09:12:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8E5161898;
        Fri, 19 Aug 2022 16:11:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E4BC433D6;
        Fri, 19 Aug 2022 16:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925497;
        bh=mWUWAxCqeA3FTq772JsNj5qWEE9jE6doiOyela3xc4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EuaGYDLgJwt0ABtNTWTH+E0WgplkEi8vJLf4l5SODRk0nlKm17S+NT2GjN/v5wdfp
         zUbC5XA8fpNvkcxOEx5NrsgVRd6mbqtl+thefnmmVXF5X/Jqo8/EvJU+oW2S/BRfqA
         e31IvPusYOwKPYIxh4tktK85ormIuOYvY8k2yHpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean V Kelley <sean.v.kelley@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 479/545] PCI/ERR: Avoid negated conditional for clarity
Date:   Fri, 19 Aug 2022 17:44:09 +0200
Message-Id: <20220819153850.862483452@linuxfoundation.org>
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

[ Upstream commit 3d7d8fc78f4b504819882278fcfe10784eb985fa ]

Reverse the sense of the Root Port/Downstream Port conditional for clarity.
No functional change intended.

Link: https://lore.kernel.org/r/20201121001036.8560-9-sean.v.kelley@intel.com
Tested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com> # non-native/no RCEC
Signed-off-by: Sean V Kelley <sean.v.kelley@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/err.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/pcie/err.c b/drivers/pci/pcie/err.c
index 46a5b84f8842..931e75f2549d 100644
--- a/drivers/pci/pcie/err.c
+++ b/drivers/pci/pcie/err.c
@@ -159,11 +159,11 @@ pci_ers_result_t pcie_do_recovery(struct pci_dev *dev,
 	 * Error recovery runs on all subordinates of the bridge.  If the
 	 * bridge detected the error, it is cleared at the end.
 	 */
-	if (!(type == PCI_EXP_TYPE_ROOT_PORT ||
-	      type == PCI_EXP_TYPE_DOWNSTREAM))
-		bridge = pci_upstream_bridge(dev);
-	else
+	if (type == PCI_EXP_TYPE_ROOT_PORT ||
+	    type == PCI_EXP_TYPE_DOWNSTREAM)
 		bridge = dev;
+	else
+		bridge = pci_upstream_bridge(dev);
 
 	bus = bridge->subordinate;
 	pci_dbg(bridge, "broadcast error_detected message\n");
-- 
2.35.1



