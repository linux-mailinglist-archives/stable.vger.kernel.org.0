Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B897501301
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345471AbiDNNxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345000AbiDNNo7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:44:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D576A60CC9;
        Thu, 14 Apr 2022 06:41:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 416BFB8296A;
        Thu, 14 Apr 2022 13:41:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915D3C385A5;
        Thu, 14 Apr 2022 13:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943667;
        bh=0yqvMpcWaAR3dMtVCzR5hf1l6lIs367xNIC9Ory2ITU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mZlTzen39KVHMcCSVZdlw1nXEUyDzmpJ4IopP0PbbRh5d7g/x0rVuzbrlfSpDCuXg
         62IpU8ab8XfoyrdBcY6eTWWBhOj9N1PmMLxO96CYYHEr9y111lgnDxMt+yIsV8Sjk3
         AM3Yw5+sVhFNNQwJf60qtgtaSdsoL3WQou3gHmN4=
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
Subject: [PATCH 5.4 238/475] dma-debug: fix return value of __setup handlers
Date:   Thu, 14 Apr 2022 15:10:23 +0200
Message-Id: <20220414110901.779191925@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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
index b28665f4d8c7..4dc3bbfd3e3f 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -980,7 +980,7 @@ static __init int dma_debug_cmdline(char *str)
 		global_disable = true;
 	}
 
-	return 0;
+	return 1;
 }
 
 static __init int dma_debug_entries_cmdline(char *str)
@@ -989,7 +989,7 @@ static __init int dma_debug_entries_cmdline(char *str)
 		return -EINVAL;
 	if (!get_option(&str, &nr_prealloc_entries))
 		nr_prealloc_entries = PREALLOC_DMA_DEBUG_ENTRIES;
-	return 0;
+	return 1;
 }
 
 __setup("dma_debug=", dma_debug_cmdline);
-- 
2.34.1



