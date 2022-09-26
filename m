Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5558B5EA085
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235958AbiIZKj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236136AbiIZKhm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:37:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5438C52DE3;
        Mon, 26 Sep 2022 03:22:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89786B80682;
        Mon, 26 Sep 2022 10:21:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB665C433D7;
        Mon, 26 Sep 2022 10:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187718;
        bh=yDD+tEnuOOYBChulh8vKMrzIijmV/sFlusTqTAgudFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZDa07xeNKf7Y3VORy2eSM2fkO//uWGggIHzADJmTvu5hJdTPhfAJALMB9VO/pM5Wm
         boWJYU75sFbPzfwlrqHjlQRlBiBX98Tsi6KsjQJQCEQs/mJ+77tYyFyvLdih489QnO
         vn6Fh4OkDWOutfNbdmeiiXEnOxhzHciuLrxb64AA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 006/120] parisc: ccio-dma: Add missing iounmap in error path in ccio_probe()
Date:   Mon, 26 Sep 2022 12:10:39 +0200
Message-Id: <20220926100750.789844366@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
User-Agent: quilt/0.67
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
index 6209d58e9492..fdd302d0a1c9 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -1544,6 +1544,7 @@ static int __init ccio_probe(struct parisc_device *dev)
 	}
 	ccio_ioc_init(ioc);
 	if (ccio_init_resources(ioc)) {
+		iounmap(ioc->ioc_regs);
 		kfree(ioc);
 		return -ENOMEM;
 	}
-- 
2.35.1



