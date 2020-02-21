Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2994E16726F
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731324AbgBUID2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:03:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:36188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731004AbgBUIDY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:03:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A564F2073A;
        Fri, 21 Feb 2020 08:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272204;
        bh=F1Trexx99c5lKvDtbQFpRyhfDrMxurBJs0BaHnCMNeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EZ0tH52qpHCIXvYQe1QQzfA6I+elvo9C7L2Z4eHnbPjngIlE4FCk19zF7Jalora25
         W3BORveQqhKhtIEjePPuqWsAAituRoMmVXTBRJ8yRdFbmbUvCOh+lyeYjHK0Jv2uUg
         T6rtsYNvLyfIKmKoEydJsWdq+pBXYPPbpZm6sTu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhengyuan Liu <liuzhengyuan@kylinos.cn>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 054/344] raid6/test: fix a compilation error
Date:   Fri, 21 Feb 2020 08:37:33 +0100
Message-Id: <20200221072353.982938414@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengyuan Liu <liuzhengyuan@kylinos.cn>

[ Upstream commit 6b8651aac1dca6140dd7fb4c9fec2736ed3f6223 ]

The compilation error is redeclaration showed as following:

        In file included from ../../../include/linux/limits.h:6,
                         from /usr/include/x86_64-linux-gnu/bits/local_lim.h:38,
                         from /usr/include/x86_64-linux-gnu/bits/posix1_lim.h:161,
                         from /usr/include/limits.h:183,
                         from /usr/lib/gcc/x86_64-linux-gnu/8/include-fixed/limits.h:194,
                         from /usr/lib/gcc/x86_64-linux-gnu/8/include-fixed/syslimits.h:7,
                         from /usr/lib/gcc/x86_64-linux-gnu/8/include-fixed/limits.h:34,
                         from ../../../include/linux/raid/pq.h:30,
                         from algos.c:14:
        ../../../include/linux/types.h:114:15: error: conflicting types for ‘int64_t’
         typedef s64   int64_t;
                       ^~~~~~~
        In file included from /usr/include/stdint.h:34,
                         from /usr/lib/gcc/x86_64-linux-gnu/8/include/stdint.h:9,
                         from /usr/include/inttypes.h:27,
                         from ../../../include/linux/raid/pq.h:29,
                         from algos.c:14:
        /usr/include/x86_64-linux-gnu/bits/stdint-intn.h:27:19: note: previous \
        declaration of ‘int64_t’ was here
         typedef __int64_t int64_t;

Fixes: 54d50897d544 ("linux/kernel.h: split *_MAX and *_MIN macros into <linux/limits.h>")
Signed-off-by: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/raid/pq.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
index 0832c9b66852e..0b6e7ad9cd2a8 100644
--- a/include/linux/raid/pq.h
+++ b/include/linux/raid/pq.h
@@ -27,7 +27,6 @@ extern const char raid6_empty_zero_page[PAGE_SIZE];
 
 #include <errno.h>
 #include <inttypes.h>
-#include <limits.h>
 #include <stddef.h>
 #include <sys/mman.h>
 #include <sys/time.h>
-- 
2.20.1



