Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC591441635
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbhKAJXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:23:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232280AbhKAJWi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:22:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A65C610CC;
        Mon,  1 Nov 2021 09:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758385;
        bh=RMhknKR+MnZX1z2g3wT+ecbzpg5j0QCQpcLX/edj4ZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q/O/+VPOTo5klUJLZrfRmldgbu1aU5gAtvEP4zyZxJ+g5xWT/pkzHi6qJj0sKtdc6
         P8s2MmT58YMFcIo2djXVHfiRWymHuLiY9Vs5HxOKyaYuYTCKwJoDeomw988iaxfxdP
         J4+y2Pqh52HS5yEXbOoGtFIqcIbAUAcYHK93DGEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 4.9 03/20] ARM: 9139/1: kprobes: fix arch_init_kprobes() prototype
Date:   Mon,  1 Nov 2021 10:17:12 +0100
Message-Id: <20211101082444.874277091@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082444.133899096@linuxfoundation.org>
References: <20211101082444.133899096@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 1f323127cab086e4fd618981b1e5edc396eaf0f4 upstream.

With extra warnings enabled, gcc complains about this function
definition:

arch/arm/probes/kprobes/core.c: In function 'arch_init_kprobes':
arch/arm/probes/kprobes/core.c:465:12: warning: old-style function definition [-Wold-style-definition]
  465 | int __init arch_init_kprobes()

Link: https://lore.kernel.org/all/20201027093057.c685a14b386acacb3c449e3d@kernel.org/

Fixes: 24ba613c9d6c ("ARM kprobes: core code")
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/probes/kprobes/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/probes/kprobes/core.c
+++ b/arch/arm/probes/kprobes/core.c
@@ -666,7 +666,7 @@ static struct undef_hook kprobes_arm_bre
 
 #endif /* !CONFIG_THUMB2_KERNEL */
 
-int __init arch_init_kprobes()
+int __init arch_init_kprobes(void)
 {
 	arm_probes_decode_init();
 #ifdef CONFIG_THUMB2_KERNEL


