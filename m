Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 824965E9EC3
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbiIZKN4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235004AbiIZKNm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:13:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DECBE69;
        Mon, 26 Sep 2022 03:13:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E02A960AF2;
        Mon, 26 Sep 2022 10:13:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B52C433D7;
        Mon, 26 Sep 2022 10:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187220;
        bh=S/uIQBi13lJQnohuZqNlFk+LWnZqVLfvZQ856GUXAwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BaTbNCUYXFcZGuQK92BaFvV6v2/1xjHDDPYJk9F4ugADDs25pWfSgVIQHEXm3uK4X
         8ZOjGFnm45IljSi4JIGUsSob6Wo3+PRuYDnyjNEVQXsracx6wxVVq5F0iHkdg2Cm5N
         Gc96Yfl2RywmKDmT7cwvgXP2TbNWzjRMFD4c7Z9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 01/30] parisc: ccio-dma: Add missing iounmap in error path in ccio_probe()
Date:   Mon, 26 Sep 2022 12:11:32 +0200
Message-Id: <20220926100736.214354283@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100736.153157100@linuxfoundation.org>
References: <20220926100736.153157100@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 38238be4e881a5d0abbe4872b4cd6ed790be06c8 ]

Add missing iounmap() before return from ccio_probe(), if ccio_init_resources()
fails.

Fixes: d46c742f827f ("parisc: ccio-dma: Handle kmalloc failure in ccio_init_resources()")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/parisc/ccio-dma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index 633762f8d775..84a93ddcd57a 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -1569,6 +1569,7 @@ static int __init ccio_probe(struct parisc_device *dev)
 	ioc->ioc_regs = ioremap_nocache(dev->hpa.start, 4096);
 	ccio_ioc_init(ioc);
 	if (ccio_init_resources(ioc)) {
+		iounmap(ioc->ioc_regs);
 		kfree(ioc);
 		return -ENOMEM;
 	}
-- 
2.35.1



