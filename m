Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B36817AC41
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 18:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727967AbgCERPJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 12:15:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:41738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727103AbgCERPI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 12:15:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C78A7207FD;
        Thu,  5 Mar 2020 17:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428508;
        bh=7M+MHBAueuoMIHDpXd6nOQaummZQi3hBIOofFJJVEG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dfgg5K1Hrux+yK8aWN9yL2CybC/co0X3EnW2hu3QKsTc6rnOcGB61JYWYGOX7HZ+O
         ReoCMdQ4jAn3gZrmA2FEHY1Yrx+zydkqEzNvWqWyyCL0435v1uSv+vXie4k7yeLygq
         3PP6MWXAtcHX45bd0lQ5zcTHrfehsCjVs6WnwPjY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 38/58] kbuild: add dtbs_check to PHONY
Date:   Thu,  5 Mar 2020 12:13:59 -0500
Message-Id: <20200305171420.29595-38-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305171420.29595-1-sashal@kernel.org>
References: <20200305171420.29595-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index af5e90075514a..63094ce5e5744 100644
--- a/Makefile
+++ b/Makefile
@@ -1242,7 +1242,7 @@ ifneq ($(dtstree),)
 %.dtb: include/config/kernel.release scripts_dtc
 	$(Q)$(MAKE) $(build)=$(dtstree) $(dtstree)/$@
 
-PHONY += dtbs dtbs_install dt_binding_check
+PHONY += dtbs dtbs_install dtbs_check dt_binding_check
 dtbs dtbs_check: include/config/kernel.release scripts_dtc
 	$(Q)$(MAKE) $(build)=$(dtstree)
 
-- 
2.20.1

