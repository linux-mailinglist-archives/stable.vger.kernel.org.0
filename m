Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E233C34C823
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbhC2IUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:20:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233498AbhC2ITW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:19:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C30261974;
        Mon, 29 Mar 2021 08:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005962;
        bh=AIRVlVjfMhRuu1rPQ4w9zArxQpygLeXjNFQkX75pK1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PADIa9umuM3UnlGEbaL+uPHbezJEaSr9oArXWFp3on9LHwD5oJuj2Lc2cZETQkGo9
         oDtyRGXPFVD2Ii39atGJ0jmSk4k8j/yghK/kuIeklN5vzAm1FN58WyBqwld5nXRN59
         rh4mTJNe8fK01EMjSOm5Raqsrta27OJ1Id9inlls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/221] kbuild: add image_name to no-sync-config-targets
Date:   Mon, 29 Mar 2021 09:56:03 +0200
Message-Id: <20210329075630.240411634@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 993bdde94547887faaad4a97f0b0480a6da271c3 ]

'make image_name' needs include/config/auto.conf to show the correct
output because KBUILD_IMAGE depends on CONFIG options, but should not
attempt to resync the configuration.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index d4b87e604762..cb9a1592f72c 100644
--- a/Makefile
+++ b/Makefile
@@ -265,7 +265,8 @@ no-dot-config-targets := $(clean-targets) \
 			 $(version_h) headers headers_% archheaders archscripts \
 			 %asm-generic kernelversion %src-pkg dt_binding_check \
 			 outputmakefile
-no-sync-config-targets := $(no-dot-config-targets) %install kernelrelease
+no-sync-config-targets := $(no-dot-config-targets) %install kernelrelease \
+			  image_name
 single-targets := %.a %.i %.ko %.lds %.ll %.lst %.mod %.o %.s %.symtypes %/
 
 config-build	:=
-- 
2.30.1



