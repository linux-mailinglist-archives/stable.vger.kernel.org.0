Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B124643328
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234060AbiLETej (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:34:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234109AbiLETeO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:34:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AAFC25C50
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:29:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97FE361309
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:29:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC231C433D6;
        Mon,  5 Dec 2022 19:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268576;
        bh=fCz6r6V0Ga7+zKhQP+JTmIe4DwewrAM/M3GmUEnctMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yt5WvqTo+qgf6XxwUrwbBGAQQ3Dy+XRZ3m/c5Wq6Tp+0MofHJ0WlfIIgsjz33lvV3
         epJumBvcJ6McWJelbHrwUvd8Lm1urnMYa0XDkTDG3lI86dHhWbOHAiRVgwA7zIqY7i
         CuRqkzuwlFH0dLZOXYSjk2QyUKYvAStnqBYplsoQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 27/92] iavf: Fix error handling in iavf_init_module()
Date:   Mon,  5 Dec 2022 20:09:40 +0100
Message-Id: <20221205190804.362934244@linuxfoundation.org>
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

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 227d8d2f7f2278b8468c5531b0cd0f2a905b4486 ]

The iavf_init_module() won't destroy workqueue when pci_register_driver()
failed. Call destroy_workqueue() when pci_register_driver() failed to
prevent the resource leak.

Similar to the handling of u132_hcd_init in commit f276e002793c
("usb: u132-hcd: fix resource leak")

Fixes: 2803b16c10ea ("i40e/i40evf: Use private workqueue")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index af515c3ccd5c..ae96b552a3bb 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4026,6 +4026,8 @@ static struct pci_driver iavf_driver = {
  **/
 static int __init iavf_init_module(void)
 {
+	int ret;
+
 	pr_info("iavf: %s\n", iavf_driver_string);
 
 	pr_info("%s\n", iavf_copyright);
@@ -4036,7 +4038,12 @@ static int __init iavf_init_module(void)
 		pr_err("%s: Failed to create workqueue\n", iavf_driver_name);
 		return -ENOMEM;
 	}
-	return pci_register_driver(&iavf_driver);
+
+	ret = pci_register_driver(&iavf_driver);
+	if (ret)
+		destroy_workqueue(iavf_wq);
+
+	return ret;
 }
 
 module_init(iavf_init_module);
-- 
2.35.1



