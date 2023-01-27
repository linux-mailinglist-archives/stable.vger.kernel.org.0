Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456D067E73E
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 14:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233629AbjA0N6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 08:58:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233618AbjA0N6J (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 08:58:09 -0500
Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C670CC33;
        Fri, 27 Jan 2023 05:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1674827882;
        bh=O7TLRnBFvO2mHHa21PT6sPp6oCHu3V7ypNifZtvavPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZukGHJ6A7yYm6vWBR0x6cfQeDJ8DOdZTmdLGkp7msE5Wh4164c19x2crtPcxPqmKX
         gwLw6MU42H2bTzJ87s8H8rdU03aGPZTfaUhOqd7iCCHLRxKjz3yIXwliEUG+DeZvNQ
         lGFI70OLj2FMAsYtWOtSmeYBqOgBByvnpd75xBkdICM6NEefPvy/qbBAJL85c0tASM
         rW7uvJg+Ke8ZoAdTu6JwUwsuS5O1RKa5AYGMWpCE0u6OPq8fikECrgi41ncg2IFXZ+
         9A3poRmFvcQC8sm8WuUahTzU3FVLg8SUZRvh1ESR79lG19F/VZDhpLIwHtk54TghjW
         ZeiwqRH7M9rfw==
Received: from localhost.localdomain (192-222-180-24.qc.cable.ebox.net [192.222.180.24])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4P3K0V2yJXzhff;
        Fri, 27 Jan 2023 08:58:02 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        stable@vger.kernel.org
Subject: [PATCH 06/34] selftests: dmabuf-heaps: Fix incorrect kernel headers search path
Date:   Fri, 27 Jan 2023 08:57:27 -0500
Message-Id: <20230127135755.79929-7-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230127135755.79929-1-mathieu.desnoyers@efficios.com>
References: <20230127135755.79929-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Use $(KHDR_INCLUDES) as lookup path for kernel headers. This prevents
building against kernel headers from the build environment in scenarios
where kernel headers are installed into a specific output directory
(O=...).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: linux-kselftest@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>
Cc: <stable@vger.kernel.org>    [5.18+]
---
 tools/testing/selftests/dmabuf-heaps/Makefile      | 2 +-
 tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/dmabuf-heaps/Makefile b/tools/testing/selftests/dmabuf-heaps/Makefile
index 604b43ece15f..9e7e158d5fa3 100644
--- a/tools/testing/selftests/dmabuf-heaps/Makefile
+++ b/tools/testing/selftests/dmabuf-heaps/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-CFLAGS += -static -O3 -Wl,-no-as-needed -Wall
+CFLAGS += -static -O3 -Wl,-no-as-needed -Wall $(KHDR_INCLUDES)
 
 TEST_GEN_PROGS = dmabuf-heap
 
diff --git a/tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c b/tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c
index 29af27acd40e..890a8236a8ba 100644
--- a/tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c
+++ b/tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c
@@ -13,10 +13,9 @@
 #include <sys/types.h>
 
 #include <linux/dma-buf.h>
+#include <linux/dma-heap.h>
 #include <drm/drm.h>
 
-#include "../../../../include/uapi/linux/dma-heap.h"
-
 #define DEVPATH "/dev/dma_heap"
 
 static int check_vgem(int fd)
-- 
2.25.1

