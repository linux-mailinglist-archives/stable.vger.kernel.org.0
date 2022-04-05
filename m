Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D72A4F3F8E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357674AbiDEMM7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358069AbiDEK15 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:27:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0E93DDE8;
        Tue,  5 Apr 2022 03:14:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BA5F617A4;
        Tue,  5 Apr 2022 10:14:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBCDC385A0;
        Tue,  5 Apr 2022 10:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153662;
        bh=HdkMtmrEqzTR3W+FQELvxyIHklp9P8FC/+1eaSOJKRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bk1f9s0aBxfuJN1r1PZHALgdTtmGnv8QnXTt23H/fOBG/dANTym75sBv7FgsgXubj
         gBoZgDnHp69XUCuYG1H5W0bY58y5rL8aJagn3DkUwRwRPpOIZAB6RI6L+OJZfsrPaf
         nWci4WH6AAlvsTim+XPW/Pa0sS+DM9p+gXJ4EPH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Zhang <ztong0001@gmail.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 302/599] dax: make sure inodes are flushed before destroy cache
Date:   Tue,  5 Apr 2022 09:29:56 +0200
Message-Id: <20220405070307.820959484@linuxfoundation.org>
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
index cadbd0a1a1ef..260a247c60d2 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -723,6 +723,7 @@ static int dax_fs_init(void)
 static void dax_fs_exit(void)
 {
 	kern_unmount(dax_mnt);
+	rcu_barrier();
 	kmem_cache_destroy(dax_cache);
 }
 
-- 
2.34.1



