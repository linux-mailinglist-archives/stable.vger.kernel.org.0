Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A5049A8F7
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1321691AbiAYDT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:19:28 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37996 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244239AbiAXTsT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:48:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE296B81215;
        Mon, 24 Jan 2022 19:48:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFD6C340E5;
        Mon, 24 Jan 2022 19:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053695;
        bh=16LNaUCzIzb/T+JoyZ/ziwN0gPqMj0yFnQdm07T7pxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=shcIEfWvnM0gbpdkALGEjXiDVd3xiWRmKG35WGE8uVqi+u762JnRbPFx6TpIANYbA
         uZ9OuijgvGMpkD1Ec6q+TMgA+NeYwywhh/SdwjWQ0aok3IhDEgJsjbJqnhUAs5SSoc
         kRu/YdOSaT7QNgMqLFxG7alHqNqiIr5o0Pm2yRno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 140/563] arm64: clear_page() shouldnt use DC ZVA when DCZID_EL0.DZP == 1
Date:   Mon, 24 Jan 2022 19:38:25 +0100
Message-Id: <20220124184029.244698891@linuxfoundation.org>
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

From: Reiji Watanabe <reijiw@google.com>

[ Upstream commit f0616abd4e67143b45b04b565839148458857347 ]

Currently, clear_page() uses DC ZVA instruction unconditionally.  But it
should make sure that DCZID_EL0.DZP, which indicates whether or not use
of DC ZVA instruction is prohibited, is zero when using the instruction.
Use STNP instead when DCZID_EL0.DZP == 1.

Fixes: f27bb139c387 ("arm64: Miscellaneous library functions")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/20211206004736.1520989-2-reijiw@google.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/lib/clear_page.S | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/lib/clear_page.S b/arch/arm64/lib/clear_page.S
index b84b179edba3a..1fd5d790ab800 100644
--- a/arch/arm64/lib/clear_page.S
+++ b/arch/arm64/lib/clear_page.S
@@ -16,6 +16,7 @@
  */
 SYM_FUNC_START_PI(clear_page)
 	mrs	x1, dczid_el0
+	tbnz	x1, #4, 2f	/* Branch if DC ZVA is prohibited */
 	and	w1, w1, #0xf
 	mov	x2, #4
 	lsl	x1, x2, x1
@@ -25,5 +26,14 @@ SYM_FUNC_START_PI(clear_page)
 	tst	x0, #(PAGE_SIZE - 1)
 	b.ne	1b
 	ret
+
+2:	stnp	xzr, xzr, [x0]
+	stnp	xzr, xzr, [x0, #16]
+	stnp	xzr, xzr, [x0, #32]
+	stnp	xzr, xzr, [x0, #48]
+	add	x0, x0, #64
+	tst	x0, #(PAGE_SIZE - 1)
+	b.ne	2b
+	ret
 SYM_FUNC_END_PI(clear_page)
 EXPORT_SYMBOL(clear_page)
-- 
2.34.1



