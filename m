Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF4A21FD03
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729376AbgGNSqO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:46:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729337AbgGNSqJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:46:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAE2C22282;
        Tue, 14 Jul 2020 18:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752369;
        bh=/gmxHS3XLDyTXY59bVZQeIR8YytUDZlxFAMR595dCLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cnTLTuFao7GCqxqKUdwMEsJKyMuti4NYz5dOTxB7TVyyMTWV9nUxtmPpoFsbBwEuU
         1RvCSvrzshy0uiGo3Ho1xhFZm77X5wqzK8tFkdCxQBuwXGzH/P3/nsmxiRaRnZZUs4
         fy61WRUmtgij81BNHO7prgGsLyrZB8WLInkGO/Z8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>,
        Alexander Egorenkov <egorenar@linux.ibm.com>
Subject: [PATCH 4.19 16/58] s390/kasan: fix early pgm check handler execution
Date:   Tue, 14 Jul 2020 20:43:49 +0200
Message-Id: <20200714184056.958041028@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184056.149119318@linuxfoundation.org>
References: <20200714184056.149119318@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit 998f5bbe3dbdab81c1cfb1aef7c3892f5d24f6c7 ]

Currently if early_pgm_check_handler is called it ends up in pgm check
loop. The problem is that early_pgm_check_handler is instrumented by
KASAN but executed without DAT flag enabled which leads to addressing
exception when KASAN checks try to access shadow memory.

Fix that by executing early handlers with DAT flag on under KASAN as
expected.

Reported-and-tested-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Reviewed-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/early.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index e7e6608b996c6..ad88bed743954 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -155,6 +155,8 @@ static noinline __init void setup_lowcore_early(void)
 	psw_t psw;
 
 	psw.mask = PSW_MASK_BASE | PSW_DEFAULT_KEY | PSW_MASK_EA | PSW_MASK_BA;
+	if (IS_ENABLED(CONFIG_KASAN))
+		psw.mask |= PSW_MASK_DAT;
 	psw.addr = (unsigned long) s390_base_ext_handler;
 	S390_lowcore.external_new_psw = psw;
 	psw.addr = (unsigned long) s390_base_pgm_handler;
-- 
2.25.1



