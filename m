Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53B64E28C2
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 14:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348529AbiCUOA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348481AbiCUN5M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 09:57:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB52174BBF;
        Mon, 21 Mar 2022 06:55:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1954CB81644;
        Mon, 21 Mar 2022 13:55:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69454C340E8;
        Mon, 21 Mar 2022 13:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647870915;
        bh=wtBMbSUCfuXVWS0RoBupiBILo/cK+7+qvUHKeR1eerY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lWRqrciVW5cfcVt2t5DPrDmcMjEFGWW9+SWGYRxLGmbq494nSm9Njby3JxBbEzfqx
         zFHEhxipgr6KrN+3SNdh2SxYZnXmqlD1T3Wl+mqH3Jbk6Vvtug7Rda0A4UO0ad8g6z
         v6cvixByz/yvkkfrl5qbbaqNjI770qaWb+9KYF8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chengming Zhou <zhouchengming@bytedance.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 16/57] kselftest/vm: fix tests build with old libc
Date:   Mon, 21 Mar 2022 14:51:57 +0100
Message-Id: <20220321133222.457059192@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133221.984120927@linuxfoundation.org>
References: <20220321133221.984120927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengming Zhou <zhouchengming@bytedance.com>

[ Upstream commit b773827e361952b3f53ac6fa4c4e39ccd632102e ]

The error message when I build vm tests on debian10 (GLIBC 2.28):

    userfaultfd.c: In function `userfaultfd_pagemap_test':
    userfaultfd.c:1393:37: error: `MADV_PAGEOUT' undeclared (first use
    in this function); did you mean `MADV_RANDOM'?
      if (madvise(area_dst, test_pgsize, MADV_PAGEOUT))
                                         ^~~~~~~~~~~~
                                         MADV_RANDOM

This patch includes these newer definitions from UAPI linux/mman.h, is
useful to fix tests build on systems without these definitions in glibc
sys/mman.h.

Link: https://lkml.kernel.org/r/20220227055330.43087-2-zhouchengming@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/userfaultfd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/vm/userfaultfd.c
+++ b/tools/testing/selftests/vm/userfaultfd.c
@@ -60,6 +60,7 @@
 #include <signal.h>
 #include <poll.h>
 #include <string.h>
+#include <linux/mman.h>
 #include <sys/mman.h>
 #include <sys/syscall.h>
 #include <sys/ioctl.h>


