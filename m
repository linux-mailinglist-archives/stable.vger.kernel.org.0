Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576BD627FE3
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237677AbiKNNC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:02:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237691AbiKNNC0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:02:26 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A032926481
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:02:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E82DFCE0FF1
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:02:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C503BC433C1;
        Mon, 14 Nov 2022 13:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430941;
        bh=cdYSvaC+FvdBkl/NTZJpsvjQWJxWPZ4DtwfyFum+Wjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NgNytQR12c0mr+4QzPPuymBPcKEEKCzjVPtJ6Xa7Qxt1MVHmoHGlLTyygC3t6Xvp6
         ji4Ri9VhE05gI8lPopju8Xx8CwBnzjZ9zoTxDhZ6vwtQIvYRGZdhd+Z9yxlxaPLd9B
         7nb1+ZWCezT4rumKju0ReXLAw0kN0kd3Y8xs+Vgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Abaci Robot <abaci@linux.alibaba.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 012/190] drm/amdkfd: Fix NULL pointer dereference in svm_migrate_to_ram()
Date:   Mon, 14 Nov 2022 13:43:56 +0100
Message-Id: <20221114124459.335265543@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

From: Yang Li <yang.lee@linux.alibaba.com>

[ Upstream commit 5b994354af3cab770bf13386469c5725713679af ]

./drivers/gpu/drm/amd/amdkfd/kfd_migrate.c:985:58-62: ERROR: p is NULL but dereferenced.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2549
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index 6555d775a532..5b5a79ccb716 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -971,12 +971,10 @@ static vm_fault_t svm_migrate_to_ram(struct vm_fault *vmf)
 out_unlock_svms:
 	mutex_unlock(&p->svms.lock);
 out_unref_process:
+	pr_debug("CPU fault svms 0x%p address 0x%lx done\n", &p->svms, addr);
 	kfd_unref_process(p);
 out_mmput:
 	mmput(mm);
-
-	pr_debug("CPU fault svms 0x%p address 0x%lx done\n", &p->svms, addr);
-
 	return r ? VM_FAULT_SIGBUS : 0;
 }
 
-- 
2.35.1



