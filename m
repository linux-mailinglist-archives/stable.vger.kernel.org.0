Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0504FD5D0
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352959AbiDLHdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355026AbiDLH1F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:27:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD4147AD4;
        Tue, 12 Apr 2022 00:07:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B0BBB81A8F;
        Tue, 12 Apr 2022 07:07:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71DC1C385AB;
        Tue, 12 Apr 2022 07:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747219;
        bh=8NBQ5K9uRRSfDU5tznudwhA9E3UIsrOYnRLVdJ8Ujh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rVKSaCkgjGT7H4P61RXmdl7oR7nkgpakhEeB2yJ86P45rRPv9uqM2YK1rdAoU+66B
         GggWAipDgUeEq5AnPfN2494otGLNNfTu+Pw+COrrQQ8YHAnNLu4taykJXYVZnWGFeH
         Ebm8wV+MQIsg51JdaSavK9eu5QtwnQGYa/jxhAWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        Justin Forbes <jforbes@redhat.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Rafael Aquini <aquini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.16 284/285] mm/sparsemem: fix mem_section will never be NULL gcc 12 warning
Date:   Tue, 12 Apr 2022 08:32:21 +0200
Message-Id: <20220412062951.847943070@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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

From: Waiman Long <longman@redhat.com>

commit a431dbbc540532b7465eae4fc8b56a85a9fc7d17 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mmzone.h |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1389,13 +1389,16 @@ static inline unsigned long *section_to_
 
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
 


