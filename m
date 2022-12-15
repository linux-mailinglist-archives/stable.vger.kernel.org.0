Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C81A264E03E
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 19:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbiLOSLE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 13:11:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbiLOSLA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 13:11:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B3A379E8
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 10:10:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF9A5B81BA1
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 18:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07CC3C433EF;
        Thu, 15 Dec 2022 18:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671127855;
        bh=EQVw4W6XHpoYTwqKxUANMXO6GShKlmTRNZQPeDq9RPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rKLsEgejOsP9/2Hte1fMbOsKdiwdi8xdhqcXUq/L9uuP7wjkHAPKvhFNaZl7FD1Nz
         wumMBMlLQsdChNNciR2ZQCrkanzYExQDdNtQ0UibJmgkzQCks2DLGARJ2aldmwqsj3
         IrJPjIaSOf+SmLMZKKJ/Kwc2Imcu6PTuHQ0cRzrE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jialiang Wang <wangjialiang0806@163.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 5/9] nfp: fix use-after-free in area_cache_get()
Date:   Thu, 15 Dec 2022 19:10:32 +0100
Message-Id: <20221215172905.661904596@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221215172905.468656378@linuxfoundation.org>
References: <20221215172905.468656378@linuxfoundation.org>
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

From: Jialiang Wang <wangjialiang0806@163.com>

commit 02e1a114fdb71e59ee6770294166c30d437bf86a upstream.

area_cache_get() is used to distribute cache->area and set cache->id,
 and if cache->id is not 0 and cache->area->kref refcount is 0, it will
 release the cache->area by nfp_cpp_area_release(). area_cache_get()
 set cache->id before cpp->op->area_init() and nfp_cpp_area_acquire().

But if area_init() or nfp_cpp_area_acquire() fails, the cache->id is
 is already set but the refcount is not increased as expected. At this
 time, calling the nfp_cpp_area_release() will cause use-after-free.

To avoid the use-after-free, set cache->id after area_init() and
 nfp_cpp_area_acquire() complete successfully.

Note: This vulnerability is triggerable by providing emulated device
 equipped with specified configuration.

 BUG: KASAN: use-after-free in nfp6000_area_init (drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c:760)
  Write of size 4 at addr ffff888005b7f4a0 by task swapper/0/1

 Call Trace:
  <TASK>
 nfp6000_area_init (drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c:760)
 area_cache_get.constprop.8 (drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:884)

 Allocated by task 1:
 nfp_cpp_area_alloc_with_name (drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:303)
 nfp_cpp_area_cache_add (drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:802)
 nfp6000_init (drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c:1230)
 nfp_cpp_from_operations (drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:1215)
 nfp_pci_probe (drivers/net/ethernet/netronome/nfp/nfp_main.c:744)

 Freed by task 1:
 kfree (mm/slub.c:4562)
 area_cache_get.constprop.8 (drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:873)
 nfp_cpp_read (drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:924 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:973)
 nfp_cpp_readl (drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cpplib.c:48)

Signed-off-by: Jialiang Wang <wangjialiang0806@163.com>
Reviewed-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Acked-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20220810073057.4032-1-wangjialiang0806@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
@@ -874,7 +874,6 @@ area_cache_get(struct nfp_cpp *cpp, u32
 	}
 
 	/* Adjust the start address to be cache size aligned */
-	cache->id = id;
 	cache->addr = addr & ~(u64)(cache->size - 1);
 
 	/* Re-init to the new ID and address */
@@ -894,6 +893,8 @@ area_cache_get(struct nfp_cpp *cpp, u32
 		return NULL;
 	}
 
+	cache->id = id;
+
 exit:
 	/* Adjust offset */
 	*offset = addr - cache->addr;


