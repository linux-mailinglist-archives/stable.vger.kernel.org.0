Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F7961599B
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiKBDPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbiKBDOx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:14:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 054B824940
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:14:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96F34617D8
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33CF7C433D6;
        Wed,  2 Nov 2022 03:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358848;
        bh=4+BkRPqbg062PpCI/DARFjhlA2+K0NZKq9ooovnvxnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w1wX7PlAK4qpL4aOccYEsBzvl2SkjB83WM/mAwhoBRRPBqVdl39W0ufGKP3nNrf+Q
         Lowr/dFkyAXa4Mo37JRWaJsOauz+7dD6P8biG/vN2Y1v+XpwhYcG3RCpjmimIiQZP8
         GjUl3Ww6ySRXMpq1FGceqHBztCfks1vUKs8YvShM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuanzheng Song <songyuanzheng@huawei.com>,
        Peter Xu <peterx@redhat.com>
Subject: [PATCH 5.10 34/91] mm/memory: add non-anonymous page check in the copy_present_page()
Date:   Wed,  2 Nov 2022 03:33:17 +0100
Message-Id: <20221102022056.007631805@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuanzheng Song <songyuanzheng@huawei.com>

The vma->anon_vma of the child process may be NULL because
the entire vma does not contain anonymous pages. In this
case, a BUG will occur when the copy_present_page() passes
a copy of a non-anonymous page of that vma to the
page_add_new_anon_rmap() to set up new anonymous rmap.

------------[ cut here ]------------
kernel BUG at mm/rmap.c:1044!
Internal error: Oops - BUG: 0 [#1] SMP
Modules linked in:
CPU: 2 PID: 3617 Comm: test Not tainted 5.10.149 #1
Hardware name: linux,dummy-virt (DT)
pstate: 80000005 (Nzcv daif -PAN -UAO -TCO BTYPE=--)
pc : __page_set_anon_rmap+0xbc/0xf8
lr : __page_set_anon_rmap+0xbc/0xf8
sp : ffff800014c1b870
x29: ffff800014c1b870 x28: 0000000000000001
x27: 0000000010100073 x26: ffff1d65c517baa8
x25: ffff1d65cab0f000 x24: ffff1d65c416d800
x23: ffff1d65cab5f248 x22: 0000000020000000
x21: 0000000000000001 x20: 0000000000000000
x19: fffffe75970023c0 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000
x15: 0000000000000000 x14: 0000000000000000
x13: 0000000000000000 x12: 0000000000000000
x11: 0000000000000000 x10: 0000000000000000
x9 : ffffc3096d5fb858 x8 : 0000000000000000
x7 : 0000000000000011 x6 : ffff5a5c9089c000
x5 : 0000000000020000 x4 : ffff5a5c9089c000
x3 : ffffc3096d200000 x2 : ffffc3096e8d0000
x1 : ffff1d65ca3da740 x0 : 0000000000000000
Call trace:
 __page_set_anon_rmap+0xbc/0xf8
 page_add_new_anon_rmap+0x1e0/0x390
 copy_pte_range+0xd00/0x1248
 copy_page_range+0x39c/0x620
 dup_mmap+0x2e0/0x5a8
 dup_mm+0x78/0x140
 copy_process+0x918/0x1a20
 kernel_clone+0xac/0x638
 __do_sys_clone+0x78/0xb0
 __arm64_sys_clone+0x30/0x40
 el0_svc_common.constprop.0+0xb0/0x308
 do_el0_svc+0x48/0xb8
 el0_svc+0x24/0x38
 el0_sync_handler+0x160/0x168
 el0_sync+0x180/0x1c0
Code: 97f8ff85 f9400294 17ffffeb 97f8ff82 (d4210000)
---[ end trace a972347688dc9bd4 ]---
Kernel panic - not syncing: Oops - BUG: Fatal exception
SMP: stopping secondary CPUs
Kernel Offset: 0x43095d200000 from 0xffff800010000000
PHYS_OFFSET: 0xffffe29a80000000
CPU features: 0x08200022,61806082
Memory Limit: none
---[ end Kernel panic - not syncing: Oops - BUG: Fatal exception ]---

This problem has been fixed by the commit <fb3d824d1a46>
("mm/rmap: split page_dup_rmap() into page_dup_file_rmap()
and page_try_dup_anon_rmap()"), but still exists in the
linux-5.10.y branch.

This patch is not applicable to this version because
of the large version differences. Therefore, fix it by
adding non-anonymous page check in the copy_present_page().

Cc: stable@vger.kernel.org
Fixes: 70e806e4e645 ("mm: Do early cow for pinned pages during fork() for ptes")
Signed-off-by: Yuanzheng Song <songyuanzheng@huawei.com>
Acked-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -823,6 +823,17 @@ copy_present_page(struct vm_area_struct
 	if (likely(!page_maybe_dma_pinned(page)))
 		return 1;
 
+	/*
+	 * The vma->anon_vma of the child process may be NULL
+	 * because the entire vma does not contain anonymous pages.
+	 * A BUG will occur when the copy_present_page() passes
+	 * a copy of a non-anonymous page of that vma to the
+	 * page_add_new_anon_rmap() to set up new anonymous rmap.
+	 * Return 1 if the page is not an anonymous page.
+	 */
+	if (!PageAnon(page))
+		return 1;
+
 	new_page = *prealloc;
 	if (!new_page)
 		return -EAGAIN;


