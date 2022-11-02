Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDCCF615952
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbiKBDJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbiKBDIq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:08:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D4813F07
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:08:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28235B82062
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17227C433C1;
        Wed,  2 Nov 2022 03:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358508;
        bh=2sUBNV0BIE1PbFY9K1Eu5yZwFElzNLpXHkq5ZZcwsqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AMkW70+OQ1FHUNg2eKPp/1NuaEm2iAX6uoG94YseMlgoIxIreFhMVL9BfQn3PXJRp
         cUdfjLnqoyMtWH3gHAZrrzDJMC8L/KmEkn+Q8GMg0Z5W01OTurzPgY3qEZCw4Clkgo
         nCXoPGCqKXFJwAkUWdxIMTxPtfYBJObI3+YMq7iI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 111/132] net: ehea: fix possible memory leak in ehea_register_port()
Date:   Wed,  2 Nov 2022 03:33:37 +0100
Message-Id: <20221102022102.584235101@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 0e7ce23a917a9cc83ca3c779fbba836bca3bcf1e ]

If of_device_register() returns error, the of node and the
name allocated in dev_set_name() is leaked, call put_device()
to give up the reference that was set in device_initialize(),
so that of node is put in logical_port_release() and the name
is freed in kobject_cleanup().

Fixes: 1acf2318dd13 ("ehea: dynamic add / remove port")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221025130011.1071357-1-yangyingliang@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ehea/ehea_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index d5df131b183c..6c534b92aeed 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -2898,6 +2898,7 @@ static struct device *ehea_register_port(struct ehea_port *port,
 	ret = of_device_register(&port->ofdev);
 	if (ret) {
 		pr_err("failed to register device. ret=%d\n", ret);
+		put_device(&port->ofdev.dev);
 		goto out;
 	}
 
-- 
2.35.1



