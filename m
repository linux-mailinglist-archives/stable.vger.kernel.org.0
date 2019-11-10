Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E57CF62ED
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbfKJCqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:46:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:51326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729179AbfKJCqv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:46:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F64221D7E;
        Sun, 10 Nov 2019 02:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354011;
        bh=9vHTsqmnu+cuuI3EJ+XhZIbw+Rq+l0wS6KturhsKzNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iyP9k7sW5ZCG2/jv5NSSwqnsPpaHWTnDrH199i5krd4XeQUBsrISZbIQq/8zF/Mcl
         MedG8x/dfi1Aljr2X6rVseIIYQ8IpZr49NN3RbZxfw0ppFo6altY6z56oEGZrTZ9+3
         g2YiLa5XAldugtNftOrHxDZZ9+BZ6FkItKeCEnSY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Agner <stefan@agner.ch>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.14 036/109] cpufeature: avoid warning when compiling with clang
Date:   Sat,  9 Nov 2019 21:44:28 -0500
Message-Id: <20191110024541.31567-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Agner <stefan@agner.ch>

[ Upstream commit c785896b21dd8e156326ff660050b0074d3431df ]

The table id (second) argument to MODULE_DEVICE_TABLE is often
referenced otherwise. This is not the case for CPU features. This
leads to warnings when building the kernel with Clang:
  arch/arm/crypto/aes-ce-glue.c:450:1: warning: variable
    'cpu_feature_match_AES' is not needed and will not be emitted
    [-Wunneeded-internal-declaration]
  module_cpu_feature_match(AES, aes_init);
  ^

Avoid warnings by using __maybe_unused, similar to commit 1f318a8bafcf
("modules: mark __inittest/__exittest as __maybe_unused").

Fixes: 67bad2fdb754 ("cpu: add generic support for CPU feature based module autoloading")
Signed-off-by: Stefan Agner <stefan@agner.ch>
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/cpufeature.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/cpufeature.h b/include/linux/cpufeature.h
index 986c06c88d814..84d3c81b59781 100644
--- a/include/linux/cpufeature.h
+++ b/include/linux/cpufeature.h
@@ -45,7 +45,7 @@
  * 'asm/cpufeature.h' of your favorite architecture.
  */
 #define module_cpu_feature_match(x, __initfunc)			\
-static struct cpu_feature const cpu_feature_match_ ## x[] =	\
+static struct cpu_feature const __maybe_unused cpu_feature_match_ ## x[] = \
 	{ { .feature = cpu_feature(x) }, { } };			\
 MODULE_DEVICE_TABLE(cpu, cpu_feature_match_ ## x);		\
 								\
-- 
2.20.1

