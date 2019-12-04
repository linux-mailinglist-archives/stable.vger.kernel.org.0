Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE45E11331C
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730145AbfLDSOe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:14:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:43918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731642AbfLDSOd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:14:33 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A4EA206DF;
        Wed,  4 Dec 2019 18:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575483272;
        bh=cvFZvCXWVi56kGin9wBixbYsa4vDrv6sQdpsJCuvV0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dK3ywxi6RjMq5+89+77QQYywgTL3bvOvI60F3yvsQYXnTuPj8XZX+L4w1MktBYLFc
         0r9QTd/wS7SmaanZTdwOmv1I17fu9YxxXEclPTdE2gYnGUdXpLExEqg9+PggFj+T0+
         aKfaRP6NxXxtt5fm6cxhed9OlXdkRP5RqZ4NNdKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huang Shijie <sjhuang@iluvatar.ai>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Skidanov <alexey.skidanov@intel.com>,
        Olof Johansson <olof@lixom.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 086/125] lib/genalloc.c: include vmalloc.h
Date:   Wed,  4 Dec 2019 18:56:31 +0100
Message-Id: <20191204175324.299603591@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175308.377746305@linuxfoundation.org>
References: <20191204175308.377746305@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



