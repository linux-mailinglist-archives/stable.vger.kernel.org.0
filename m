Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78C6E15EEDC
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729314AbgBNRny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:43:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:50070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388889AbgBNQDL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:03:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6656E24681;
        Fri, 14 Feb 2020 16:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696191;
        bh=F1Trexx99c5lKvDtbQFpRyhfDrMxurBJs0BaHnCMNeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QGS6Od08BPiiCrTCRku8lhBAQt/yg+ECUc+Ghb10lhp4AyPr+JubQFBfpZ71dojU2
         k6ZQR62Z09a56u7vsguw3Qthel0o6d2skKXUsuM4eWx7Acn/9+H29bUkAFUow6YC13
         Z21BD0m5EhGqb270oozRqNJyjGm3T4a3pwP0WA+k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhengyuan Liu <liuzhengyuan@kylinos.cn>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>, linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 059/459] raid6/test: fix a compilation error
Date:   Fri, 14 Feb 2020 10:55:09 -0500
Message-Id: <20200214160149.11681-59-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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

