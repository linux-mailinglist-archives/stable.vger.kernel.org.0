Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 624C74F4146
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382854AbiDEMRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242638AbiDEKcm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:32:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC8F167F6;
        Tue,  5 Apr 2022 03:18:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5789461676;
        Tue,  5 Apr 2022 10:18:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF1CC385A0;
        Tue,  5 Apr 2022 10:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153934;
        bh=r88hWIB6vNyoCMJJysi09WXaUEqZwlMCiIF3eh30XLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s+MOrU2jXB4nhkf8jfKzzfx/Vz8dzFNGEXigg4XHuqHXX9cTAZSRMsLT53+4jHPyR
         RHLdV2y1Jbu+flutO0lefhnfGAqkN8gZ4qQS/U1u2bEm71PFbrikHp7nv5WaVgcEAF
         rgV0LcWT2Y0MxSitlEzWhCL5o0x0wJ7OHJtjCtzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        Joerg Roedel <joro@8bytes.org>, Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        iommu@lists.linux-foundation.org,
        Robin Murphy <robin.murphy@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 399/599] dma-debug: fix return value of __setup handlers
Date:   Tue,  5 Apr 2022 09:31:33 +0200
Message-Id: <20220405070310.704342906@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 80e4390981618e290616dbd06ea190d4576f219d ]

When valid kernel command line parameters
  dma_debug=off dma_debug_entries=100
are used, they are reported as Unknown parameters and added to init's
environment strings, polluting it.

  Unknown kernel command line parameters "BOOT_IMAGE=/boot/bzImage-517rc5
    dma_debug=off dma_debug_entries=100", will be passed to user space.

and

 Run /sbin/init as init process
   with arguments:
     /sbin/init
   with environment:
     HOME=/
     TERM=linux
     BOOT_IMAGE=/boot/bzImage-517rc5
     dma_debug=off
     dma_debug_entries=100

Return 1 from these __setup handlers to indicate that the command line
option has been handled.

Fixes: 59d3daafa1726 ("dma-debug: add kernel command line parameters")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: iommu@lists.linux-foundation.org
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index 10d07ace46c1..f8ae54679865 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -928,7 +928,7 @@ static __init int dma_debug_cmdline(char *str)
 		global_disable = true;
 	}
 
-	return 0;
+	return 1;
 }
 
 static __init int dma_debug_entries_cmdline(char *str)
@@ -937,7 +937,7 @@ static __init int dma_debug_entries_cmdline(char *str)
 		return -EINVAL;
 	if (!get_option(&str, &nr_prealloc_entries))
 		nr_prealloc_entries = PREALLOC_DMA_DEBUG_ENTRIES;
-	return 0;
+	return 1;
 }
 
 __setup("dma_debug=", dma_debug_cmdline);
-- 
2.34.1



