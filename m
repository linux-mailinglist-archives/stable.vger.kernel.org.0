Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3E84800D0
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238906AbhL0PvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:51:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240657AbhL0Ppa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:45:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237E2C08E9BB;
        Mon, 27 Dec 2021 07:42:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5076B80E5A;
        Mon, 27 Dec 2021 15:42:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B65C36AEA;
        Mon, 27 Dec 2021 15:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619753;
        bh=BFqceTwylg4SkQttS5seN98n5t+IMPsWhcgxfCUwuNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HYbG9ioRJdDggyEx7sIGTjm6/X0xwsC3RRNxjLRDIXf/dXBMmD9z9igL+qo9mqurX
         wVnLnQrw8eY+RsEdqx2AdrftaukKrcHNVcodmvvCLf/L8yKYUQKV8YymYKO7eqaxLB
         YuQ3crA+uTsF8OyLxXsmAVjBrwvja1He9K64QvAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Murzin <vladimir.murzin@arm.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 058/128] ARM: 9160/1: NOMMU: Reload __secondary_data after PROCINFO_INITFUNC
Date:   Mon, 27 Dec 2021 16:30:33 +0100
Message-Id: <20211227151333.447237656@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Murzin <vladimir.murzin@arm.com>

[ Upstream commit 7202216a6f34d571a22274e729f841256bf8b1ef ]

__secondary_data used to reside in r7 around call to
PROCINFO_INITFUNC. After commit 95731b8ee63e ("ARM: 9059/1: cache-v7:
get rid of mini-stack") r7 is used as a scratch register, so we have
to reload __secondary_data before we setup the stack pointer.

Fixes: 95731b8ee63e ("ARM: 9059/1: cache-v7: get rid of mini-stack")
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/head-nommu.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/kernel/head-nommu.S b/arch/arm/kernel/head-nommu.S
index 0fc814bbc34b1..8796a69c78e00 100644
--- a/arch/arm/kernel/head-nommu.S
+++ b/arch/arm/kernel/head-nommu.S
@@ -114,6 +114,7 @@ ENTRY(secondary_startup)
 	add	r12, r12, r10
 	ret	r12
 1:	bl	__after_proc_init
+	ldr	r7, __secondary_data		@ reload r7
 	ldr	sp, [r7, #12]			@ set up the stack pointer
 	mov	fp, #0
 	b	secondary_start_kernel
-- 
2.34.1



