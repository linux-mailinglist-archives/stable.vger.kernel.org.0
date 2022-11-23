Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27015635825
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235950AbiKWJvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:51:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238220AbiKWJux (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:50:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E50256D76
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:48:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8ED74B81E54
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:48:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CCA3C433C1;
        Wed, 23 Nov 2022 09:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196880;
        bh=HRs+c8AjQoN57wzP4AQg59TeYAmKAvKhVx9GpFAKqDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T7Q6Vts1qYneKSDqfIAqWvVmninRAp4FsJE5vAJPKD4ZTt0BDddjKaTtLhpCi18qv
         S0INdthoGeOBmnJfCXp0S0p/oggH8ueGtU+AG/IhiUjHc+6TdkVFVCa/KnycgoVg6I
         Ub8Xebk90c/kgcZP6QsIJ3iZse5JwQ47Eyw7hFs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 150/314] net: hinic: Fix error handling in hinic_module_init()
Date:   Wed, 23 Nov 2022 09:49:55 +0100
Message-Id: <20221123084632.359514827@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

[ Upstream commit 8eab9be56cc6b702a445d2b6d0256aa0992316b3 ]

A problem about hinic create debugfs failed is triggered with the
following log given:

 [  931.419023] debugfs: Directory 'hinic' with parent '/' already present!

The reason is that hinic_module_init() returns pci_register_driver()
directly without checking its return value, if pci_register_driver()
failed, it returns without destroy the newly created debugfs, resulting
the debugfs of hinic can never be created later.

 hinic_module_init()
   hinic_dbg_register_debugfs() # create debugfs directory
   pci_register_driver()
     driver_register()
       bus_add_driver()
         priv = kzalloc(...) # OOM happened
   # return without destroy debugfs directory

Fix by removing debugfs when pci_register_driver() returns error.

Fixes: 253ac3a97921 ("hinic: add support to query sq info")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20221110021642.80378-1-yuancan@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/huawei/hinic/hinic_main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index c23ee2ddbce3..1a6534c35ef3 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -1478,8 +1478,15 @@ static struct pci_driver hinic_driver = {
 
 static int __init hinic_module_init(void)
 {
+	int ret;
+
 	hinic_dbg_register_debugfs(HINIC_DRV_NAME);
-	return pci_register_driver(&hinic_driver);
+
+	ret = pci_register_driver(&hinic_driver);
+	if (ret)
+		hinic_dbg_unregister_debugfs();
+
+	return ret;
 }
 
 static void __exit hinic_module_exit(void)
-- 
2.35.1



