Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE6DC6C182E
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbjCTPVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232693AbjCTPVD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:21:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0124F29173
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:15:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D4A5615B4
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:14:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA3AC433EF;
        Mon, 20 Mar 2023 15:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325270;
        bh=63PtVO4aVd/7ZfOGEWRKpebX0W6pFFeZKrXfWkCLt9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h9Lx49BERAVc88G7pbJR1Zifus1p3ns9EOiVb5hupZj0OB7z1Vr/3E9qGnv6fIo/j
         Py38MUJOy6OpAtFVQ5jxLR+qBRT8PIvVy5v9LRddIJsrJYTXJ6OCKAr7Hemyio+d2s
         08XxaN5xCl0fzcRPtyGAjSLufVWY6jRUmZXEa24I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Michal=20Such=C3=A1nek?= <msuchanek@suse.de>,
        Benjamin Gray <bgray@linux.ibm.com>,
        Russell Currey <ruscur@russell.cc>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 062/198] powerpc/mm: Fix false detection of read faults
Date:   Mon, 20 Mar 2023 15:53:20 +0100
Message-Id: <20230320145510.150651932@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell Currey <ruscur@russell.cc>

[ Upstream commit f2c7e3562b4c4f1699acc1538ebf3e75f5cced35 ]

To support detection of read faults with Radix execute-only memory, the
vma_is_accessible() check in access_error() (which checks for PROT_NONE)
was replaced with a check to see if VM_READ was missing, and if so,
returns true to assert the fault was caused by a bad read.

This is incorrect, as it ignores that both VM_WRITE and VM_EXEC imply
read on powerpc, as defined in protection_map[].  This causes mappings
containing VM_WRITE or VM_EXEC without VM_READ to misreport the cause of
page faults, since the MMU is still allowing reads.

Correct this by restoring the original vma_is_accessible() check for
PROT_NONE mappings, and adding a separate check for Radix PROT_EXEC-only
mappings.

Fixes: 395cac7752b9 ("powerpc/mm: Support execute-only memory on the Radix MMU")
Reported-by: Michal Suchánek <msuchanek@suse.de>
Link: https://lore.kernel.org/r/20230308152702.GR19419@kitsune.suse.cz
Tested-by: Benjamin Gray <bgray@linux.ibm.com>
Signed-off-by: Russell Currey <ruscur@russell.cc>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230310050834.63105-1-ruscur@russell.cc
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/fault.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 2bef19cc1b98c..af46aa88422bf 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -271,11 +271,16 @@ static bool access_error(bool is_write, bool is_exec, struct vm_area_struct *vma
 	}
 
 	/*
-	 * Check for a read fault.  This could be caused by a read on an
-	 * inaccessible page (i.e. PROT_NONE), or a Radix MMU execute-only page.
+	 * VM_READ, VM_WRITE and VM_EXEC all imply read permissions, as
+	 * defined in protection_map[].  Read faults can only be caused by
+	 * a PROT_NONE mapping, or with a PROT_EXEC-only mapping on Radix.
 	 */
-	if (unlikely(!(vma->vm_flags & VM_READ)))
+	if (unlikely(!vma_is_accessible(vma)))
 		return true;
+
+	if (unlikely(radix_enabled() && ((vma->vm_flags & VM_ACCESS_FLAGS) == VM_EXEC)))
+		return true;
+
 	/*
 	 * We should ideally do the vma pkey access check here. But in the
 	 * fault path, handle_mm_fault() also does the same check. To avoid
-- 
2.39.2



