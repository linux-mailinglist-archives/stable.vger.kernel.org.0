Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0001F3CE427
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243691AbhGSPmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:42:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234943AbhGSPgx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:36:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C67EC6112D;
        Mon, 19 Jul 2021 16:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711452;
        bh=NoqSdtFVZGQDdW4n0OopuJMgNrOECC2eVW5CoM7bEVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n/x7OX2IKk67KpYlh7xbUCPpnnF9qkOKU22kmugozhiurRYIIHzm8zOW4Tu2XuTpB
         4E2jHTrw1HGBJ/VP/aEbMlp8pV60K8toUxb+CZ03vm18fk6O0NLWxslf1bJc6bydUA
         Ip7sHZoTjeKRBHLGs3ehmBW0Ce35d3qr0zVjbUvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 346/351] s390/irq: remove HAVE_IRQ_EXIT_ON_IRQ_STACK
Date:   Mon, 19 Jul 2021 16:54:52 +0200
Message-Id: <20210719144956.512273086@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit 0aa4ff7688632a86bdb133fa106f2ccd514b91a7 ]

This is no longer true since we switched to generic entry. The code
switches to the IRQ stack before calling do_IRQ, but switches back
to the kernel stack before calling irq_exit().

Fixes: 56e62a737028 ("s390: convert to generic entry")
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 93488bbf491b..90e1639697b4 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -165,7 +165,6 @@ config S390
 	select HAVE_GCC_PLUGINS
 	select HAVE_GENERIC_VDSO
 	select HAVE_IOREMAP_PROT if PCI
-	select HAVE_IRQ_EXIT_ON_IRQ_STACK
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_LZ4
-- 
2.30.2



