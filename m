Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9863666493A
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239096AbjAJSTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:19:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239268AbjAJSSh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:18:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1BA8D3A5
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:16:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A21B461852
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C61C433F0;
        Tue, 10 Jan 2023 18:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374608;
        bh=hheDl6dpJScVhrmPq2AAcUlVM0ti6E2A5kbDfg9FTRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KrHyrUCgD1kpawugZpeV8V6fXgkr3L8cLU+ifw8cDvChVMbBRwlDFZJDouJNQ+Oey
         BDaDHaHUMD1f7d1q9lRrRxL0MH933l3mG1kUTpd1qeVyXr6KQrlmlR3GvaFKaxzrSr
         GgOduTAw9b6SkaKQAprK+2+ZvNdLLxnod3TGi3Sg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/159] vhost/vsock: Fix error handling in vhost_vsock_init()
Date:   Tue, 10 Jan 2023 19:03:11 +0100
Message-Id: <20230110180019.683589816@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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

[ Upstream commit 7a4efe182ca61fb3e5307e69b261c57cbf434cd4 ]

A problem about modprobe vhost_vsock failed is triggered with the
following log given:

modprobe: ERROR: could not insert 'vhost_vsock': Device or resource busy

The reason is that vhost_vsock_init() returns misc_register() directly
without checking its return value, if misc_register() failed, it returns
without calling vsock_core_unregister() on vhost_transport, resulting the
vhost_vsock can never be installed later.
A simple call graph is shown as below:

 vhost_vsock_init()
   vsock_core_register() # register vhost_transport
   misc_register()
     device_create_with_groups()
       device_create_groups_vargs()
         dev = kzalloc(...) # OOM happened
   # return without unregister vhost_transport

Fix by calling vsock_core_unregister() when misc_register() returns error.

Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Message-Id: <20221108101705.45981-1-yuancan@huawei.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vsock.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 5703775af129..10a7d23731fe 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -959,7 +959,14 @@ static int __init vhost_vsock_init(void)
 				  VSOCK_TRANSPORT_F_H2G);
 	if (ret < 0)
 		return ret;
-	return misc_register(&vhost_vsock_misc);
+
+	ret = misc_register(&vhost_vsock_misc);
+	if (ret) {
+		vsock_core_unregister(&vhost_transport.transport);
+		return ret;
+	}
+
+	return 0;
 };
 
 static void __exit vhost_vsock_exit(void)
-- 
2.35.1



