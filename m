Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68870615AA0
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbiKBDha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiKBDh2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:37:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EEFA26553
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:37:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA823B8205C
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:37:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C586EC433D6;
        Wed,  2 Nov 2022 03:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667360245;
        bh=WKehPvp+2JXzC3gDIInsPuEOurPt5DW/w0K95TwPzqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rNfxmyNXJYvwYxFmP5iMC1JdulQ/GKxYUrtHe+9NR2xpreeLjzXQe69lt9IU0P2gw
         1UCybL38ldeonaLZOHVU+HmrBPrdRb/2dsz7eMvrDqEYqDv9pOQjlDvVQXUG4d/ai7
         X3O2ISbTgjE7WoPI5C4Tknbk8E0jDorq5Es3h6oM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 76/78] net: ehea: fix possible memory leak in ehea_register_port()
Date:   Wed,  2 Nov 2022 03:35:01 +0100
Message-Id: <20221102022055.161673882@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022052.895556444@linuxfoundation.org>
References: <20221102022052.895556444@linuxfoundation.org>
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
index 5a1fe49030b1..25f579a924d6 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -2916,6 +2916,7 @@ static struct device *ehea_register_port(struct ehea_port *port,
 	ret = of_device_register(&port->ofdev);
 	if (ret) {
 		pr_err("failed to register device. ret=%d\n", ret);
+		put_device(&port->ofdev.dev);
 		goto out;
 	}
 
-- 
2.35.1



