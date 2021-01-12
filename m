Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9F12F30A6
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbhALNJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:09:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:53862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404980AbhALM6N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:58:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA47C2388D;
        Tue, 12 Jan 2021 12:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456248;
        bh=sz1R3HwZb4o4qiTaMpMikNw4vJUb6krejvhqf5QBTOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ORICluun8ZPtlmqNrNHRWnosn4q2S7rLddgFL6W/knRu3vdD6hde/e4T7j9zoNFfW
         cFnKPr25RYYv23UoW1shR6aG2ne5YQXbpfPDPT/ah268cEjVvE5MsUoFqEfthKo3qr
         rWYX6QVakdCwk4Z9wEeCsAenOl/y1Ve6Ukgj3IeH61DrkgsXBb3P8JS9KgVWedw6HY
         9cD/rGio09F3fJB1xZfiByZ8wVNiLmsreqBZHhuoCtkgb/7b+BPWX6kJvG1/amKuj1
         a6dabZKDlqNd+da6V+7XL6ffQHp3VWKtNNpG6PLQKNDXRGX2nU7tNChKKMKKGdXrqd
         ZbFwtb35gWqIQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 02/16] ARC: build: add uImage.lzma to the top-level target
Date:   Tue, 12 Jan 2021 07:57:11 -0500
Message-Id: <20210112125725.71014-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125725.71014-1-sashal@kernel.org>
References: <20210112125725.71014-1-sashal@kernel.org>
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
index b07fdbdd8c836..cbb110309ae1c 100644
--- a/arch/arc/Makefile
+++ b/arch/arc/Makefile
@@ -91,7 +91,7 @@ libs-y		+= arch/arc/lib/ $(LIBGCC)
 
 boot		:= arch/arc/boot
 
-boot_targets += uImage uImage.bin uImage.gz
+boot_targets := uImage uImage.bin uImage.gz uImage.lzma
 
 $(boot_targets): vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
-- 
2.27.0

