Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9F3300FBF
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 23:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbhAVT7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 14:59:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:37758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728388AbhAVOQ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:16:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D88D123A63;
        Fri, 22 Jan 2021 14:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324795;
        bh=RXTWyssdws4QSfJ+JmgOYZPTOqGjh2f/lY6IjIbNXnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p1+eOAX0YVQHGtL3NxZ9KIObtX8BoD7ziKjEKxuocgYq5FPzTJcgHKo/jjXBIk2E8
         2aIu7LcO56D46nEGc7NyVkyKFt9Iqj1EfdErw1kucB6jxtnW1EYfhlEy8hAkonKghI
         7VCb+aL+z0R92qLANgCdElRTxxL8vHuf6YrRQMlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 11/50] ARC: build: add uImage.lzma to the top-level target
Date:   Fri, 22 Jan 2021 15:11:52 +0100
Message-Id: <20210122135735.647125197@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.176469491@linuxfoundation.org>
References: <20210122135735.176469491@linuxfoundation.org>
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



