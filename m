Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF3813ED676
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbhHPNVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:21:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240536AbhHPNTw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:19:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF41B632A6;
        Mon, 16 Aug 2021 13:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119680;
        bh=a01H8wLm6Zu59H6wvkNY1oCYyOmh6w5yAlyUoKjNJkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DZzkqUDfUHKiNJlpJoP4PB2zzTfX6PfEAIzTIdcrKOFQzp+8Lgur3EYgVABuaAx1P
         BCNh9Yva80wQePxndQvQP+0c6oK/W7Vq8x8x+4AwhlKHjNo1IkdRKy03uwGcgdFLB9
         O+a3bmvEn+Mmk9xMPok5G7uHO8YJ4Lo9YGuJMIDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 120/151] x86/tools: Fix objdump version check again
Date:   Mon, 16 Aug 2021 15:02:30 +0200
Message-Id: <20210816125448.021323524@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 839ad22f755132838f406751439363c07272ad87 ]

Skip (omit) any version string info that is parenthesized.

Warning: objdump version 15) is older than 2.19
Warning: Skipping posttest.

where 'objdump -v' says:
GNU objdump (GNU Binutils; SUSE Linux Enterprise 15) 2.35.1.20201123-7.18

Fixes: 8bee738bb1979 ("x86: Fix objdump version check in chkobjdump.awk for different formats.")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Link: https://lore.kernel.org/r/20210731000146.2720-1-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/tools/chkobjdump.awk | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/tools/chkobjdump.awk b/arch/x86/tools/chkobjdump.awk
index fd1ab80be0de..a4cf678cf5c8 100644
--- a/arch/x86/tools/chkobjdump.awk
+++ b/arch/x86/tools/chkobjdump.awk
@@ -10,6 +10,7 @@ BEGIN {
 
 /^GNU objdump/ {
 	verstr = ""
+	gsub(/\(.*\)/, "");
 	for (i = 3; i <= NF; i++)
 		if (match($(i), "^[0-9]")) {
 			verstr = $(i);
-- 
2.30.2



