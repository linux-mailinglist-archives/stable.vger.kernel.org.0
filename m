Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B655EEED46
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389771AbfKDWFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:05:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:36096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389115AbfKDWFD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:05:03 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2AD5205C9;
        Mon,  4 Nov 2019 22:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905102;
        bh=7mNEQb4odMCK8DC3X0ofHK/HaZhcSp9aEhBH5SILLYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fJgTmrPEwJToifcNIBFLXu9vgIcD/wgHjiB4DD/oQzc6mbAghlkF/OeLou3GFRsLT
         BMTcjLztcncPgaBFjqWpKxY4t32U1rHIlRVWDxjmoY6A6UEfqmi4OLSvbQgcQ95nkO
         LQ0sQHP6UBgTw7mhcl/p6agILb3/tJrYugoGcGU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julien Grall <julien.grall@arm.com>,
        mark.brown@arm.com, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 029/163] arm64: cpufeature: Effectively expose FRINT capability to userspace
Date:   Mon,  4 Nov 2019 22:43:39 +0100
Message-Id: <20191104212142.418176586@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



