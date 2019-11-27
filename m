Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6283A10BDEB
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbfK0Vce (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:32:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:41552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728366AbfK0UxL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:53:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33CEB21774;
        Wed, 27 Nov 2019 20:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887990;
        bh=tbtk4ZJrPTtjXR+uDo9oZZx5WFHNPAYVSs9Zpfb6ccY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TNDWqm5GXrrD8uxciaqmXcuTaM7uYzvG6WWDiWWPExgC8EnvOLLSHrwtuYQaBqkoi
         OAmhuW919Uphjc5pAOfAawJYBrwx8Ywg/Nwhd2aHIBdVLufu3TeLDwWH0O1mk62Y98
         lmuKhfcluobnjLiFcB0nlTKFUxjL+watGGnwXrgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hari Vyas <hari.vyas@broadcom.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 172/211] arm64: fix for bad_mode() handler to always result in panic
Date:   Wed, 27 Nov 2019 21:31:45 +0100
Message-Id: <20191127203110.120376346@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hari Vyas <hari.vyas@broadcom.com>

commit e4ba15debcfd27f60d43da940a58108783bff2a6 upstream.

The bad_mode() handler is called if we encounter an uunknown exception,
with the expectation that the subsequent call to panic() will halt the
system. Unfortunately, if the exception calling bad_mode() is taken from
EL0, then the call to die() can end up killing the current user task and
calling schedule() instead of falling through to panic().

Remove the die() call altogether, since we really want to bring down the
machine in this "impossible" case.

Signed-off-by: Hari Vyas <hari.vyas@broadcom.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/traps.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -648,7 +648,6 @@ asmlinkage void bad_mode(struct pt_regs
 		handler[reason], smp_processor_id(), esr,
 		esr_get_class_string(esr));
 
-	die("Oops - bad mode", regs, 0);
 	local_irq_disable();
 	panic("bad mode");
 }


