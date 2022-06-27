Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1839455CD94
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238112AbiF0LuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238534AbiF0Lsn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C35101E6;
        Mon, 27 Jun 2022 04:42:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66224B8112E;
        Mon, 27 Jun 2022 11:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82ACC3411D;
        Mon, 27 Jun 2022 11:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330127;
        bh=14Cc3lgi1m160+6Jz2NgFBsl2TTrDobQb+bvHimA6DQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GxFbibsEec1Pv0+OvC5u0YItlh7oNHQChsTJE+cTPwuHDzVtPD+WM3WPV2ZxrpuHn
         Lf5JFoR5nhroEcHrCZIPAH1WyIWpPGhJHg71SSFJD5XJxLisXOSWqnArM4NMHvHf6y
         KoezjJdadCn8/4ut8IZDbyLEnAUs0COnKQLkSsww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Liao <liaoyu15@huawei.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 053/181] selftests dma: fix compile error for dma_map_benchmark
Date:   Mon, 27 Jun 2022 13:20:26 +0200
Message-Id: <20220627111946.104494390@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Liao <liaoyu15@huawei.com>

[ Upstream commit 12a29115be72dfc72372af9ded4bc4ae7113a729 ]

When building selftests/dma:
$ make -C tools/testing/selftests TARGETS=dma
I hit the following compilation error:

dma_map_benchmark.c:13:10: fatal error: linux/map_benchmark.h: No such file or directory
 #include <linux/map_benchmark.h>
          ^~~~~~~~~~~~~~~~~~~~~~~

dma/Makefile does not include the map_benchmark.h path, so add
more including path, and fix include order in dma_map_benchmark.c

Fixes: 8ddde07a3d28 ("dma-mapping: benchmark: extract a common header file for map_benchmark definition")
Signed-off-by: Yu Liao <liaoyu15@huawei.com>
Tested-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/dma/Makefile            | 1 +
 tools/testing/selftests/dma/dma_map_benchmark.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/dma/Makefile b/tools/testing/selftests/dma/Makefile
index aa8e8b5b3864..cd8c5ece1cba 100644
--- a/tools/testing/selftests/dma/Makefile
+++ b/tools/testing/selftests/dma/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 CFLAGS += -I../../../../usr/include/
+CFLAGS += -I../../../../include/
 
 TEST_GEN_PROGS := dma_map_benchmark
 
diff --git a/tools/testing/selftests/dma/dma_map_benchmark.c b/tools/testing/selftests/dma/dma_map_benchmark.c
index c3b3c09e995e..5c997f17fcbd 100644
--- a/tools/testing/selftests/dma/dma_map_benchmark.c
+++ b/tools/testing/selftests/dma/dma_map_benchmark.c
@@ -10,8 +10,8 @@
 #include <unistd.h>
 #include <sys/ioctl.h>
 #include <sys/mman.h>
-#include <linux/map_benchmark.h>
 #include <linux/types.h>
+#include <linux/map_benchmark.h>
 
 #define NSEC_PER_MSEC	1000000L
 
-- 
2.35.1



