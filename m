Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16A160FDE4
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236636AbiJ0RAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236797AbiJ0RAI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:00:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB35052E6A
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:00:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65280B82719
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:00:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7127C433D6;
        Thu, 27 Oct 2022 17:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890004;
        bh=ZNGRtPqGxZDxm7jpO1FdcyLGCgD2hNvvTeHZnE1jVvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vz82+Ms2ClfdziZXDcUaPSlPzyTsj7jUgm2dJFyrMqZ7wZCFNDODff3V1H1hA8Mks
         kuO3gRurs4cEyY5IM2fENxodGxaWZQkRPkNRSu9a8td6Ev8lR8qvrfkDQhXvj9pw1i
         I0LhdYfBLi2LRUhLqqDU2t0rLjiBVztrGVELH0bk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 80/94] wwan_hwsim: fix possible memory leak in wwan_hwsim_dev_new()
Date:   Thu, 27 Oct 2022 18:55:22 +0200
Message-Id: <20221027165100.418209434@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 258ad2fe5ede773625adfda88b173f4123e59f45 ]

Inject fault while probing module, if device_register() fails,
but the refcount of kobject is not decreased to 0, the name
allocated in dev_set_name() is leaked. Fix this by calling
put_device(), so that name can be freed in callback function
kobject_cleanup().

unreferenced object 0xffff88810152ad20 (size 8):
  comm "modprobe", pid 252, jiffies 4294849206 (age 22.713s)
  hex dump (first 8 bytes):
    68 77 73 69 6d 30 00 ff                          hwsim0..
  backtrace:
    [<000000009c3504ed>] __kmalloc_node_track_caller+0x44/0x1b0
    [<00000000c0228a5e>] kvasprintf+0xb5/0x140
    [<00000000cff8c21f>] kvasprintf_const+0x55/0x180
    [<0000000055a1e073>] kobject_set_name_vargs+0x56/0x150
    [<000000000a80b139>] dev_set_name+0xab/0xe0

Fixes: f36a111a74e7 ("wwan_hwsim: WWAN device simulator")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
Acked-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Link: https://lore.kernel.org/r/20221018131607.1901641-1-yangyingliang@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/wwan_hwsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/wwan_hwsim.c b/drivers/net/wwan/wwan_hwsim.c
index fad642f9ffd8..857a55b625fe 100644
--- a/drivers/net/wwan/wwan_hwsim.c
+++ b/drivers/net/wwan/wwan_hwsim.c
@@ -311,7 +311,7 @@ static struct wwan_hwsim_dev *wwan_hwsim_dev_new(void)
 	return ERR_PTR(err);
 
 err_free_dev:
-	kfree(dev);
+	put_device(&dev->dev);
 
 	return ERR_PTR(err);
 }
-- 
2.35.1



