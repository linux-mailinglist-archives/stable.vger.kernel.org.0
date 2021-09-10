Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 146A74061B7
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241036AbhIJAn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:43:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232778AbhIJATK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:19:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4710611AF;
        Fri, 10 Sep 2021 00:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233080;
        bh=RJdQ3nWsLAttBVJlilmncsfi80Cb5z8YuY9PlJ87iI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E1iQ6YbS/eirJf4dL3Lrs7JCtVdxD5q6nAhcwmvvCIXWHrkj39W/BvLJI5WOHMKab
         IU4iiIfICfcbzCqhT2Ts7yVvsLE7DFQEO4DxWnTDHqKpZNci3dKFoTRAmimn0roxTH
         4TNpEbQQ1i83nh3BrHyTWCEdwsyyRv+b+dbcejcsqnvJsTqyiAiuQahIx/NOyBbR17
         VibWD8l81qAEHJrjIodOkRTSqR/Hx4+IGUYVANb3aezleUWKgLx95GtZoMyRip4STZ
         V3KK92BSlSEzX5BkrBE9GX3wTFkxUUirCiXI4G58XTWGkZr7kCOEG/+v9duNPi3AqB
         7qyPPoFZ+E3Bw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.14 88/99] x86/build/vdso: fix missing FORCE for *.so build rule
Date:   Thu,  9 Sep 2021 20:15:47 -0400
Message-Id: <20210910001558.173296-88-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 55a6d00ed0c1b4d20d7966d00fda6848d776658d ]

Add FORCE so that if_changed can detect the command line change.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/vdso/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
index 05c4abc2fdfd..a2dddcc189f6 100644
--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -131,7 +131,7 @@ $(obj)/%-x32.o: $(obj)/%.o FORCE
 targets += vdsox32.lds $(vobjx32s-y)
 
 $(obj)/%.so: OBJCOPYFLAGS := -S --remove-section __ex_table
-$(obj)/%.so: $(obj)/%.so.dbg
+$(obj)/%.so: $(obj)/%.so.dbg FORCE
 	$(call if_changed,objcopy)
 
 $(obj)/vdsox32.so.dbg: $(obj)/vdsox32.lds $(vobjx32s) FORCE
-- 
2.30.2

