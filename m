Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5614246E18F
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 05:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbhLIEjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 23:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbhLIEjL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 23:39:11 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6786FC0617A2
        for <stable@vger.kernel.org>; Wed,  8 Dec 2021 20:35:38 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id x131so4264360pfc.12
        for <stable@vger.kernel.org>; Wed, 08 Dec 2021 20:35:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OTnH146W1h2tRqN4JJ2cRB6UCxYgrVEb9ej66jz/hvo=;
        b=N9rptxSRnfF0MLgUuQ6pniD9NY0xD5gmN9NJ7q7nYIWlGUP0fj+D8bni97+3KJBESg
         YTDJakMn80kzpqKS5vbuzleqCKcNAbRDoV5rKpWPOaKKoANlS3Y3HOLQUCPqmKekZD5N
         DzMUZAR0D2WT1NFLrwnRVJ8pdQaeOC0bE3SbE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OTnH146W1h2tRqN4JJ2cRB6UCxYgrVEb9ej66jz/hvo=;
        b=WVUCZ5iOLf9TS6tbHuyDBZESHpCCCT5sFCV7kwKj+NNSXp8X+oBwru4tOhBRHiqedP
         UG9uui1iuwP0ynJsvXoyemkmlYB581APuFMjcI8CkCD4oVRyzb7UROfIfDJIROH9cfnR
         22cuYuy05Vs552qPsMcAi681118BJ47rIsZXjLSjLS+hE0AVVtHK92Rn0kr7Q0oT6uMO
         qLuYCdquVc76WAHNZD0hqEK5go834D+dqIxNCDv94lyYakZFdjxipO26kBpG0ytWUid3
         qRA0rhbly0mRvRHJzisZkbF1DgZUwua8YMDvfG2RwHqMUm695WoKOdrfl4TO3+meuvC/
         lYdQ==
X-Gm-Message-State: AOAM531egA27FEL7/3bmBnx++2K2ZJFJURo5xgSpLVOsvoQIpvWZANaq
        du2zwmNOISXoKlvrnUX0vQFnRL/8vb0Oaw==
X-Google-Smtp-Source: ABdhPJySi11U26fyrl+v1mQbCHqtQHoohp4ZDdBFMGnKAY4y2rJnvnEeVrvpPP2RjYxbn2uGWN4Mxg==
X-Received: by 2002:a63:1b02:: with SMTP id b2mr31784110pgb.263.1639024537867;
        Wed, 08 Dec 2021 20:35:37 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id p49sm4871738pfw.43.2021.12.08.20.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 20:35:37 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Will Deacon <will@kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] x86/uaccess: Move variable into switch case statement
Date:   Wed,  8 Dec 2021 20:34:56 -0800
Message-Id: <20211209043456.1377875-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1283; h=from:subject; bh=CQ9kD+xEuCd2isJBoD5npKFBg9v/JSWJJPAtzMVJS04=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhsYdwZw0rJHtAVcR94cnaDCxyjWyuuqFcZGv3g4c/ hLnWAcSJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYbGHcAAKCRCJcvTf3G3AJv9SEA CP/7AJxBiaUjVDBOGfIIJpFgNWQf4HuttbJHMmPFyRwMXVG/0joQz8bEc4a850KZE+zJoTqQ9iMhqg gJQTFpLjzbJZh2NnYyZ8dlkvlGz9S4EGShw0WCExxwK1A5iu952CUR22xpgQl39N56Lu0Q1hxSbRdv Fv0YjMhNkckU3pwWjVHb0loOrGSVQHzijkGVvsf2F8noQNiR6gRCHMFaJbGG42aqP6ESpaer0jx7mU AXolO4e5ZOO7jI54h1veFFvQR7OcFGDhDcg2Ywt9CMDqhRaLB4rvDIeZ3RefIsyaw5I4+ZFS5Vw5SJ ztfQKD0GJyPqE2fsautriZzYqkO+qXokvFYwWRg9BN0zgFOZflToTKF6mODp980yOOy33eLFxloWRd r+cl0Vuwze/1CLOE2DvQSozQaOVDRnzbcYqVkm3F9wYodFHdYoEx6PBr2mqjfONDfebverxAIs+yY5 Y04fu4t/HzFTJLmbhPxOSxuKtkUM9U6D7ksvxJC5MQR4pL97Ju3aBGcGLrPjN/fng8RlDEjIkckHad pKzXTKi8eqRwbtpBc/2KIMAvr0Pl47BzP4eTdD+L4FeujC7eC0xjgRy0wFEvlhltfpvCv/oQYBzxqm 8ZSRnmZEt/H/AOpMx4lkaKlYLRgujleG5NwJXE28Na0HSnILtIFrSG7ED25Q==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When building with automatic stack variable initialization, GCC 12
complains about variables defined outside of switch case statements.
Move the variable into the case that uses it, which silences the warning:

./arch/x86/include/asm/uaccess.h:317:23: warning: statement will never be executed [-Wswitch-unreachable]
  317 |         unsigned char x_u8__; \
      |                       ^~~~~~

Fixes: 865c50e1d279 ("x86/uaccess: utilize CONFIG_CC_HAS_ASM_GOTO_OUTPUT")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/include/asm/uaccess.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 33a68407def3..8ab9e79abb2b 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -314,11 +314,12 @@ do {									\
 do {									\
 	__chk_user_ptr(ptr);						\
 	switch (size) {							\
-	unsigned char x_u8__;						\
-	case 1:								\
+	case 1:	{							\
+		unsigned char x_u8__;					\
 		__get_user_asm(x_u8__, ptr, "b", "=q", label);		\
 		(x) = x_u8__;						\
 		break;							\
+	}								\
 	case 2:								\
 		__get_user_asm(x, ptr, "w", "=r", label);		\
 		break;							\
-- 
2.30.2

