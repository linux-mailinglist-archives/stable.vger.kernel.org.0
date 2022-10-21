Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35BA16070A9
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 09:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbiJUHDw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 03:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiJUHDv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 03:03:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD1417F988
        for <stable@vger.kernel.org>; Fri, 21 Oct 2022 00:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666335828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/wE6/eKapRDgR5N8Zx4iFcV3VrO6c0XERfSzK650hD0=;
        b=hw4KT/AU9BwbVTnviV4y/eICDytRZuv9q5ju3hWe2TTtXIyKWO0PjYCeZL49R1y6Cy5eDg
        9tG6W+u6udzof/5WiYvo7+WSTQ9AFbl+uwZFW2MIyJm2BcX5llTa6Jpu4MdQ9alyk92LuN
        hfw1G5Xdv4u1a1g2mxYkGMbAJibqlfg=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-441-7JVP7o1JPD6meagBx7_gLA-1; Fri, 21 Oct 2022 03:03:46 -0400
X-MC-Unique: 7JVP7o1JPD6meagBx7_gLA-1
Received: by mail-ej1-f72.google.com with SMTP id nc4-20020a1709071c0400b0078a5ceb571bso950475ejc.4
        for <stable@vger.kernel.org>; Fri, 21 Oct 2022 00:03:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/wE6/eKapRDgR5N8Zx4iFcV3VrO6c0XERfSzK650hD0=;
        b=gt9IVrfJk6ZLoRSy3rVJZQuh8+U5esdX2j7gxH9zWrFwoQFouRc47XivZ8wWLI+yg2
         5fYX/YgEpsfF8+I8Fqoc3ebTlokREvm2b1tnzvebfZ0c15nITNOps6NZQNfOYmEbIfDD
         +xxFZaRY+qlw3z8RHfEXPJSDFYnqqgiARlSlawsZnDYWCHbhjdR86wu6y0RDDNMr55uJ
         Drecil0fnl+0gR4Z882wDO8FcMh5DCwwdSsUipzcUKF++BLDRJGFM0xrXpmPPgZuQDqE
         fYTu+FqfFba4zIlxm/0CwbO+juJA8Q8hYbCRUHgleUpTHef0NnojJwfyc0uXZr1o1WDu
         vw6Q==
X-Gm-Message-State: ACrzQf2tDsSDc8sC7dJKLRYwryUkTvvYPX0nJCcsuiZUnVkdP/TTNVQN
        4f9Vtoh5Hvz+w3LiNolt2ZoHYU5aa3a2EIFqjTlc/cerjQClUAYgISzUjhkFRWWMUY4ZtaDKXeO
        sy5K1vxO2PYBCFvlf
X-Received: by 2002:a17:906:5dac:b0:78d:fc53:7db1 with SMTP id n12-20020a1709065dac00b0078dfc537db1mr13796333ejv.99.1666335825226;
        Fri, 21 Oct 2022 00:03:45 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4MKP05PxPGKwyJBLQVyoCA4aWGwS2d8wmI7nh6tteEluyVOz8yXbtehjzAd2zbKZfdHEUReQ==
X-Received: by 2002:a17:906:5dac:b0:78d:fc53:7db1 with SMTP id n12-20020a1709065dac00b0078dfc537db1mr13796318ejv.99.1666335825039;
        Fri, 21 Oct 2022 00:03:45 -0700 (PDT)
Received: from miu.piliscsaba.redhat.com (188-143-109-10.pool.digikabel.hu. [188.143.109.10])
        by smtp.gmail.com with ESMTPSA id 3-20020a170906318300b0078c213ad441sm11245241ejy.101.2022.10.21.00.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 00:03:44 -0700 (PDT)
From:   Miklos Szeredi <mszeredi@redhat.com>
To:     linux-fsdevel@vger.kernel.org
Cc:     Matthew Wilcox <willy@infradead.org>,
        Frank Sorenson <fsorenso@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v3] fuse: fix readdir cache race
Date:   Fri, 21 Oct 2022 09:03:43 +0200
Message-Id: <20221021070343.3983455-1-mszeredi@redhat.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There's a race in fuse's readdir cache that can result in an uninitilized
page being read.  The page lock is supposed to prevent this from happening
but in the following case it doesn't:

Two fuse_add_dirent_to_cache() start out and get the same parameters
(size=0,offset=0).  One of them wins the race to create and lock the page,
after which it fills in data, sets rdc.size and unlocks the page.

In the meantime the page gets evicted from the cache before the other
instance gets to run.  That one also creates the page, but finds the
size to be mismatched, bails out and leaves the uninitialized page in the
cache.

Fix by marking a filled page uptodate and ignoring non-uptodate pages.

Reported-by: Frank Sorenson <fsorenso@redhat.com>
Fixes: 5d7bc7e8680c ("fuse: allow using readdir cache")
Cc: <stable@vger.kernel.org> # v4.20
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
v3: This should address issues with previous versions

 - no need to delete page from the cache, just leave it non-uptodate

 - need to clear in the offset == 0 case even if already in cache
 
 fs/fuse/readdir.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/readdir.c b/fs/fuse/readdir.c
index b4e565711045..e8deaacf1832 100644
--- a/fs/fuse/readdir.c
+++ b/fs/fuse/readdir.c
@@ -77,8 +77,10 @@ static void fuse_add_dirent_to_cache(struct file *file,
 		goto unlock;
 
 	addr = kmap_local_page(page);
-	if (!offset)
+	if (!offset) {
 		clear_page(addr);
+		SetPageUptodate(page);
+	}
 	memcpy(addr + offset, dirent, reclen);
 	kunmap_local(addr);
 	fi->rdc.size = (index << PAGE_SHIFT) + offset + reclen;
@@ -516,6 +518,12 @@ static int fuse_readdir_cached(struct file *file, struct dir_context *ctx)
 
 	page = find_get_page_flags(file->f_mapping, index,
 				   FGP_ACCESSED | FGP_LOCK);
+	/* Page gone missing, then re-added to cache, but not initialized? */
+	if (page && !PageUptodate(page)) {
+		unlock_page(page);
+		put_page(page);
+		page = NULL;
+	}
 	spin_lock(&fi->rdc.lock);
 	if (!page) {
 		/*
-- 
2.37.3

