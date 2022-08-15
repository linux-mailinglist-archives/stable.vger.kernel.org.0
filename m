Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1655939F5
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245716AbiHOT3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245125AbiHOTYo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:24:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3999E48C88;
        Mon, 15 Aug 2022 11:41:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BACFB6113D;
        Mon, 15 Aug 2022 18:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD201C433C1;
        Mon, 15 Aug 2022 18:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588865;
        bh=PeOXGJFs0w0UcUVNaIMXcvP9j7s1pLeJ3CYXZuat4tw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DgM0bpC/3DGICzWQMbTVqm/J1FeALBEglL8GqQiGUPFJ2oHGa+VoPA4QYTIynE2fJ
         ev1apX+6IdYMtEu8JN+GW1/MUJERgZ29qPEl+uN2V/+lZE93wBjlQnc/cCxoaTeoIx
         P43vYu0Ms+r6anxQ9yy/MhUmaZ25gNCr9aPu4JVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 540/779] mm/mmap.c: fix missing call to vm_unacct_memory in mmap_region
Date:   Mon, 15 Aug 2022 20:03:04 +0200
Message-Id: <20220815180400.396206986@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit 7f82f922319ede486540e8746769865b9508d2c2 ]

Since the beginning, charged is set to 0 to avoid calling vm_unacct_memory
twice because vm_unacct_memory will be called by above unmap_region.  But
since commit 4f74d2c8e827 ("vm: remove 'nr_accounted' calculations from
the unmap_vmas() interfaces"), unmap_region doesn't call vm_unacct_memory
anymore.  So charged shouldn't be set to 0 now otherwise the calling to
paired vm_unacct_memory will be missed and leads to imbalanced account.

Link: https://lkml.kernel.org/r/20220618082027.43391-1-linmiaohe@huawei.com
Fixes: 4f74d2c8e827 ("vm: remove 'nr_accounted' calculations from the unmap_vmas() interfaces")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mmap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 6bb553ed5c55..031fca1a7c65 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1878,7 +1878,6 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 
 	/* Undo any partial mapping done by a device driver. */
 	unmap_region(mm, vma, prev, vma->vm_start, vma->vm_end);
-	charged = 0;
 	if (vm_flags & VM_SHARED)
 		mapping_unmap_writable(file->f_mapping);
 free_vma:
-- 
2.35.1



