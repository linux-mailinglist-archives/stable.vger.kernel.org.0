Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2C52FA317
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404926AbhAROcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:32:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:39226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390711AbhARLoE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:44:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64CC022D3E;
        Mon, 18 Jan 2021 11:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970191;
        bh=dPVc3Mm4fzodO6CxXpRd21e25zByk0dy7tj/Eoa8myw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WdItjQBaXJljj/3BBGAFrwWbJdKKwIWFSl6S2XpNqcoCGo8Y73TuEAMVTHkULc8fF
         fO85oqp9l1FlKv2QveuU7QflmjFquWQ3QiGj+QdPB5w9uKGsmSpoVICPniMyc8UFIw
         R2jVoc+cwS8JuX9tb3vG79HVbItrpLlR81KFfl3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Millikin <john@john-millikin.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/152] lib/raid6: Let $(UNROLL) rules work with macOS userland
Date:   Mon, 18 Jan 2021 12:34:11 +0100
Message-Id: <20210118113356.431210148@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



