Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC752DD162
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 13:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbgLQMTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 07:19:18 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:51185 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727215AbgLQMTN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Dec 2020 07:19:13 -0500
X-UUID: d8bec07d2f73466d908a195ff5aef059-20201217
X-UUID: d8bec07d2f73466d908a195ff5aef059-20201217
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <kuan-ying.lee@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 624995331; Thu, 17 Dec 2020 20:18:27 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 17 Dec 2020 20:18:23 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 17 Dec 2020 20:18:24 +0800
From:   Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
To:     Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     <kasan-dev@googlegroups.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>,
        <stable@vger.kernel.org>,
        Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Subject: [PATCH v2 1/1] kasan: fix memory leak of kasan quarantine
Date:   Thu, 17 Dec 2020 20:18:07 +0800
Message-ID: <1608207487-30537-2-git-send-email-Kuan-Ying.Lee@mediatek.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1608207487-30537-1-git-send-email-Kuan-Ying.Lee@mediatek.com>
References: <1608207487-30537-1-git-send-email-Kuan-Ying.Lee@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When cpu is going offline, set q->offline as true
and interrupt happened. The interrupt may call the
quarantine_put. But quarantine_put do not free the
the object. The object will cause memory leak.

Add qlink_free() to free the object.

Fixes: 6c82d45c7f03 (kasan: fix object remaining in offline per-cpu quarantine)
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: <stable@vger.kernel.org>    [5.10-]
---
 mm/kasan/quarantine.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/kasan/quarantine.c b/mm/kasan/quarantine.c
index 0e3f8494628f..cac7c617df72 100644
--- a/mm/kasan/quarantine.c
+++ b/mm/kasan/quarantine.c
@@ -191,6 +191,7 @@ void quarantine_put(struct kasan_free_meta *info, struct kmem_cache *cache)
 
 	q = this_cpu_ptr(&cpu_quarantine);
 	if (q->offline) {
+		qlink_free(&info->quarantine_link, cache);
 		local_irq_restore(flags);
 		return;
 	}
-- 
2.18.0

