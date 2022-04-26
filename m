Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68B4450F49F
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345072AbiDZIgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345221AbiDZIeP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:34:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393397092F;
        Tue, 26 Apr 2022 01:26:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F329617D2;
        Tue, 26 Apr 2022 08:26:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9991C385A0;
        Tue, 26 Apr 2022 08:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961595;
        bh=miV3zHvoaoWk2HMkqTcode8uSRytbQFecx1o6+yDlaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ei7aiLsU6xRgLsijBfvMwNlOd6mkQmGx57v0pxITta4/eYYr24OSu6XsUY2KwUm4I
         ZefqBPhaJ6z6lw7lcF+mTVKC/86QvZggUHVPnkI5H3gJQ6bj1bzgJnITtvP2i1qpSB
         P3clgr5eYS1NYMsHcyDEmbYlViRC+gbzyglzir+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiongwei Song <sxwjean@gmail.com>,
        Arthur Marsh <arthur.marsh@internode.on.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Khem Raj <raj.khem@gmail.com>
Subject: [PATCH 4.19 02/53] mm: page_alloc: fix building error on -Werror=array-compare
Date:   Tue, 26 Apr 2022 10:20:42 +0200
Message-Id: <20220426081735.725489179@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081735.651926456@linuxfoundation.org>
References: <20220426081735.651926456@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiongwei Song <sxwjean@gmail.com>

commit ca831f29f8f25c97182e726429b38c0802200c8f upstream.

Arthur Marsh reported we would hit the error below when building kernel
with gcc-12:

  CC      mm/page_alloc.o
  mm/page_alloc.c: In function `mem_init_print_info':
  mm/page_alloc.c:8173:27: error: comparison between two arrays [-Werror=array-compare]
   8173 |                 if (start <= pos && pos < end && size > adj) \
        |

In C++20, the comparision between arrays should be warned.

Link: https://lkml.kernel.org/r/20211125130928.32465-1-sxwjean@me.com
Signed-off-by: Xiongwei Song <sxwjean@gmail.com>
Reported-by: Arthur Marsh <arthur.marsh@internode.on.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Khem Raj <raj.khem@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7117,7 +7117,7 @@ void __init mem_init_print_info(const ch
 	 */
 #define adj_init_size(start, end, size, pos, adj) \
 	do { \
-		if (start <= pos && pos < end && size > adj) \
+		if (&start[0] <= &pos[0] && &pos[0] < &end[0] && size > adj) \
 			size -= adj; \
 	} while (0)
 


