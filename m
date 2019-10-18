Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80A52DD49F
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727630AbfJRWEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:04:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727598AbfJRWEB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:04:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20EC220679;
        Fri, 18 Oct 2019 22:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436240;
        bh=7mNEQb4odMCK8DC3X0ofHK/HaZhcSp9aEhBH5SILLYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oUypFvpj2UuEgxOvBSw+zPUfH0QagKrnMu0Z7dBGhrG4PcVKjczv2I9sQsPZKUkJi
         5NdnAaBnLSAFRVeddFFZqAtaWlFlN/3vzJekwvRd9df+T2ov9y38tsDLR/I6p23KAB
         yhLO/O67K5ijnbQe/lVdtkTsff4BjxxyfJiYO3AU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julien Grall <julien.grall@arm.com>, mark.brown@arm.com,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 25/89] arm64: cpufeature: Effectively expose FRINT capability to userspace
Date:   Fri, 18 Oct 2019 18:02:20 -0400
Message-Id: <20191018220324.8165-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julien Grall <julien.grall@arm.com>

[ Upstream commit 7230f7e99fecc684180322b056fad3853d1029d3 ]

The HWCAP framework will detect a new capability based on the sanitized
version of the ID registers.

Sanitization is based on a whitelist, so any field not described will end
up to be zeroed.

At the moment, ID_AA64ISAR1_EL1.FRINTTS is not described in
ftr_id_aa64isar1. This means the field will be zeroed and therefore the
userspace will not be able to see the HWCAP even if the hardware
supports the feature.

This can be fixed by describing the field in ftr_id_aa64isar1.

Fixes: ca9503fc9e98 ("arm64: Expose FRINT capabilities to userspace")
Signed-off-by: Julien Grall <julien.grall@arm.com>
Cc: mark.brown@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 9323bcc40a58a..cabebf1a79768 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -136,6 +136,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar0[] = {
 
 static const struct arm64_ftr_bits ftr_id_aa64isar1[] = {
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_SB_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_FRINTTS_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_PTR_AUTH),
 		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_GPI_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_PTR_AUTH),
-- 
2.20.1

