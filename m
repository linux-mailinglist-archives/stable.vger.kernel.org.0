Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90287272CDB
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgIUQf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:35:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:34560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728409AbgIUQfZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:35:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EF4C2399C;
        Mon, 21 Sep 2020 16:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706124;
        bh=0T9A2vS3EgCx7mMbINIZB7rlmmiUXGqbIW/pd8eX46s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XYoUbvNajWHVjY/VfNyFZISspu8UC7wEmjBGL8J+RRI61XYqtdFgPT8/7xG6jVFTC
         1/MzSGWCUkid698RbmrC+FF4B7zrmu+FpOuo66feNdxLoBkqGyG1PuUtL0lZZj2z8D
         zn1MEYUaqcDVkCJGd48c6qw9MLfcrJOfxsOLpeqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 47/70] gcov: add support for GCC 10.1
Date:   Mon, 21 Sep 2020 18:27:47 +0200
Message-Id: <20200921162037.274861556@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.136047591@linuxfoundation.org>
References: <20200921162035.136047591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
 kernel/gcov/Kconfig   | 1 -
 kernel/gcov/gcc_4_7.c | 4 +++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/gcov/Kconfig b/kernel/gcov/Kconfig
index 1d78ed19a3512..1276aabaab550 100644
--- a/kernel/gcov/Kconfig
+++ b/kernel/gcov/Kconfig
@@ -3,7 +3,6 @@ menu "GCOV-based kernel profiling"
 config GCOV_KERNEL
 	bool "Enable gcov-based kernel profiling"
 	depends on DEBUG_FS
-	depends on !CC_IS_GCC || GCC_VERSION < 100000
 	select CONSTRUCTORS if !UML
 	default n
 	---help---
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



