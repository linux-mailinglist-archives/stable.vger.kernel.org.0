Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEF8148984
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 15:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388238AbgAXOfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 09:35:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:39900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391754AbgAXOTc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 09:19:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3A3320838;
        Fri, 24 Jan 2020 14:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875571;
        bh=CwDH/HNXqT9/UsCdUOLdCqHjqNXYqggcWW09wtaEFS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YV3mVzHUQv8DabbMzubH9nmHbGnqemm8gg1idgXxgl6+0oR1MU9QZ1atRSt5MaKvO
         oJhf6cy8sRVkqf8k6BF4LMPQV+9/yF/DiJ3rUdlwoRgbt+OMRKhU73USkite2i6O+U
         +FE+vSyBb1mkPqaQaf5dUgE6Pwd4T566nMZrS5Ng=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brendan Higgins <brendanhiggins@google.com>,
        Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 064/107] lkdtm/bugs: fix build error in lkdtm_UNSET_SMEP
Date:   Fri, 24 Jan 2020 09:17:34 -0500
Message-Id: <20200124141817.28793-64-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brendan Higgins <brendanhiggins@google.com>

[ Upstream commit 0e31e3573f0cd94d7b821117db854187ffc85765 ]

When building ARCH=um with CONFIG_UML_X86=y and CONFIG_64BIT=y we get
the build errors:

drivers/misc/lkdtm/bugs.c: In function ‘lkdtm_UNSET_SMEP’:
drivers/misc/lkdtm/bugs.c:288:8: error: implicit declaration of function ‘native_read_cr4’ [-Werror=implicit-function-declaration]
  cr4 = native_read_cr4();
        ^~~~~~~~~~~~~~~
drivers/misc/lkdtm/bugs.c:290:13: error: ‘X86_CR4_SMEP’ undeclared (first use in this function); did you mean ‘X86_FEATURE_SMEP’?
  if ((cr4 & X86_CR4_SMEP) != X86_CR4_SMEP) {
             ^~~~~~~~~~~~
             X86_FEATURE_SMEP
drivers/misc/lkdtm/bugs.c:290:13: note: each undeclared identifier is reported only once for each function it appears in
drivers/misc/lkdtm/bugs.c:297:2: error: implicit declaration of function ‘native_write_cr4’; did you mean ‘direct_write_cr4’? [-Werror=implicit-function-declaration]
  native_write_cr4(cr4);
  ^~~~~~~~~~~~~~~~
  direct_write_cr4

So specify that this block of code should only build when
CONFIG_X86_64=y *AND* CONFIG_UML is unset.

Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
Acked-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20191213003522.66450-1-brendanhiggins@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/lkdtm/bugs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/lkdtm/bugs.c b/drivers/misc/lkdtm/bugs.c
index 7284a22b1a09e..4d5a512769e99 100644
--- a/drivers/misc/lkdtm/bugs.c
+++ b/drivers/misc/lkdtm/bugs.c
@@ -274,7 +274,7 @@ void lkdtm_STACK_GUARD_PAGE_TRAILING(void)
 
 void lkdtm_UNSET_SMEP(void)
 {
-#ifdef CONFIG_X86_64
+#if IS_ENABLED(CONFIG_X86_64) && !IS_ENABLED(CONFIG_UML)
 #define MOV_CR4_DEPTH	64
 	void (*direct_write_cr4)(unsigned long val);
 	unsigned char *insn;
-- 
2.20.1

