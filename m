Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE7C2FAA25
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437325AbhART1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:27:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:33434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390435AbhARLiL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:38:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83DA0223E4;
        Mon, 18 Jan 2021 11:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969850;
        bh=sz1R3HwZb4o4qiTaMpMikNw4vJUb6krejvhqf5QBTOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mFKKHvoFcsrrLMuHUb+JTSEsoK6mkKyvuUnRUX937ZfbETFhMhB4a3YlneLOdcszc
         R05aaOknwl/S2TSG9k3YmL/N9BlXatcHdCFZbGPANXDM4qc7dkIOoX6NBlzC1YdAPd
         OwX9gioq2AyeR5uVBTi4DBjqsNiFuMNgiJDGqbSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 14/43] ARC: build: add uImage.lzma to the top-level target
Date:   Mon, 18 Jan 2021 12:34:37 +0100
Message-Id: <20210118113335.636914760@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113334.966227881@linuxfoundation.org>
References: <20210118113334.966227881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



