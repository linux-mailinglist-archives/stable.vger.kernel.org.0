Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD89F2F310C
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730171AbhALNP2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:15:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:53894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404218AbhALM5v (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A40702343F;
        Tue, 12 Jan 2021 12:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456208;
        bh=tT2JVAOyu67caF+7hVecNlQnhoOZBnX1WTz/U0A/ivw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S0q+4L3bKCW8NlpSS90eHsa+7SL0dCvDdA9Dl+aNRoeuDJBg+Au9IBy4o0GVMQ9tQ
         KfxyDEC+s5QxW8Kt+BHOLnQicYTrJ8sE8SEdtDmhzoO3Ori/LaKN3g6k06Hq8JwE33
         CqIE1F9grtPGzSlDHiOflCaSvyatA6K1PiOAA+DinmN4oKVpMl9b/oOveDZ8ETsg+l
         ITl5GY63TXZ9JIYbMzB/YRwzFmkeR+NFBtS5+i4NBV73rgt3UTeP0vgtjOmhkAkZ3D
         bDgu5knw3cZy6I0QW6iFXoYLmW8/w39yFRrFgIYmOeOGTpRCfwZtMdN8ZNKoc0C+nn
         8ar3k0RLv48+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 02/28] ARC: build: add uImage.lzma to the top-level target
Date:   Tue, 12 Jan 2021 07:56:18 -0500
Message-Id: <20210112125645.70739-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125645.70739-1-sashal@kernel.org>
References: <20210112125645.70739-1-sashal@kernel.org>
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
index 5e5699acefef4..b0b119ebd9e9f 100644
--- a/arch/arc/Makefile
+++ b/arch/arc/Makefile
@@ -90,7 +90,7 @@ libs-y		+= arch/arc/lib/ $(LIBGCC)
 
 boot		:= arch/arc/boot
 
-boot_targets += uImage uImage.bin uImage.gz
+boot_targets := uImage uImage.bin uImage.gz uImage.lzma
 
 $(boot_targets): vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
-- 
2.27.0

