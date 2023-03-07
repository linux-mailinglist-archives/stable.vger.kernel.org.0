Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23CEC6AEFC4
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbjCGS0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:26:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232866AbjCGSY4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:24:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8708D9E040
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:20:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 193716152E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026AEC433EF;
        Tue,  7 Mar 2023 18:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213215;
        bh=aUnAOfxo3JOrzF6d20vc06FXxfgky9O1PgK+eGY4HNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c3U8yNnCDPFvV4ugMJZC5VzU6EEu+6AivYtDV6weuCy9pHciK9DpU5bAhevB+1T+z
         rT7+sSBXzF9X7oo+yuA8j+s+mMhwxYrwtkSVGHq+IqCACWn3xmN00o1Brleq8Ymx/q
         kQd0T05yirstUNVQYWTDescYE76hRm4cR+Dvtq2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 435/885] applicom: Fix PCI device refcount leak in applicom_init()
Date:   Tue,  7 Mar 2023 17:56:09 +0100
Message-Id: <20230307170021.314339086@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit ce4273d89c52167d6fe20572136c58117eae0657 ]

As comment of pci_get_class() says, it returns a pci_device with its
refcount increased and decreased the refcount for the input parameter
@from if it is not NULL.

If we break the loop in applicom_init() with 'dev' not NULL, we need to
call pci_dev_put() to decrease the refcount. Add the missing
pci_dev_put() to avoid refcount leak.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Link: https://lore.kernel.org/r/20221122114035.24194-1-wangxiongfeng2@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/applicom.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
index 36203d3fa6ea6..69314532f38cd 100644
--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -197,8 +197,10 @@ static int __init applicom_init(void)
 		if (!pci_match_id(applicom_pci_tbl, dev))
 			continue;
 		
-		if (pci_enable_device(dev))
+		if (pci_enable_device(dev)) {
+			pci_dev_put(dev);
 			return -EIO;
+		}
 
 		RamIO = ioremap(pci_resource_start(dev, 0), LEN_RAM_IO);
 
@@ -207,6 +209,7 @@ static int __init applicom_init(void)
 				"space at 0x%llx\n",
 				(unsigned long long)pci_resource_start(dev, 0));
 			pci_disable_device(dev);
+			pci_dev_put(dev);
 			return -EIO;
 		}
 
-- 
2.39.2



