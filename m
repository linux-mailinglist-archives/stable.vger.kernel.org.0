Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABFC02F3066
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404526AbhALM6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 07:58:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:53814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404456AbhALM6C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:58:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DC4A23122;
        Tue, 12 Jan 2021 12:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456224;
        bh=dckCnqTvgGne2hGwAjFkC9CrqtWahdtEUmyBy1AmNQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VtPT+wKBalJyJLU64mfj2MDJnmF8Cxkoi2OfBkVszom0BWeaNFsByO1smMaOO6CcS
         LpolRfFocOpbtTnuchgSiyyk3qORN/W5IwfY3hlP78oO3g701zQTU6nYRUqLRFJnpo
         ljGilOs9n3mXr0A4w5HnSnKeq6uJKHTs3XB0luNXe6y+SaVVoILQpYfuT/HGWs7mjq
         JAoioSs4N0ZTozgmoAanfj76t5mYDBWyCnlk8qbJB/n3vE0J+U+65jBVj46WA6WdLP
         BQgsGtomFTAhYN17sSbq1FBlKIF3mEjAWVRVzpiNGvjVkYI7RHaveZhuZtF0ApGfK9
         afemPiNhX5/tg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Millikin <john@john-millikin.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 14/28] lib/raid6: Let $(UNROLL) rules work with macOS userland
Date:   Tue, 12 Jan 2021 07:56:30 -0500
Message-Id: <20210112125645.70739-14-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125645.70739-1-sashal@kernel.org>
References: <20210112125645.70739-1-sashal@kernel.org>
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
index 0083b5cc646c9..d4d56ca6eafce 100644
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

