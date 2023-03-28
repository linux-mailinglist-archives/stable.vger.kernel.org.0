Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9D36CC464
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233800AbjC1PEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233743AbjC1PEj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:04:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A83E049
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:03:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61CFE61828
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F3EC433D2;
        Tue, 28 Mar 2023 15:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015765;
        bh=d8hX0/KZrx5W90ZU4YeAvPTp1aGZ5DfYQNaBWyUr2nQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FDmgN+WB45S6Bg+3PGDSPG1HhQm8RhaCogZT/vnYT3nv0nN4gnnweoFpKSGgslzfI
         r1NRDbJ+ay1Xpdw7r7RhzQbK/0v+DsG115+lYWTg7r2vaFDPFnWDejoNNA7eLph7fm
         bPNkRH3x+Dnb6rBO6CdVlJTPt7Jx31EgeWyBZ77k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 6.1 167/224] mm/slab: Fix undefined init_cache_node_node() for NUMA and !SMP
Date:   Tue, 28 Mar 2023 16:42:43 +0200
Message-Id: <20230328142624.344075954@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 66a1c22b709178e7b823d44465d0c2e5ed7492fb upstream.

sh/migor_defconfig:

    mm/slab.c: In function ‘slab_memory_callback’:
    mm/slab.c:1127:23: error: implicit declaration of function ‘init_cache_node_node’; did you mean ‘drain_cache_node_node’? [-Werror=implicit-function-declaration]
     1127 |                 ret = init_cache_node_node(nid);
	  |                       ^~~~~~~~~~~~~~~~~~~~
	  |                       drain_cache_node_node

The #ifdef condition protecting the definition of init_cache_node_node()
no longer matches the conditions protecting the (multiple) users.

Fix this by syncing the conditions.

Fixes: 76af6a054da40553 ("mm/migrate: add CPU hotplug to demotion #ifdef")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/r/b5bdea22-ed2f-3187-6efe-0c72330270a4@infradead.org
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slab.c
+++ b/mm/slab.c
@@ -840,7 +840,7 @@ static int init_cache_node(struct kmem_c
 	return 0;
 }
 
-#if (defined(CONFIG_NUMA) && defined(CONFIG_MEMORY_HOTPLUG)) || defined(CONFIG_SMP)
+#if defined(CONFIG_NUMA) || defined(CONFIG_SMP)
 /*
  * Allocates and initializes node for a node on each slab cache, used for
  * either memory or cpu hotplug.  If memory is being hot-added, the kmem_cache_node


