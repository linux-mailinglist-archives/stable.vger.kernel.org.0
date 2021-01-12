Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2282F3106
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbhALNPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:15:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:54618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404029AbhALM5l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B399523139;
        Tue, 12 Jan 2021 12:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456170;
        bh=dPVc3Mm4fzodO6CxXpRd21e25zByk0dy7tj/Eoa8myw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PNRpHI3rBW58K5lquAW11XjpdGy/M84DWmYRQBwT2IZgev23TbWQjh8mZZGBEJ33a
         Z/hst1H60PGhIPXFqng5gnTEvUB221ub/NXA4ghbKtPbDAO7mcQ0OCDhSlSGQ69+MK
         NAMdSBjJpopJMq9z5rRsvyogh1LfKS1xtdP2quNYviB+iRNCmtYVHe9xtDNIo2Io1S
         Or8hvYnjLVZfjfJQ1dqSJxupGIzNSCV+4jJO204g0zjqKdX8+9S15cyQKp1S7gZ+av
         iz5TIiUdotSwgazGUWOvQdf7p5swF/Mjqk2xiw0zLy30MgWM8tghTDZ1OqXsZHzlxm
         yA0jrafB2KfXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Millikin <john@john-millikin.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 27/51] lib/raid6: Let $(UNROLL) rules work with macOS userland
Date:   Tue, 12 Jan 2021 07:55:09 -0500
Message-Id: <20210112125534.70280-27-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Millikin <john@john-millikin.com>

[ Upstream commit 0c36d88cff4d72149f94809303c5180b6f716d39 ]

Older versions of BSD awk are fussy about the order of '-v' and '-f'
flags, and require a space after the flag name. This causes build
failures on platforms with an old awk, such as macOS and NetBSD.

Since GNU awk and modern versions of BSD awk (distributed with
FreeBSD/OpenBSD) are fine with either form, the definition of
'cmd_unroll' can be trivially tweaked to let the lib/raid6 Makefile
work with both old and new awk flag dialects.

Signed-off-by: John Millikin <john@john-millikin.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/raid6/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/raid6/Makefile b/lib/raid6/Makefile
index b4c0df6d706dc..c770570bfe4f2 100644
--- a/lib/raid6/Makefile
+++ b/lib/raid6/Makefile
@@ -48,7 +48,7 @@ endif
 endif
 
 quiet_cmd_unroll = UNROLL  $@
-      cmd_unroll = $(AWK) -f$(srctree)/$(src)/unroll.awk -vN=$* < $< > $@
+      cmd_unroll = $(AWK) -v N=$* -f $(srctree)/$(src)/unroll.awk < $< > $@
 
 targets += int1.c int2.c int4.c int8.c int16.c int32.c
 $(obj)/int%.c: $(src)/int.uc $(src)/unroll.awk FORCE
-- 
2.27.0

