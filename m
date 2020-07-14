Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F7F21FBCD
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730913AbgGNSzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:55:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730895AbgGNSzt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:55:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BC4321D79;
        Tue, 14 Jul 2020 18:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752948;
        bh=ONj7aKbHlOlgWW2rGPQ0J/OhBHcYbrSt/+Ss/muTSBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pllvgva5P8cG0dc2ov9uJHIzlRgL/p85VJWi+6ULeH/v39D7sf2OzrOmVE1qs+ytU
         ARlKIUP+MBWnW+bmjhHRIFu0Dt1V8PKs1m9fL+lxeT9+ScqUA36c9kwhS3VYXkBDy4
         LuLgBADwlSMjNluWjLI/26wR/hzzxRF5A85lY/lw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>,
        Alexander Egorenkov <egorenar@linux.ibm.com>
Subject: [PATCH 5.7 031/166] s390/kasan: fix early pgm check handler execution
Date:   Tue, 14 Jul 2020 20:43:16 +0200
Message-Id: <20200714184117.367925529@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
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
index cd241ee66eff4..0782772318580 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -170,6 +170,8 @@ static noinline __init void setup_lowcore_early(void)
 	psw_t psw;
 
 	psw.mask = PSW_MASK_BASE | PSW_DEFAULT_KEY | PSW_MASK_EA | PSW_MASK_BA;
+	if (IS_ENABLED(CONFIG_KASAN))
+		psw.mask |= PSW_MASK_DAT;
 	psw.addr = (unsigned long) s390_base_ext_handler;
 	S390_lowcore.external_new_psw = psw;
 	psw.addr = (unsigned long) s390_base_pgm_handler;
-- 
2.25.1



