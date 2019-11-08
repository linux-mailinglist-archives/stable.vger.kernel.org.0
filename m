Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD4E2F545D
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 19:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732685AbfKHS4v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:56:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:54500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732635AbfKHS4t (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:56:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CF7B21D7F;
        Fri,  8 Nov 2019 18:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239409;
        bh=62vY4g6/bESYO88NRwrlwzQy36mMS6grugZ4Uu9XJ9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KNNNzQiZvT7dCdrRzcVvskWj3p8/S7ez1VEc3gzlrSOrVRypIVmjCmvBlaMj31+Hw
         xyJGnU09OB6eVahEH+QQs8DJCkDDuq0HQn/TZf3gdY6/i8V+bMxPDSHj0lRth70oBK
         al2qM12goNTlCQetxtRuLJv6d9qX+OFCrPwbtLEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 29/34] Kbuild: make designated_init attribute fatal
Date:   Fri,  8 Nov 2019 19:50:36 +0100
Message-Id: <20191108174651.103667553@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174618.266472504@linuxfoundation.org>
References: <20191108174618.266472504@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit c834f0e8a8bb3025aac38e802fca2e686720f544 ]

If a structure is marked with __attribute__((designated_init)) from
GCC or Sparse, it needs to have all static initializers using designated
initialization. Fail the build for any missing cases. This attribute will
be used by the randstruct plugin to make sure randomized structures are
being correctly initialized.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Makefile b/Makefile
index b7f6639f4e7a2..19c7e30684077 100644
--- a/Makefile
+++ b/Makefile
@@ -834,6 +834,9 @@ KBUILD_CFLAGS   += $(call cc-option,-Werror=date-time)
 # enforce correct pointer usage
 KBUILD_CFLAGS   += $(call cc-option,-Werror=incompatible-pointer-types)
 
+# Require designated initializers for all marked structures
+KBUILD_CFLAGS   += $(call cc-option,-Werror=designated-init)
+
 # use the deterministic mode of AR if available
 KBUILD_ARFLAGS := $(call ar-option,D)
 
-- 
2.20.1



