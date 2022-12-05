Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF5A64325F
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232307AbiLET0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:26:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233847AbiLETZg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:25:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C6D2610C
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:21:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E7CB612FE
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:21:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3239DC433D6;
        Mon,  5 Dec 2022 19:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268087;
        bh=6I5CMeNdEHAuanP4/Mpo5jutVAWJdHSdEK64wyihe4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AsEoQRlAwrG8Pzilkh4QDMolgdKW+nC9zve7WxWqkkktTd6CQ7qTU88QbEiylnJIC
         f2RYzQuYFDDAs2Kfn/6dAAyAGYy0bsJnTYOxUU1R/I9qBQWSPa0uRjaiYU3KgYBYk4
         CziSFoV3dh6no8i3SBbcXvAHAZlAecb4iGVELfeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 081/105] hwmon: (coretemp) fix pci device refcount leak in nv1a_ram_new()
Date:   Mon,  5 Dec 2022 20:09:53 +0100
Message-Id: <20221205190805.892898146@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 7dec14537c5906b8bf40fd6fd6d9c3850f8df11d ]

As comment of pci_get_domain_bus_and_slot() says, it returns
a pci device with refcount increment, when finish using it,
the caller must decrement the reference count by calling
pci_dev_put(). So call it after using to avoid refcount leak.

Fixes: 14513ee696a0 ("hwmon: (coretemp) Use PCI host bridge ID to identify CPU if necessary")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221118093303.214163-1-yangyingliang@huawei.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/coretemp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 02711014aee7..1b2f750577da 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -255,10 +255,13 @@ static int adjust_tjmax(struct cpuinfo_x86 *c, u32 id, struct device *dev)
 	 */
 	if (host_bridge && host_bridge->vendor == PCI_VENDOR_ID_INTEL) {
 		for (i = 0; i < ARRAY_SIZE(tjmax_pci_table); i++) {
-			if (host_bridge->device == tjmax_pci_table[i].device)
+			if (host_bridge->device == tjmax_pci_table[i].device) {
+				pci_dev_put(host_bridge);
 				return tjmax_pci_table[i].tjmax;
+			}
 		}
 	}
+	pci_dev_put(host_bridge);
 
 	for (i = 0; i < ARRAY_SIZE(tjmax_table); i++) {
 		if (strstr(c->x86_model_id, tjmax_table[i].id))
-- 
2.35.1



