Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6140068D753
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 13:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbjBGM6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 07:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjBGM6o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 07:58:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565321B56D
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 04:58:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 166EDB8198C
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 12:58:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38934C433EF;
        Tue,  7 Feb 2023 12:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774720;
        bh=+VjPjuVHt0t3VyhIg/tCTPkpCVqT1d1yEygWeh3VuCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UbqsTmQ4IOO7ZxinNn52XD415FVOR3+XE6mPrh9OP+bjJLj/iHvzf+VHCavV6uqEd
         M9uucP5o3CyESu+H9l0QWFFc4ePQgHvZJL3tcinBfKgzQrRiqvgm1uLImznBXO5dQe
         IuZuKv4jnP0QDZsu8FWetlPcoAIDsz9Thn6uy+ck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peter Xu <peterx@redhat.com>,
        kernel test robot <lkp@intel.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/208] selftests/vm: remove __USE_GNU in hugetlb-madvise.c
Date:   Tue,  7 Feb 2023 13:54:26 +0100
Message-Id: <20230207125634.887107692@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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

From: Peter Xu <peterx@redhat.com>

[ Upstream commit 0ca2c535f5a07f01118a6a70bfab78576e02fcae ]

__USE_GNU should be an internal macro only used inside glibc.  Either
memfd_create() or fallocate() requires _GNU_SOURCE per man page, where
__USE_GNU will further be defined by glibc headers include/features.h:

  #ifdef _GNU_SOURCE
  # define __USE_GNU	1
  #endif

This fixes:

   >> hugetlb-madvise.c:20: warning: "__USE_GNU" redefined
      20 | #define __USE_GNU
         |
   In file included from /usr/include/x86_64-linux-gnu/bits/libc-header-start.h:33,
                    from /usr/include/stdlib.h:26,
                    from hugetlb-madvise.c:16:
   /usr/include/features.h:407: note: this is the location of the previous definition
     407 | # define __USE_GNU      1
         |

Link: https://lkml.kernel.org/r/Y8V9z+z6Tk7NetI3@x1n
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/hugetlb-madvise.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/vm/hugetlb-madvise.c b/tools/testing/selftests/vm/hugetlb-madvise.c
index 3c9943131881..b3f01f1f7a60 100644
--- a/tools/testing/selftests/vm/hugetlb-madvise.c
+++ b/tools/testing/selftests/vm/hugetlb-madvise.c
@@ -16,7 +16,6 @@
 #include <stdio.h>
 #include <unistd.h>
 #include <sys/mman.h>
-#define __USE_GNU
 #include <fcntl.h>
 
 #define USAGE	"USAGE: %s <hugepagefile_name>\n"
-- 
2.39.0



