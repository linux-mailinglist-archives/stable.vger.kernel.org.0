Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F45210628E
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbfKVGEm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:04:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:41778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728837AbfKVGCv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 01:02:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A6432073B;
        Fri, 22 Nov 2019 06:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402571;
        bh=cvFZvCXWVi56kGin9wBixbYsa4vDrv6sQdpsJCuvV0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QymDANbJs/McXBogcJQ/WsD/orD3C4qmzpS6IOriPEYrvWkYkj53YrQnYuwlj/1mX
         c0qcNjQK/CZ0VukN9XRU3hERxeplNbVnbza3mOquKEf8SJd9xQTWvafZQTzrcH3Z9O
         9yySpnbwL8OxWKD0+tRukqoF0hE0Nc2KMBJ9OBgU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olof Johansson <olof@lixom.net>,
        Huang Shijie <sjhuang@iluvatar.ai>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Skidanov <alexey.skidanov@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 73/91] lib/genalloc.c: include vmalloc.h
Date:   Fri, 22 Nov 2019 01:01:11 -0500
Message-Id: <20191122060129.4239-72-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122060129.4239-1-sashal@kernel.org>
References: <20191122060129.4239-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olof Johansson <olof@lixom.net>

[ Upstream commit 35004f2e55807a1a1491db24ab512dd2f770a130 ]

Fixes build break on most ARM/ARM64 defconfigs:

  lib/genalloc.c: In function 'gen_pool_add_virt':
  lib/genalloc.c:190:10: error: implicit declaration of function 'vzalloc_node'; did you mean 'kzalloc_node'?
  lib/genalloc.c:190:8: warning: assignment to 'struct gen_pool_chunk *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
  lib/genalloc.c: In function 'gen_pool_destroy':
  lib/genalloc.c:254:3: error: implicit declaration of function 'vfree'; did you mean 'kfree'?

Fixes: 6862d2fc8185 ('lib/genalloc.c: use vzalloc_node() to allocate the bitmap')
Cc: Huang Shijie <sjhuang@iluvatar.ai>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Skidanov <alexey.skidanov@intel.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/genalloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/genalloc.c b/lib/genalloc.c
index f365d71cdc774..7e85d1e37a6ea 100644
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -35,6 +35,7 @@
 #include <linux/interrupt.h>
 #include <linux/genalloc.h>
 #include <linux/of_device.h>
+#include <linux/vmalloc.h>
 
 static inline size_t chunk_size(const struct gen_pool_chunk *chunk)
 {
-- 
2.20.1

