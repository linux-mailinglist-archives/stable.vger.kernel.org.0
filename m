Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1084356E7
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 02:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbhJUAXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 20:23:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231515AbhJUAXM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 20:23:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E547C61374;
        Thu, 21 Oct 2021 00:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775657;
        bh=CujmvpHIs6lbGStzSlLrCfn8XAToEiZUTO4Y5Fj20hA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RGaVSkEirQQTsANhv94tB14N13FFMr5g6DddPIqWwxglW2spc1OGb6JuZoMokvuYH
         utRHOHt0M2UisplhxgE3oNRukzPalHrRWr9F+Y8uBCw0Wu6GJlR6QlApGAZGalB114
         1djG29ktjhQvr4bfFXuN0QHW9QXOnZk09/Y6/Zkd59xf3DSgZYtklNPmjfAAky3kEf
         EycLghVF8TODe2MH8p8fusyPvb/yejjx+4mDDnFxeI/PTIzXom9OUYvX5HCzx9q1Fc
         deSDhDxayyvte6tQgg2g0e2ylPB4BExvdikgUkB826KkuAarUCL41ruCqFoYa+xqS+
         Xut3Ap8unyfWg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Brendan Higgins <brendanhiggins@google.com>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, akpm@linux-foundation.org,
        elver@google.com, andriy.shevchenko@linux.intel.com,
        jarkko@kernel.org, thunder.leizhen@huawei.com,
        andreyknvl@gmail.com, johannes.berg@intel.com,
        palmerdabbelt@google.com, jolsa@kernel.org,
        James.Bottomley@HansenPartnership.com
Subject: [PATCH AUTOSEL 5.14 07/26] bitfield: build kunit tests without structleak plugin
Date:   Wed, 20 Oct 2021 20:20:04 -0400
Message-Id: <20211021002023.1128949-7-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002023.1128949-1-sashal@kernel.org>
References: <20211021002023.1128949-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit a8cf90332ae3e2b53813a146a99261b6a5e16a73 ]

The structleak plugin causes the stack frame size to grow immensely:

lib/bitfield_kunit.c: In function 'test_bitfields_constants':
lib/bitfield_kunit.c:93:1: error: the frame size of 7440 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]

Turn it off in this file.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/Makefile b/lib/Makefile
index 5efd1b435a37..a841be5244ac 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -351,7 +351,7 @@ obj-$(CONFIG_OBJAGG) += objagg.o
 obj-$(CONFIG_PLDMFW) += pldmfw/
 
 # KUnit tests
-CFLAGS_bitfield_kunit.o := $(call cc-option,-Wframe-larger-than=10240)
+CFLAGS_bitfield_kunit.o := $(DISABLE_STRUCTLEAK_PLUGIN)
 obj-$(CONFIG_BITFIELD_KUNIT) += bitfield_kunit.o
 obj-$(CONFIG_LIST_KUNIT_TEST) += list-test.o
 obj-$(CONFIG_LINEAR_RANGES_TEST) += test_linear_ranges.o
-- 
2.33.0

