Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48033493A3
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730382AbfFQV1V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:27:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730374AbfFQV1U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:27:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3019B20673;
        Mon, 17 Jun 2019 21:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806839;
        bh=isSl2BjlHqsbVPt3ofMDli9l0+uicK+q5i4O7roTIa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=spTvV5WxLK1/bh/yimhqBsfG8p6bozUYwMl7D34O9p/OoFx7775NOc6bRW0aSmNDs
         dxwrkYczmwscKtsfc9epDTTZfF9bDnj14A6hPS4KmpYE+zMRBIXQyZgNxYUnnXiYQ6
         Dlj2mE0tRfzxqmZzE0Emxm0wtQBPo71ElkjKowtU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 31/75] s390/kasan: fix strncpy_from_user kasan checks
Date:   Mon, 17 Jun 2019 23:09:42 +0200
Message-Id: <20190617210754.018813332@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210752.799453599@linuxfoundation.org>
References: <20190617210752.799453599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 01eb42afb45719cb41bb32c278e068073738899d ]

arch/s390/lib/uaccess.c is built without kasan instrumentation. Kasan
checks are performed explicitly in copy_from_user/copy_to_user
functions. But since those functions could be inlined, calls from
files like uaccess.c with instrumentation disabled won't generate
kasan reports. This is currently the case with strncpy_from_user
function which was revealed by newly added kasan test. Avoid inlining of
copy_from_user/copy_to_user when the kernel is built with kasan support
to make sure kasan checks are fully functional.

Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/uaccess.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/include/asm/uaccess.h b/arch/s390/include/asm/uaccess.h
index ad6b91013a05..5332f628c1ed 100644
--- a/arch/s390/include/asm/uaccess.h
+++ b/arch/s390/include/asm/uaccess.h
@@ -56,8 +56,10 @@ raw_copy_from_user(void *to, const void __user *from, unsigned long n);
 unsigned long __must_check
 raw_copy_to_user(void __user *to, const void *from, unsigned long n);
 
+#ifndef CONFIG_KASAN
 #define INLINE_COPY_FROM_USER
 #define INLINE_COPY_TO_USER
+#endif
 
 #ifdef CONFIG_HAVE_MARCH_Z10_FEATURES
 
-- 
2.20.1



