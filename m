Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29C14658198
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234662AbiL1Q3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:29:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234736AbiL1Q3c (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:29:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66BFFF4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:25:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 595C561578
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6911BC433D2;
        Wed, 28 Dec 2022 16:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244745;
        bh=C4wX3t99ML0tdEdnpCMhKL7bGaB9HhxnPsqSwYYhIEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HbDlnVqWFcuvy7fb0RmaJNW6VpB61vnNkwE8F7tMC3yTZT4BmIDHPreQ3hUhaZSD2
         uKHFm1DIquYSJnWhpYibnxqi/Jn0YtY7eNOY9og61hkD18HVsY5oYu2OlMOZ/5YRaf
         EeJoLNWWJEUjUzBx4Qd3GKPqKhtpX1FBNT/cXnHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0729/1146] usb: core: hcd: Fix return value check in usb_hcd_setup_local_mem()
Date:   Wed, 28 Dec 2022 15:37:48 +0100
Message-Id: <20221228144349.947874725@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index faeaace0d197..8300baedafd2 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -3133,8 +3133,12 @@ int usb_hcd_setup_local_mem(struct usb_hcd *hcd, phys_addr_t phys_addr,
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



