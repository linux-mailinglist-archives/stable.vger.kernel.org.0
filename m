Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03F7B6580F8
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233155AbiL1QXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:23:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235001AbiL1QWs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:22:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52B11A818
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:20:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4413661563
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F83C433D2;
        Wed, 28 Dec 2022 16:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244416;
        bh=yBmzoLX72TzDgaAANwHW4cImJhUIL+CQVc+MpFpu1MA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=auOWqBYEgLWLFCZZPlz1qrMIy1wVU8uUq/12CDf8sZfSUk0C4PiwzV9S/2iHb0WS7
         o3jpfwXlbTXdAKuugFXrmDhAl0GCGETyVbXnEFHZJL4DLg4AQU0df73X9X6WP7z00y
         tNEU9MxxOft4esFT4z/wzyt0Cgb5q1bb9X+meMrI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0706/1073] usb: core: hcd: Fix return value check in usb_hcd_setup_local_mem()
Date:   Wed, 28 Dec 2022 15:38:14 +0100
Message-Id: <20221228144347.208771015@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit 3c347cdafa3db43337870006e5c2d7b78a8dae20 ]

If dmam_alloc_attrs() fails, it returns NULL pointer and never
return ERR_PTR(), so repleace IS_ERR() with IS_ERR_OR_NULL()
and if it's NULL, returns -ENOMEM.

Fixes: 9ba26f5cecd8 ("ARM: sa1100/assabet: move dmabounce hack to ohci driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221125064120.2842452-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/hcd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 94b305bbd621..4bd9d799f1b9 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -3140,8 +3140,12 @@ int usb_hcd_setup_local_mem(struct usb_hcd *hcd, phys_addr_t phys_addr,
 					     GFP_KERNEL,
 					     DMA_ATTR_WRITE_COMBINE);
 
-	if (IS_ERR(local_mem))
+	if (IS_ERR_OR_NULL(local_mem)) {
+		if (!local_mem)
+			return -ENOMEM;
+
 		return PTR_ERR(local_mem);
+	}
 
 	/*
 	 * Here we pass a dma_addr_t but the arg type is a phys_addr_t.
-- 
2.35.1



