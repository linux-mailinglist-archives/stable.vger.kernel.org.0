Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD955586AD
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236749AbiFWSQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236641AbiFWSPn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:15:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4104F9D1;
        Thu, 23 Jun 2022 10:22:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5AB761E0D;
        Thu, 23 Jun 2022 17:22:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D06CC3411B;
        Thu, 23 Jun 2022 17:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004924;
        bh=XLle1ULxtnkMGtZ5J8OId3dZzK+gS1ktRIOSKJPKipE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s3nwBD3abQ9Mh2nmSu/E020yZaRH4bLphBgJDkawXDjT9VeDHYiZyfO3DQFnZ7VxK
         5A4+1uQGDTBHiSdBvUOA9bdzvOBkXNO1qvIksgjS5fvuKMxu5iSNAQQRmfbQn2pAUG
         ZWfhgwzIXPPLz87eOOzW4MKO+6QDg/dk4lM8h6tw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, chengkaitao <pilgrimtao@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 194/234] virtio-mmio: fix missing put_device() when vm_cmdline_parent registration failed
Date:   Thu, 23 Jun 2022 18:44:21 +0200
Message-Id: <20220623164348.538321472@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
References: <20220623164343.042598055@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: chengkaitao <pilgrimtao@gmail.com>

[ Upstream commit a58a7f97ba11391d2d0d408e0b24f38d86ae748e ]

The reference must be released when device_register(&vm_cmdline_parent)
failed. Add the corresponding 'put_device()' in the error handling path.

Signed-off-by: chengkaitao <pilgrimtao@gmail.com>
Message-Id: <20220602005542.16489-1-chengkaitao@didiglobal.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_mmio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 4cd9ea5c75be..c69c755bf553 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -663,6 +663,7 @@ static int vm_cmdline_set(const char *device,
 	if (!vm_cmdline_parent_registered) {
 		err = device_register(&vm_cmdline_parent);
 		if (err) {
+			put_device(&vm_cmdline_parent);
 			pr_err("Failed to register parent device!\n");
 			return err;
 		}
-- 
2.35.1



