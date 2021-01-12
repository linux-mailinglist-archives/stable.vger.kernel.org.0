Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2026F2F307B
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbhALNFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:05:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:54600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405268AbhALM63 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:58:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 527692333B;
        Tue, 12 Jan 2021 12:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456273;
        bh=RXTWyssdws4QSfJ+JmgOYZPTOqGjh2f/lY6IjIbNXnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fp0PoNKG/AKVtVJbgvzoXSNmVAHzHoI3RfB7vXR4uHWOIuX3gqgZQO+sxDCXULree
         825yQdphvCouKgMGdWGG38Cg46/OxNfcOfdneWLJVMH1QOsFUK/WNML8aB1i1W3vW4
         0h1tCsDulkvh63d55PeAW1dC3pJG1MKSlMlkDH3L+gPQJOMd1uXRRmhnfEUpAa0C13
         U3q8pKjMKtxisgKqX/+lYM6LLZ9haBkA9AEIwnlVgX19hqaDQAHzoSr/i5q12OZV2/
         v54QOnewECN9xPwYHfSC1UA0Nn5A/K7jpdLi5h2MtcSlix9sggAm3gGGzjXZgNW/XG
         DK6ZLOMuzTstg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 02/13] ARC: build: add uImage.lzma to the top-level target
Date:   Tue, 12 Jan 2021 07:57:38 -0500
Message-Id: <20210112125749.71193-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125749.71193-1-sashal@kernel.org>
References: <20210112125749.71193-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit f2712ec76a5433e5ec9def2bd52a95df1f96d050 ]

arch/arc/boot/Makefile supports uImage.lzma, but you cannot do
'make uImage.lzma' because the corresponding target is missing
in arch/arc/Makefile. Add it.

I also changed the assignment operator '+=' to ':=' since this is the
only place where we expect this variable to be set.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arc/Makefile b/arch/arc/Makefile
index 98d31b701a97c..1146ca5fc349b 100644
--- a/arch/arc/Makefile
+++ b/arch/arc/Makefile
@@ -99,7 +99,7 @@ libs-y		+= arch/arc/lib/ $(LIBGCC)
 
 boot		:= arch/arc/boot
 
-boot_targets += uImage uImage.bin uImage.gz
+boot_targets := uImage uImage.bin uImage.gz uImage.lzma
 
 $(boot_targets): vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
-- 
2.27.0

