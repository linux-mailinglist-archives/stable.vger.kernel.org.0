Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9358445BB90
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243653AbhKXMUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:20:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:36508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243808AbhKXMSw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:18:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28C4F60F5D;
        Wed, 24 Nov 2021 12:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755915;
        bh=VeERWnquwe8O+0h2BDEK+eSK5eTtMoGrfLxGq49TWzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E405x4+Rib1MJo3hwQ6//WAIdbEVhYuvaH8nI6yzRGggunOM2Q9QxLgNDvaqVklp7
         eFT3gYw6waaw2mAOoEX/23G9e3TvinwIgh1nWoQDdms2xfpwlitQwNKCRUGDkaYBCt
         GfKICv6mkSZ+r0E9vdWTle5XQm1nz4LjhRGfsOmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tor Vic <torvic9@mailbox.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 105/207] platform/x86: thinkpad_acpi: Fix bitwise vs. logical warning
Date:   Wed, 24 Nov 2021 12:56:16 +0100
Message-Id: <20211124115707.470017060@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit fd96e35ea7b95f1e216277805be89d66e4ae962d ]

A new warning in clang points out a use of bitwise OR with boolean
expressions in this driver:

drivers/platform/x86/thinkpad_acpi.c:9061:11: error: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
        else if ((strlencmp(cmd, "level disengaged") == 0) |
                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                                           ||
drivers/platform/x86/thinkpad_acpi.c:9061:11: note: cast one or both operands to int to silence this warning
1 error generated.

This should clearly be a logical OR so change it to fix the warning.

Fixes: fe98a52ce754 ("ACPI: thinkpad-acpi: add sysfs support to fan subdriver")
Link: https://github.com/ClangBuiltLinux/linux/issues/1476
Reported-by: Tor Vic <torvic9@mailbox.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lore.kernel.org/r/20211018182537.2316800-1-nathan@kernel.org
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 84bfecded84d9..9c929b5ce58e2 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -8884,7 +8884,7 @@ static int fan_write_cmd_level(const char *cmd, int *rc)
 
 	if (strlencmp(cmd, "level auto") == 0)
 		level = TP_EC_FAN_AUTO;
-	else if ((strlencmp(cmd, "level disengaged") == 0) |
+	else if ((strlencmp(cmd, "level disengaged") == 0) ||
 			(strlencmp(cmd, "level full-speed") == 0))
 		level = TP_EC_FAN_FULLSPEED;
 	else if (sscanf(cmd, "level %d", &level) != 1)
-- 
2.33.0



