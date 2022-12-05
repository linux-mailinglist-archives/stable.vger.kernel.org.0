Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD40643326
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbiLETeh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:34:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234371AbiLETeL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:34:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D41D2982A
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:29:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E55B7B81181
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56BB2C433D7;
        Mon,  5 Dec 2022 19:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268570;
        bh=rcsZaLEw+ekVDS3b2zLC/oGw8xeBpSXtMEzNk3vfv3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rr9qR0vG7ctabzyw30MXYC6YSPQ5CrO6Q9K9qFhKI+7rxy3C4dm28mf8b/eFoi1UG
         +gGi8HDazisQqRgNamS4QpfcWLGTMbBh1zI1sM3weVpSknvFp1W/y5304XtUnWycHg
         loQc4ef+WLDmUtNcMzT4GYJVkp2m03ut+oxfI1yg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zeal Robot <zealci@zte.com.cn>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        CGEL ZTE <cgel.zte@gmail.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 26/92] iavf: remove redundant ret variable
Date:   Mon,  5 Dec 2022 20:09:39 +0100
Message-Id: <20221205190804.329760855@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
References: <20221205190803.464934752@linuxfoundation.org>
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

From: Minghao Chi <chi.minghao@zte.com.cn>

[ Upstream commit c3fec56e12678c3ad68084048a73818a7968d6b8 ]

Return value directly instead of taking this in another redundant
variable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 227d8d2f7f22 ("iavf: Fix error handling in iavf_init_module()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index a9cea7ccdd86..af515c3ccd5c 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1318,7 +1318,6 @@ static void iavf_fill_rss_lut(struct iavf_adapter *adapter)
 static int iavf_init_rss(struct iavf_adapter *adapter)
 {
 	struct iavf_hw *hw = &adapter->hw;
-	int ret;
 
 	if (!RSS_PF(adapter)) {
 		/* Enable PCTYPES for RSS, TCP/UDP with IPv4/IPv6 */
@@ -1334,9 +1333,8 @@ static int iavf_init_rss(struct iavf_adapter *adapter)
 
 	iavf_fill_rss_lut(adapter);
 	netdev_rss_key_fill((void *)adapter->rss_key, adapter->rss_key_size);
-	ret = iavf_config_rss(adapter);
 
-	return ret;
+	return iavf_config_rss(adapter);
 }
 
 /**
@@ -4028,8 +4026,6 @@ static struct pci_driver iavf_driver = {
  **/
 static int __init iavf_init_module(void)
 {
-	int ret;
-
 	pr_info("iavf: %s\n", iavf_driver_string);
 
 	pr_info("%s\n", iavf_copyright);
@@ -4040,8 +4036,7 @@ static int __init iavf_init_module(void)
 		pr_err("%s: Failed to create workqueue\n", iavf_driver_name);
 		return -ENOMEM;
 	}
-	ret = pci_register_driver(&iavf_driver);
-	return ret;
+	return pci_register_driver(&iavf_driver);
 }
 
 module_init(iavf_init_module);
-- 
2.35.1



