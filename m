Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38EAA64338A
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234368AbiLEThW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:37:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234413AbiLETgv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:36:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF882A735
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:33:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0844FB811CF
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDD8C433C1;
        Mon,  5 Dec 2022 19:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268832;
        bh=il9aaumLBYP1oJ76vUIm++U3YPX9dQjSXBs/a+25uos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UldexKAxHVYHn4w4p9PHf7xRh2xpCidm3PJqhCHP+f5YsiEDg2SbQOf9cvhzs/JYB
         oj7ZDBMkWizfaczxocdFjh6LHCsvgslqIoXEXT6QcZ0Po0buay2f1FLESLveAkSqDL
         q2EkvO4N4ekAa9pYubUD0o8uvM1A4iSigyebnaWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 028/120] ixgbevf: Fix resource leak in ixgbevf_init_module()
Date:   Mon,  5 Dec 2022 20:09:28 +0100
Message-Id: <20221205190807.410915891@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
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

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit 8cfa238a48f34038464b99d0b4825238c2687181 ]

ixgbevf_init_module() won't destroy the workqueue created by
create_singlethread_workqueue() when pci_register_driver() failed. Add
destroy_workqueue() in fail path to prevent the resource leak.

Similar to the handling of u132_hcd_init in commit f276e002793c
("usb: u132-hcd: fix resource leak")

Fixes: 40a13e2493c9 ("ixgbevf: Use a private workqueue to avoid certain possible hangs")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Reviewed-by: Saeed Mahameed <saeed@kernel.org>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 7ef2e1241a76..0e7ff15af968 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -4859,6 +4859,8 @@ static struct pci_driver ixgbevf_driver = {
  **/
 static int __init ixgbevf_init_module(void)
 {
+	int err;
+
 	pr_info("%s\n", ixgbevf_driver_string);
 	pr_info("%s\n", ixgbevf_copyright);
 	ixgbevf_wq = create_singlethread_workqueue(ixgbevf_driver_name);
@@ -4867,7 +4869,13 @@ static int __init ixgbevf_init_module(void)
 		return -ENOMEM;
 	}
 
-	return pci_register_driver(&ixgbevf_driver);
+	err = pci_register_driver(&ixgbevf_driver);
+	if (err) {
+		destroy_workqueue(ixgbevf_wq);
+		return err;
+	}
+
+	return 0;
 }
 
 module_init(ixgbevf_init_module);
-- 
2.35.1



