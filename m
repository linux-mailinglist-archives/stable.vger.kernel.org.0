Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4F018B6D6
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730005AbgCSNXA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:23:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730293AbgCSNW7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:22:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F118C206D7;
        Thu, 19 Mar 2020 13:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624179;
        bh=v6rvCBmeL+E4vddPIjozzmAG55y2N6MSdRrgBlSjulQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x40yn6emLMp6u99xsM2/NxOnHzEXnjT9tNHXdB6akUYZ1TVHRyVN7ZV6VMkCPcvux
         g4xz6ec9GF2fWQuy7SYjRdLQnMiubTgVsthm+CmzQVZJjN9x6kZsHiCg04d93akeV1
         7ZFJ2E8EoC4pMM7RdxJuMrkMgussOpmy8t2Y1t9c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 34/60] kbuild: add dtbs_check to PHONY
Date:   Thu, 19 Mar 2020 14:04:12 +0100
Message-Id: <20200319123930.591620953@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123919.441695203@linuxfoundation.org>
References: <20200319123919.441695203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 964a596db8db8c77c9903dd05655696696e6b3ad ]

The dtbs_check should be a phony target, but currently it is not
specified so.

'make dtbs_check' works even if a file named 'dtbs_check' exists
because it depends on another phony target, scripts_dtc, but we
should not rely on it.

Add dtbs_check to PHONY.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 2250b1bb8aa9f..b308b84c069c8 100644
--- a/Makefile
+++ b/Makefile
@@ -1237,7 +1237,7 @@ ifneq ($(dtstree),)
 %.dtb: include/config/kernel.release scripts_dtc
 	$(Q)$(MAKE) $(build)=$(dtstree) $(dtstree)/$@
 
-PHONY += dtbs dtbs_install dt_binding_check
+PHONY += dtbs dtbs_install dtbs_check dt_binding_check
 dtbs dtbs_check: include/config/kernel.release scripts_dtc
 	$(Q)$(MAKE) $(build)=$(dtstree)
 
-- 
2.20.1



