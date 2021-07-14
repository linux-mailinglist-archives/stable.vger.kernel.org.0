Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355223C8D7C
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236059AbhGNTov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:44:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:38712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235270AbhGNTn1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:43:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE7CF613CF;
        Wed, 14 Jul 2021 19:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291631;
        bh=I8MWdxlpoilUiaepOxNxmoIT1ZEjDxBOyK7pqD1/Bqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UZT92oEQWSwjciaa5Ezj6Qsg4WB/IxMPBlZ8CFZchEqaN4GWPF7r92uyO3sHJ31aF
         e7jZywIPuzLouoJfgmpRV5r0HNcwyrr4PKhUDNsHuXUlcSztkqYTU2ucEmvZD8sMYw
         VBWpnfsWFe+vorhAmzyuY1jSAkkD1kGZl+AeJOliGrkTjzKaHVBplFhCHJEcE0FPDn
         EJ/bAMoeCEMhQzzfqXYgmPKZUl5TSh9JvYRXpHmDr97ZfFHufvOaGPB5hvGVgfAxfO
         z5UGeNtb33A+jW8euIx8CO9lHDNrxh884dwcrP6HZhFypQIKTWK+KWwAOI0X8d5nyk
         QXSThQAjfeuJg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 106/108] s390/traps: do not test MONITOR CALL without CONFIG_BUG
Date:   Wed, 14 Jul 2021 15:37:58 -0400
Message-Id: <20210714193800.52097-106-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit b8e9cc20b808e26329090c19ff80b7f5098e98ff ]

tinyconfig fails to boot, because without CONFIG_BUG report_bug()
always returns BUG_TRAP_TYPE_BUG, which causes mc 0,0 in
test_monitor_call() to panic. Fix by skipping the test without
CONFIG_BUG.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/traps.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/kernel/traps.c b/arch/s390/kernel/traps.c
index 8dd23c703718..662f52eb7639 100644
--- a/arch/s390/kernel/traps.c
+++ b/arch/s390/kernel/traps.c
@@ -277,6 +277,8 @@ static void __init test_monitor_call(void)
 {
 	int val = 1;
 
+	if (!IS_ENABLED(CONFIG_BUG))
+		return;
 	asm volatile(
 		"	mc	0,0\n"
 		"0:	xgr	%0,%0\n"
-- 
2.30.2

