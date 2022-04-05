Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36EFA4F2FF3
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242503AbiDEJhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235654AbiDEJCY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:02:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD6C27FEA;
        Tue,  5 Apr 2022 01:54:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93BCE61476;
        Tue,  5 Apr 2022 08:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60B5C385A0;
        Tue,  5 Apr 2022 08:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148860;
        bh=S2KuJRjgEpRjx8Areu8U+GZvYUTs9/nOiG/mM/dEr5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=enAZeVgWP8ZWnJRSKK6hS2E+bQhTlZp2+bHmno6chf/9DWmOm7erYSUpHg222P0iX
         Sjbb5Kx842H50DbbfR4k9PE/ldq01ogY/lDSJOfe5/wPU1GYdWI9WioORH9Rk7ie/I
         JLn7eKl6sD5ZwXjrOXf6UEs6GT/h3qURYYI07k5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Zhang <ztong0001@gmail.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0506/1017] dax: make sure inodes are flushed before destroy cache
Date:   Tue,  5 Apr 2022 09:23:39 +0200
Message-Id: <20220405070409.319682532@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit a7e8de822e0b1979f08767c751f6c8a9c1d4ad86 ]

A bug can be triggered by following command

$ modprobe nd_pmem && modprobe -r nd_pmem

[   10.060014] BUG dax_cache (Not tainted): Objects remaining in dax_cache on __kmem_cache_shutdown()
[   10.060938] Slab 0x0000000085b729ac objects=9 used=1 fp=0x000000004f5ae469 flags=0x200000000010200(slab|head|node)
[   10.062433] Call Trace:
[   10.062673]  dump_stack_lvl+0x34/0x44
[   10.062865]  slab_err+0x90/0xd0
[   10.063619]  __kmem_cache_shutdown+0x13b/0x2f0
[   10.063848]  kmem_cache_destroy+0x4a/0x110
[   10.064058]  __x64_sys_delete_module+0x265/0x300

This is caused by dax_fs_exit() not flushing inodes before destroy cache.
To fix this issue, call rcu_barrier() before destroy cache.

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220212071111.148575-1-ztong0001@gmail.com
Fixes: 7b6be8444e0f ("dax: refactor dax-fs into a generic provider of 'struct dax_device' instances")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dax/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index e20d0cef10a1..0e55dde937d2 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -612,6 +612,7 @@ static int dax_fs_init(void)
 static void dax_fs_exit(void)
 {
 	kern_unmount(dax_mnt);
+	rcu_barrier();
 	kmem_cache_destroy(dax_cache);
 }
 
-- 
2.34.1



