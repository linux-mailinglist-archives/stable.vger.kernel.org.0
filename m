Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335C734DB6B
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232885AbhC2W2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:28:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:49442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232122AbhC2WZ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:25:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D77C619C6;
        Mon, 29 Mar 2021 22:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056635;
        bh=8htxVPUxiGcFgjEhReSmjiKB8nfqOjfbio03tjR8IfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KZKl1sKbEsjbB56Y2CHUNN4xduO5V1tbdV82D390yobqjkW5DqB9w/nAmYlSJCVe7
         UWCDvca1umgNW8ThpxfDyK6H/9ocFklCQaWXtUeFs4RscsOx1wAL1DJBlblKPo2uwL
         hDD/as0B9YaqCBEkMcBBN7vUWtRnV8bPjTmSXOilRIdESQKf/4S46XwWrRbuvGCTJb
         quL4ObCV2mw8XczajAFfykMSCMfhBz1JJ7q/KtLgEXGqqlZtArF5c97F+FL8+/Pot6
         TWOA6Y8S3iAl0HCrQXNbhaFDd01L7Zty2/wXaCYn5LPKhla9YhzxAC1Dc8v++Om/+L
         bfl1tv41clMUg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 08/12] x86/build: Turn off -fcf-protection for realmode targets
Date:   Mon, 29 Mar 2021 18:23:41 -0400
Message-Id: <20210329222345.2383777-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222345.2383777-1-sashal@kernel.org>
References: <20210329222345.2383777-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 9fcb51c14da2953de585c5c6e50697b8a6e91a7b ]

The new Ubuntu GCC packages turn on -fcf-protection globally,
which causes a build failure in the x86 realmode code:

  cc1: error: ‘-fcf-protection’ is not compatible with this target

Turn it off explicitly on compilers that understand this option.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20210323124846.1584944-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 9f33a69b5605..146aadeb7c8e 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -35,7 +35,7 @@ REALMODE_CFLAGS	:= $(M16_CFLAGS) -g -Os -D__KERNEL__ \
 		   -DDISABLE_BRANCH_PROFILING \
 		   -Wall -Wstrict-prototypes -march=i386 -mregparm=3 \
 		   -fno-strict-aliasing -fomit-frame-pointer -fno-pic \
-		   -mno-mmx -mno-sse
+		   -mno-mmx -mno-sse $(call cc-option,-fcf-protection=none)
 
 REALMODE_CFLAGS += $(call __cc-option, $(CC), $(REALMODE_CFLAGS), -ffreestanding)
 REALMODE_CFLAGS += $(call __cc-option, $(CC), $(REALMODE_CFLAGS), -fno-stack-protector)
-- 
2.30.1

