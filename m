Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCB7059D98B
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242600AbiHWJwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352123AbiHWJvS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:51:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7986F6AA15;
        Tue, 23 Aug 2022 01:45:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCB96B8105C;
        Tue, 23 Aug 2022 08:44:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007E9C433C1;
        Tue, 23 Aug 2022 08:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244286;
        bh=sto1LCv4DQGYhbhbX/aWkxvRFogNADA9fty7b01kRcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=grEEyB++9dHYQtXHBMksoC9DH1UAOm7EbQtRhqAa0ob85dxSiDmRvchXbSXtVNNyo
         wW5jTMXyFx0dJyHZmjUxcYaMIyPJizwLaVh2V4Wql8e8rLme/dyKkEP+nxItoqnohB
         U+Hc7/2CrQZx2DZkFfbS/1M6TSAhJZjQ/nim/ZvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 114/229] mm/mmap.c: fix missing call to vm_unacct_memory in mmap_region
Date:   Tue, 23 Aug 2022 10:24:35 +0200
Message-Id: <20220823080057.754261520@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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
index 64d1d133af79..a29d5b1fa1a1 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1778,7 +1778,6 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 
 	/* Undo any partial mapping done by a device driver. */
 	unmap_region(mm, vma, prev, vma->vm_start, vma->vm_end);
-	charged = 0;
 	if (vm_flags & VM_SHARED)
 		mapping_unmap_writable(file->f_mapping);
 allow_write_and_free_vma:
-- 
2.35.1



