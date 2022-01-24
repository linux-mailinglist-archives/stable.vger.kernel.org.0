Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319D3498F8B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348357AbiAXTxK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:53:10 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38076 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346919AbiAXTsY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:48:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EF3BB811FB;
        Mon, 24 Jan 2022 19:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BFC2C340E5;
        Mon, 24 Jan 2022 19:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053701;
        bh=w+al1ds14mD9E7dlVSEZTS3IUW3zxxoIo+M8eVMaPqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lDr/dDKdAl14w/jJHFiXwBzduGlfWtbM9gb+ZvPtkZTe3N6EotN4VQLT0q0cuPQ/E
         13rBNpR5ouPI8/dJF1AiPZqSYOGiGj+mEqWH7DsB8lVbqbCuUAj3Gvi1lDgfreYy/G
         dn+aE/xnLehjYvn2IOy3u05PYyjKTPf8v5S4At7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 150/563] x86/uaccess: Move variable into switch case statement
Date:   Mon, 24 Jan 2022 19:38:35 +0100
Message-Id: <20220124184029.597819962@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 61646ca83d3889696f2772edaff122dd96a2935e ]

When building with automatic stack variable initialization, GCC 12
complains about variables defined outside of switch case statements.
Move the variable into the case that uses it, which silences the warning:

./arch/x86/include/asm/uaccess.h:317:23: warning: statement will never be executed [-Wswitch-unreachable]
  317 |         unsigned char x_u8__; \
      |                       ^~~~~~

Fixes: 865c50e1d279 ("x86/uaccess: utilize CONFIG_CC_HAS_ASM_GOTO_OUTPUT")
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20211209043456.1377875-1-keescook@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/uaccess.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 5c95d242f38d7..bb1430283c726 100644
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
2.34.1



