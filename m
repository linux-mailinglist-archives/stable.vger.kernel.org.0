Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479A166780F
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239535AbjALOwA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:52:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240088AbjALOvU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:51:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD171CB26
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:38:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A71A62042
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:38:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA47C433D2;
        Thu, 12 Jan 2023 14:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534307;
        bh=hN3guaYIXEqybB94lhygdS+xS9Bx+S+lt3n0V8w4uZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u/XNuPqLPlcUI4i5GypDSBqI1Ucim1mUix94vzY89U1MtCPhHDdm5gT5jfk8oLkur
         wfvswgmQmoyvJbkzzc3q9cLmS6Xcj2+7M878mVOHjEE26P3fYInn45u7ysQcvj0xGY
         0OMbNa9ghzhGwcyr6+6bpb1RhsrXvvu84AXoBF40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 734/783] vhost/vsock: Fix error handling in vhost_vsock_init()
Date:   Thu, 12 Jan 2023 14:57:30 +0100
Message-Id: <20230112135558.364958577@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index b0153617fe0e..7bce5f982e58 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -854,7 +854,14 @@ static int __init vhost_vsock_init(void)
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



