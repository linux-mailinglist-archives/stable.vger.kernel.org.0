Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5A4268BC8
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 15:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbgINNIX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 09:08:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726709AbgINNHV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 09:07:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4092B22247;
        Mon, 14 Sep 2020 13:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600088770;
        bh=Wa7KRm6tn7vNOdpQ4oQQWBXEvv4e9jMtg1Gp+w2t1Lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kxb9fXnq8Efu7+GHnM7BAXpYZw/fwuSyqgO0LMTLZ26bBnYMReK43togA4J9v0t/z
         Jv3clg9hY+TdmdSojaygd/L2df6VuJNF87N6VkgCOABelLI6GLcDob2+9d1yKTKRLI
         u0jG68HbDSFbcTlxiR5kOvBPhnd7RaqCXa6tS15Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Oberparleiter <oberpar@linux.ibm.com>,
        Colin Ian King <colin.king@canonical.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 8/8] gcov: add support for GCC 10.1
Date:   Mon, 14 Sep 2020 09:05:58 -0400
Message-Id: <20200914130559.1805574-8-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914130559.1805574-1-sashal@kernel.org>
References: <20200914130559.1805574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Oberparleiter <oberpar@linux.ibm.com>

[ Upstream commit 40249c6962075c040fd071339acae524f18bfac9 ]

Using gcov to collect coverage data for kernels compiled with GCC 10.1
causes random malfunctions and kernel crashes.  This is the result of a
changed GCOV_COUNTERS value in GCC 10.1 that causes a mismatch between
the layout of the gcov_info structure created by GCC profiling code and
the related structure used by the kernel.

Fix this by updating the in-kernel GCOV_COUNTERS value.  Also re-enable
config GCOV_KERNEL for use with GCC 10.

Reported-by: Colin Ian King <colin.king@canonical.com>
Reported-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Tested-by: Leon Romanovsky <leonro@nvidia.com>
Tested-and-Acked-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/gcov/gcc_4_7.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/gcov/gcc_4_7.c b/kernel/gcov/gcc_4_7.c
index 46a18e72bce61..6d5ef6220afe7 100644
--- a/kernel/gcov/gcc_4_7.c
+++ b/kernel/gcov/gcc_4_7.c
@@ -18,7 +18,9 @@
 #include <linux/vmalloc.h>
 #include "gcov.h"
 
-#if (__GNUC__ >= 7)
+#if (__GNUC__ >= 10)
+#define GCOV_COUNTERS			8
+#elif (__GNUC__ >= 7)
 #define GCOV_COUNTERS			9
 #elif (__GNUC__ > 5) || (__GNUC__ == 5 && __GNUC_MINOR__ >= 1)
 #define GCOV_COUNTERS			10
-- 
2.25.1

