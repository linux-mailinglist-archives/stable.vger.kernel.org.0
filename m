Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6F1676F82
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbjAVPWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:22:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbjAVPWZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:22:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA7122A0F
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:22:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA94E60C44
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:22:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDAC8C433EF;
        Sun, 22 Jan 2023 15:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400928;
        bh=M+4GISfvltC10De0Z9HQpos6L7S/uXmgMLDdAvSbSE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VO7wU+MQ+2WQ/dMOT+eLOLB32i8s4gGFRHNk1i+L32F71y6FRzZYdoKJsoI/ZlNri
         /plR8tFKYLDiH5HraS6HBHRO1QiP4WFKlrkuk1jX+W/5xwAyCrLSNOH6uihN6+DSWl
         fWnQjt/FSW/zoZaMgWp5ax/d1U8XGgYOuaZIu80A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zach OKeefe <zokeefe@google.com>,
        Hugh Dickins <hughd@google.com>,
        David Hildenbrand <david@redhat.com>,
        Yang Shi <shy828301@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 045/193] mm/shmem: restore SHMEM_HUGE_DENY precedence over MADV_COLLAPSE
Date:   Sun, 22 Jan 2023 16:02:54 +0100
Message-Id: <20230122150248.456581237@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zach O'Keefe <zokeefe@google.com>

commit 3de0c269adc6c2fac0bb1fb11965f0de699dc32b upstream.

SHMEM_HUGE_DENY is for emergency use by the admin, to disable allocation
of shmem huge pages if, for example, a dangerous bug is found in their
usage: see "deny" in Documentation/mm/transhuge.rst.  An app using
madvise(,,MADV_COLLAPSE) should not be allowed to override it: restore its
precedence over shmem_huge_force.

Restore SHMEM_HUGE_DENY precedence over MADV_COLLAPSE.

Link: https://lkml.kernel.org/r/20221224082035.3197140-2-zokeefe@google.com
Fixes: 7c6c6cc4d3a2 ("mm/shmem: add flag to enforce shmem THP in hugepage_vma_check()")
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shmem.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -472,12 +472,10 @@ bool shmem_is_huge(struct vm_area_struct
 	if (vma && ((vma->vm_flags & VM_NOHUGEPAGE) ||
 	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags)))
 		return false;
-	if (shmem_huge_force)
-		return true;
-	if (shmem_huge == SHMEM_HUGE_FORCE)
-		return true;
 	if (shmem_huge == SHMEM_HUGE_DENY)
 		return false;
+	if (shmem_huge_force || shmem_huge == SHMEM_HUGE_FORCE)
+		return true;
 
 	switch (SHMEM_SB(inode->i_sb)->huge) {
 	case SHMEM_HUGE_ALWAYS:


