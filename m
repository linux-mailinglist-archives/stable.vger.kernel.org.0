Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD814FC0DC
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 17:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243251AbiDKPgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 11:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348021AbiDKPgg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 11:36:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8D114085
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 08:34:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF607615CA
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 15:34:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99FE0C385A4;
        Mon, 11 Apr 2022 15:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649691259;
        bh=dn/qBlMxmKMU+iriGNLa+Z59Guau+hpPaFTEgzsKmHQ=;
        h=Subject:To:Cc:From:Date:From;
        b=pEtxVXa3BVWtlekTV1a34uPkUt12V96FSg8ehuLPDzTvGFwd011fBomlw5dZQaXjd
         HgaCdglBI6kXEk3uvangvELL4mPwsm+6qWBvNUOfYPXJG6DHYsPgnMBHayg6dgNet0
         eo7pJ+819ksysGYr9P+Pe0DPOj+L0yYJrNxn0Fj4=
Subject: FAILED: patch "[PATCH] mm/sparsemem: fix 'mem_section' will never be NULL gcc 12" failed to apply to 4.9-stable tree
To:     longman@redhat.com, akpm@linux-foundation.org, aquini@redhat.com,
        jforbes@redhat.com, kirill.shutemov@linux.intel.com,
        mingo@kernel.org, torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Apr 2022 17:34:16 +0200
Message-ID: <1649691256214220@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a431dbbc540532b7465eae4fc8b56a85a9fc7d17 Mon Sep 17 00:00:00 2001
From: Waiman Long <longman@redhat.com>
Date: Fri, 8 Apr 2022 13:09:01 -0700
Subject: [PATCH] mm/sparsemem: fix 'mem_section' will never be NULL gcc 12
 warning

The gcc 12 compiler reports a "'mem_section' will never be NULL" warning
on the following code:

    static inline struct mem_section *__nr_to_section(unsigned long nr)
    {
    #ifdef CONFIG_SPARSEMEM_EXTREME
        if (!mem_section)
                return NULL;
    #endif
        if (!mem_section[SECTION_NR_TO_ROOT(nr)])
                return NULL;
       :

It happens with CONFIG_SPARSEMEM_EXTREME off.  The mem_section definition
is

    #ifdef CONFIG_SPARSEMEM_EXTREME
    extern struct mem_section **mem_section;
    #else
    extern struct mem_section mem_section[NR_SECTION_ROOTS][SECTIONS_PER_ROOT];
    #endif

In the !CONFIG_SPARSEMEM_EXTREME case, mem_section is a static
2-dimensional array and so the check "!mem_section[SECTION_NR_TO_ROOT(nr)]"
doesn't make sense.

Fix this warning by moving the "!mem_section[SECTION_NR_TO_ROOT(nr)]"
check up inside the CONFIG_SPARSEMEM_EXTREME block and adding an
explicit NR_SECTION_ROOTS check to make sure that there is no
out-of-bound array access.

Link: https://lkml.kernel.org/r/20220331180246.2746210-1-longman@redhat.com
Fixes: 3e347261a80b ("sparsemem extreme implementation")
Signed-off-by: Waiman Long <longman@redhat.com>
Reported-by: Justin Forbes <jforbes@redhat.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 962b14d403e8..46ffab808f03 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1397,13 +1397,16 @@ static inline unsigned long *section_to_usemap(struct mem_section *ms)
 
 static inline struct mem_section *__nr_to_section(unsigned long nr)
 {
+	unsigned long root = SECTION_NR_TO_ROOT(nr);
+
+	if (unlikely(root >= NR_SECTION_ROOTS))
+		return NULL;
+
 #ifdef CONFIG_SPARSEMEM_EXTREME
-	if (!mem_section)
+	if (!mem_section || !mem_section[root])
 		return NULL;
 #endif
-	if (!mem_section[SECTION_NR_TO_ROOT(nr)])
-		return NULL;
-	return &mem_section[SECTION_NR_TO_ROOT(nr)][nr & SECTION_ROOT_MASK];
+	return &mem_section[root][nr & SECTION_ROOT_MASK];
 }
 extern size_t mem_section_usage_size(void);
 

