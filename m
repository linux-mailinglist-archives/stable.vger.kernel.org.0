Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1E53E811C
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236074AbhHJRzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:55:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236922AbhHJRxn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:53:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7163F61361;
        Tue, 10 Aug 2021 17:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617437;
        bh=Go60ThmHXscegeuQYcMBmI7Z5VB9f+0G8+vWx9I0Tvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JjQnHOlTwEMp2dWVglaM0XX7QiXWXPq2p+QdEhqVObg5a508Cmr9jL4hlFLWh+nLU
         nyO+RKfmFtzCch8+U9mDld473UK0wtuGO/TX9U657W3xifh3bmji6ecnTkrFPsDE0J
         Jwe95FX25SaMrCHW7x4W/7kkPMLEh45fhXLtLrPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 057/175] riscv: Disable STACKPROTECTOR_PER_TASK if GCC_PLUGIN_RANDSTRUCT is enabled
Date:   Tue, 10 Aug 2021 19:29:25 +0200
Message-Id: <20210810173002.819465277@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit a18b14d8886614b3c7d290c4cfc33389822b0535 ]

riscv uses the value of TSK_STACK_CANARY to set
stack-protector-guard-offset. With GCC_PLUGIN_RANDSTRUCT enabled, that
value is non-deterministic, and with riscv:allmodconfig often results
in build errors such as

cc1: error: '8120' is not a valid offset in '-mstack-protector-guard-offset='

Enable STACKPROTECTOR_PER_TASK only if GCC_PLUGIN_RANDSTRUCT is disabled
to fix the problem.

Fixes: fea2fed201ee5 ("riscv: Enable per-task stack canaries")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 18ec0f9bb8d5..3c3647ac33cb 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -489,6 +489,7 @@ config CC_HAVE_STACKPROTECTOR_TLS
 
 config STACKPROTECTOR_PER_TASK
 	def_bool y
+	depends on !GCC_PLUGIN_RANDSTRUCT
 	depends on STACKPROTECTOR && CC_HAVE_STACKPROTECTOR_TLS
 
 config PHYS_RAM_BASE_FIXED
-- 
2.30.2



