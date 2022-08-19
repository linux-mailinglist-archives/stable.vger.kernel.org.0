Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D18E59A001
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352395AbiHSQ0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352825AbiHSQZh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:25:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC9060522;
        Fri, 19 Aug 2022 09:03:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C320B82804;
        Fri, 19 Aug 2022 16:03:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8230DC433D6;
        Fri, 19 Aug 2022 16:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925004;
        bh=gkqRS+TbmjeplEzOWCMiTsyo8jJqDRvczpG0XMFK4mA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CdfLAJVQr7w0prB/QJLu1tAGTyrzQFlb9nyY/xU1IEtN0z0Afa6zIBdnS2HRc93tF
         FWHJiHseIflMHcpiPkiCTotjNiCsnVUz6CP9Oa9JG+ULezgV5oZnTyCeoq/7sv24IA
         Qh5AD4DAufBv5X7DocoFYH9DUGWxOsLKUZ8a3sgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 353/545] mm/mmap.c: fix missing call to vm_unacct_memory in mmap_region
Date:   Fri, 19 Aug 2022 17:42:03 +0200
Message-Id: <20220819153845.182316973@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
index 102f73ed4b1b..a50042918cc7 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1902,7 +1902,6 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 
 	/* Undo any partial mapping done by a device driver. */
 	unmap_region(mm, vma, prev, vma->vm_start, vma->vm_end);
-	charged = 0;
 	if (vm_flags & VM_SHARED)
 		mapping_unmap_writable(file->f_mapping);
 allow_write_and_free_vma:
-- 
2.35.1



